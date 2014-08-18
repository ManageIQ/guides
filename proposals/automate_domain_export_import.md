# Background
A domain is a collection of namespaces, classes, instances and methods. The community based project will ship with single domain called ManageIQ, which will have the model for the basic functionality of the project. Other domains can be added by the customer. As part of this change the export/import of the automate model has changed from a single XML file to multiple YAML files for every level (domain, namespace, class, instance, methods) and method scripts. The model can be exported into a directory or it can be zipped up into a single file. This wiki explains the changes to the export import process.

# Export
An automate domain can be exported into a directory or a single zip file or a single yaml file. To export a model from the Automate database the following options are supported

1. DOMAIN = Name of domain to export, names are case insensitive. Specify "*" to export all domains.
2. ZIP_FILE = Name of the zip file to create that would store the automate model.

 **OR**

   EXPORT_DIR = Name of the directory that will store the automate model. If the directory doesn't exist it will get created during the export process

 **OR**

   YAML_FILE = Name of the YAML file that will store the entire automate model.
 
3. OVERWRITE = true | false (Default: false) If the ZIP_FILE or EXPORT_DIR or YAML_FILE exists can it be overwritten. The default value is false, so if the ZIP_FILE or EXPORT_DIR or YAML_FILE exists the export process will fail.

4. EXPORT_AS = **(Optional)** Name of the domain to export as 

e.g.
To export a domain called SAMPLE into a directory use the following 
* _bin/rake evm:automate:export DOMAIN=SAMPLE EXPORT_DIR=/tmp/export_data_

To export a domain called SAMPLE into a ZIP file use the following
* _bin/rake evm:automate:export DOMAIN=ManageIQ ZIP_FILE=/tmp/sample.zip_

To export a domain called SAMPLE into a YAML file use the following 
* _bin/rake evm:automate:export DOMAIN=SAMPLE YAML_FILE=/tmp/sample.yaml_

To export a domain called SAMPLE as DEMO use the following
* _bin/rake evm:automate:export DOMAIN=SAMPLE EXPORT_DIR=/tmp/export_data EXPORT_AS=DEMO_

To export a domain called SAMPLE as DEMO in ZIP format use the following
* _bin/rake evm:automate:export DOMAIN=SAMPLE ZIP_FILE=/tmp/demo.zip EXPORT_AS=DEMO_

To export a domain called SAMPLE as DEMO in YAML file use the following
* _bin/rake evm:automate:export DOMAIN=SAMPLE YAML_FILE=/tmp/demo.yaml EXPORT_AS=DEMO_

To export all domains in ZIP format use the following
* _bin/rake evm:automate:export DOMAIN=* ZIP_FILE=/tmp/demo.zip_

To export all domains into a directory use the following
* _bin/rake evm:automate:export DOMAIN=* EXPORT_DIR=/tmp/export_all_domains_

To export all domains into a single YAML file use the following
* _bin/rake evm:automate:export DOMAIN=* YAML_FILE=/tmp/all_domains.yaml_

# Import
Import currently only works with importing into a new domain, it doesn't do a differencing and only apply the changes to an existing domain. The model to be imported can be in a zip file or in a directory. The new imported domains are always marked as disabled. The command line options are

1. DOMAIN = Name of the exported domain (name of domain created will be the same). Specify "*" to import all exported domains.

2. PREVIEW = true | false (Default: true), in a preview mode we don't update the database, we just print the stats for the import process.

3. IMPORT_DIR = The directory where the model data is stored

   **OR**

   ZIP_FILE = The zip file that has the model

   **OR**
   
   YAML_FILE = The single YAML file that has the automate model

4. IMPORT_AS = (**Optional**) Name of the domain to create in the Automate database, the domain name can only be set when importing a single domain.

5. NAMESPACE = (**Optional**) Namespace to be imported. A single namespace can be imported from a domain export by specifying the NAMESPACE argument.  

6. CLASS = (**Optional**) Class to be imported.  Must be accompanied by the NAMESPACE argument. A single class can be imported from a domain export by specifying the NAMESPACE and CLASS arguments.  

7. PRIORITY = (**Optional**) Sets the priority of the imported domain. Default value of priority is read from the exported model. This property can only when be set when importing a single domain. Priority is a whole number greater than 0.

8. SYSTEM = (**Optional**) true|false Sets the system attribute for the imported domain. Default value of system is read from the exported model. This property can only when be set when importing a single domain. 

9. ENABLED = (**Optional**) true|false Sets the enabled attribute for the imported domain. Default value of enabled is read from the exported model. This property can only when be set when importing a single domain.

Examples:
To import a domain called SAMPLE from a directory use the following command
* _bin/rake evm:automate:import DOMAIN=SAMPLE IMPORT_DIR=/tmp/exported_data PREVIEW=false_

To import a domain called SAMPLE from a zip file use the following command
* _bin/rake evm:automate:import DOMAIN=SAMPLE ZIP_FILE=/tmp/sample.zip PREVIEW=false_

To import a domain called SAMPLE as DEMO from a directory use the following
* _bin/rake evm:automate:import DOMAIN=SAMPLE IMPORT_AS=DEMO IMPORT_DIR=/tmp/exported_data PREVIEW=false_

To import a domain called SAMPLE as DEMO from a zip file use the following
* _bin/rake evm:automate:import DOMAIN=SAMPLE IMPORT_AS=DEMO ZIP_FILE=/tmp/sample.zip PREVIEW=false_

To import a namespace called INFRASTRUCTURE from the domain called SAMPLE from a zip file use the following
* _bin/rake evm:automate:import DOMAIN=SAMPLE NAMESPACE=INFRASTRUCTURE EXPORT_DIR=./monday_model_export PREVIEW=false

To import a class named PROVISIONING from a namespace called INFRASTRUCTURE in the SAMPLE domain  from a zip file use the following
* _bin/rake evm:automate:import DOMAIN=SAMPLE NAMESPACE=INFRASTRUCTURE CLASS=PROVISIONING EXPORT_DIR=./monday_model_export PREVIEW=false

# Migration

When a customer migrates from any of the previous versions of CFME 5.2 their existing namespaces are moved under a domain called CUSTOMER. The next time the CFME server is restarted it would seed the ManageIQ domain.

# Conversion

The earlier format for exporting and importing the automate model was XML. So it's possible that there might be old XML files to import into a 5.3 database. Since the old format didn't have a domain, a domain name has to be provided when doing the conversion. The converted model can then be imported into the database using the import command from above.

The command line options for convert are
 
1. FILE = The name of the legacy XML automate file
2. DOMAIN = The name of the domain to create
3. EXPORT_DIR = The name of the directory where the converted model would be stored

   **OR**

   ZIP_FILE = The name of the zip file where the converted model would be stored

   **OR**

   YAML_FILE = The name of the YAML file where the converted model would be stored.

4. OVERWRITE = true | false (Default: false). If a directory or the zip or yaml file exists and OVERWRITE value is false the conversion process will stop

e.g.

To convert a XML model file called database.xml as a domain called SAMPLE into a directory use the following.

* _bin/rake evm:automate:convert FILE=database.xml DOMAIN=SAMPLE EXPORT_DIR=/tmp/converted_model_

To convert a XML model file called database.xml as a domain called SAMPLE into a single YAML file use the following.

* _bin/rake evm:automate:convert FILE=database.xml DOMAIN=SAMPLE YAML_FILE=/tmp/sample_model.yaml_

To convert a XML model file called database.xml as a domain called SAMPLE into a zip file use the following

* _bin/rake evm:automate:convert FILE=database.xml DOMAIN=SAMPLE ZIP_FILE=/tmp/sample_converted.zip_

To convert a XML model file called database.xml as a domain called SAMPLE into an existing directory and overwrite the files use the following command

* _bin/rake evm:automate:convert FILE=database.xml DOMAIN=SAMPLE EXPORT_DIR=/tmp/converted_model OVERWRITE=true_

