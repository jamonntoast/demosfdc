
ant -f buildDev0.xml retrieveUnpackaged -DenvName=cpqDev0  -Dpackage.retrieve=package.xml -DsfdcPath=New




Select Id, Name, CreatedDate, vlocity_cmt__GlobalKey__c FROM vlocity_cmt__ObjectLayout__c 
Select Id, Name, CreatedDate, vlocity_cmt__GlobalKey__c FROM vlocity_cmt__ObjectFacet__c
Select Id, Name, CreatedDate, vlocity_cmt__GlobalKey__c FROM vlocity_cmt__ObjectSection__c
Select Id, Name, CreatedDate, vlocity_cmt__GlobalKey__c FROM vlocity_cmt__ObjectElement__c


Select Id, Name, CreatedDate, vlocity_cmt__GlobalKey__c FROM vlocity_cmt__AttributeAssignment__c


Defect Type
Defect Injected Phase
Defect Earliest Detectable Phase



# Source Org
vlocity -propertyfile build_source.properties -job EPC.yaml runJavaScript -js cleanData.js
vlocity -propertyfile build_source.properties -job EPC.yaml packUpdateSettings
vlocity -propertyfile build_source.properties -job EPC.yaml packExport

# Target Org
vlocity -propertyfile build_target.properties -job EPC.yaml runJavaScript -js cleanData.js
vlocity -propertyfile build_target.properties -job EPC.yaml refreshProject
vlocity -propertyfile build_target.properties -job EPC.yaml packUpdateSettings
vlocity -propertyfile build_target.properties -job EPC.yaml packDeploy
vlocity -propertyfile build_target.properties -job EPC.yaml packRetry



packRetry
packContinue
refreshProject			##This command helps fix any broken references in the project.
vlocity -propertyfile build_cpqdev0.properties -job OpX_ProductModel.yaml
vlocity -propertyfile build_cpqdev0.properties -job OpX_Workflows.yaml


SOURCE
vlocity -propertyfile build_cpqdev0.properties -job OpX_ProductModel.yaml runJavaScript -js cleanData.js
vlocity -propertyfile build_cpqdev0.properties -job OpX_Workflows.yaml runJavaScript -js cleanData.js
vlocity -propertyfile build_cpqdev0.properties -job OpX_ProductModel.yaml packUpdateSettings
vlocity -propertyfile build_cpqdev0.properties -job OpX_Workflows.yaml packUpdateSettings
vlocity -propertyfile build_cpqdev0.properties -job OpX_ProductModel.yaml packExport
vlocity -propertyfile build_cpqdev0.properties -job OpX_Workflows.yaml packExport


TARGET
vlocity -propertyfile build_cpqsit1.properties -job OpX_ProductModel.yaml runJavaScript -js cleanData.js
vlocity -propertyfile build_cpqsit1.properties -job OpX_Workflows.yaml runJavaScript -js cleanData.js
vlocity -propertyfile build_cpqsit1.properties -job OpX_ProductModel.yaml refreshProject
vlocity -propertyfile build_cpqsit1.properties -job OpX_Workflows.yaml refreshProject
vlocity -propertyfile build_cpqsit1.properties -job OpX_ProductModel.yaml packUpdateSettings
vlocity -propertyfile build_cpqsit1.properties -job OpX_Workflows.yaml packUpdateSettings
vlocity -propertyfile build_cpqsit1.properties -job OpX_ProductModel.yaml packDeploy
vlocity -propertyfile build_cpqsit1.properties -job OpX_Workflows.yaml packDeploy
vlocity -propertyfile build_cpqsit1.properties -job OpX_ProductModel.yaml packRetry
vlocity -propertyfile build_cpqsit1.properties -job OpX_Workflows.yaml packRetry






Select Id FROM vlocity_cmt__PDFDocumentTemplate__c
Select Id FROM vlocity_cmt__CustomFieldMap__c
Select Id FROM vlocity_cmt__CpqConfigurationSetup__c


john mecialla
damien glass

yield --> 