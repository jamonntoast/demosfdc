#Purpose
This is a stub repo to show how to do Salesforce CI/CD using Bitbucket Cloud with Pipelines. It can be forked and used as a starting point for your production repo.

#Repo Setup
This model utilizes repo forks for different Salesforce environments. The Production repo should be the main repo. A fork from Prod should then be created for UAT/Staging. Lastly, a fork for dev should be created from the UAT/Staging fork. This will allow for easy downstream syncing of changes (eg. for UI-based changes made directly in production that should flow downstream).

Before creating your UAT/Staging and dev forks, you may want to add your Salesforce metadata to the src folder using your IDE. You can also follow the instructions in the "Saving UI-based Changes" section to retrieve your metadata using Pipelines. Make sure to update package.xml to reflect the metadata that you'll track.

#Docker Image
Pipelines uses a default Docker image that does not include Apache Ant, which is required by the Force.com Migration Tool. As such, I've created a lean Docker image that can be used for Salesforce deployments and have specified that this image be used in the bitbucket-pipelines.yml file. The image's Dockerfile can be found at https://hub.docker.com/r/mklinski/salesforce/~/dockerfile/ if you'd like to create your own image to use.

#Force.com Migration Tool
The Force.com Migration Tool JAR and related settings files (build.xml and build.properties) have been added to this repo instead of embedding them in the Docker image. This allows for greater flexibility to updating the Migration Tool JAR when new Salesforce releases happen and to create/modify build targets.

#Initial Setup
1. Turn on Pipelines for your repo.
2. Create a Bitbucket user that will be used for committing metadata changes from Salesforce to your repo. Set up SSH for that user per https://confluence.atlassian.com/display/BITBUCKET/Set+up+SSH+for+Bitbucket+Pipelines. You'll need that user account's information and SSH key for the next step. (The Bitbucket public key has already been saved in this repo in the "my_known_hosts" file).
3. Set up Account-level and Repo-level variables:
	1. Account-level Environment Variables (https://bitbucket.org/account/user/[Bitbucket Username]/addon/admin/pipelines/account-variables#!/variables)
		* SSH_KEY = SSH key for that user that was created in the previous step
		* GIT_USERNAME = Bitbucket username for that account
		* GIT_EMAIL = Email address associated with the same account
		* SFDC_PASS = Salesforce user password for your deployment user, assuming your Pipelines deployment user password will be shared across your Salesforce prod and sandbox instances
		* SFDC_SERVERURL = test.salesforce.com (or 'login.salesforce.com' if the majority of your Salesforce orgs are Dev Edition)
	2. Repo-level Environment Variables (https://bitbucket.org/[Bitbucket Username]/[Repo]/admin/addon/admin/pipelines/repository-variables#!/variables)
		* SFDC_USERNAME = The full username for your Salesforce deployment user (eg. 'bitbucket@example.com.dev')
		* SFDC_TOKEN = The security token for that user on that particular instance
		* SFDC_SERVERURL = login.salesforce.com (only needed when you're overriding the Account-level env variable for that particular repo/Salesforce instance)
4. Make sure you've got your supplemental branches set up for destructive changes and for manually saving UI-based changes. If you're forking this repo, then you'll have them already:
	* "destroy-base" (or similar): this includes a template for creating "destroy/*" branches which will run destructive changes.
	* "save-changes": This branch includes a update_to_trigger_pipelines.txt file that can be edited directly in the Bitbucket UI to trigger commits for UI-based changes. This branch name is specified in bitbucket-pipelines.yml, so if you use a different branch name, change the pipeline there, too.

#Workflows
##Feature Branches
If you're creating a feature branch off of your dev repo's master branch, make sure its name starts with "feature/" (eg. "feature/SFDC-123-new-lead-trigger"). When you push commits to Bitbucket, Pipelines will automatically run a validation build against your dev environment.

##Destructive Changes
In your dev repo, create a branch off of the destroy-base branch and make sure its name starts with "destroy/" (eg. "destroy/SFDC-124-removing-custom-fields"). Make appropriate updates to the destructiveChanges.xml file, commit, and push those changes to run them against your dev sandbox. These branches aren't meant to be merged back into destroy-base or master; they exist purely for the purpose of running those destructive changes against the associated Salesforce org. To run those changes against UAT/Staging and Prod, you'll need to create a pull request for that branch from dev to Staging/UAT. When you do, choose the option to create a new branch in the upstream fork and leave the branch name the same (ie. "destroy/..."). Once you merge the pull request, the destructive changes will automatically run against UAT/Staging. Repeat the process from UAT/Staging to Prod.

After destructive change successfully run on the given org, the Save Changes process (see "Saving UI-based Changes" below) will run to reflect that metadata has been removed from the org and shouldn't be recreated when a deployment takes place. The last commit message on the working "destroy/*" branch will be reused as the commit message for the metadata removal on the master branch. Beware that the process will also commit any changes that have been made in the UI but not yet committed to the repo (eg. a formula field being updated in the UI right before the destructive changes were committed).

##Saving UI-based Changes
When UI-based changes are made (eg. a custom object/field is added, a workflow rule is updated, etc.) the associated metadata can be saved to the respective repo. This can be done completely through the Bitbucket UI, which is helpful for users that may not have a full dev environment/IDE setup. The package.xml on the master branch of the given repo will be used to determine which metadata is downloaded and committed. All that's required is updating the update_to_trigger_pipelines.txt file in the save-changes branch of the repo for a given Salesforce org:

1. Go to https://bitbucket.org/[Bitbucket Username]/[Repo]/branch/save-changes.
2. Click on the "View source" button.
3. Click on the update_to_trigger_pipelines.txt file.
4. Click "Edit".
5. Create a custom commit message to designate what the changes being committed are related to. If using JIRA, start with the relevant issue key (eg. "SFDC-122: Adding custom fields").
6. Click "Commit" and add a commit message. It could even be the same text that was just written in the file.
7. Verify the changes have been successfully committed to the master branch.