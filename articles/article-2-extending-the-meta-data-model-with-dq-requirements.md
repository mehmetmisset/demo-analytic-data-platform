# __Data Quality Requirements__
## *__How to capture them into (meta) data model and why you should!__*

by Mehmet (P.R.M.) Misset

##  __1. The General Idea__

<p style="text-align: center;"><i>
    "Let agree that the implementation of a `Data Quality`-requirement is in essence the same thing as a `Data Transformation`, with the special feature that the all the results end up in the same `target`-dataset."
</i></p>

---

### __1.1. Requirements need gathering always__

In any (data quality) project, gathering requirements is a fundamental step, data quality project this is no diffent, in in our previous article [Data Ingestion / Transformation Requirements](article-1-data-ingestion-transformation-requirements.md) we discussed the many benifites of captuing requirements in a *meta-data-model*. Let do a short summary

> 1. __*General Idea (the same goes for data quality):*__ Requirements should be documented in a structured way to ensure they are accessible, traceable, and manageable.
> 2. __*Importance of Requirements Gathering:*__ Gathering requirements is fundamental in any data project.
Storing requirements in a structured way saves time and reduces the risk of missing or misinterpreting them.
> 3. __*Integration into Development Process:*__ Integrating structured storage of requirements ensures consistency and alignment across the project lifecycle. Enhances collaboration and streamlines the development process.
> 4. __*Benefits of Standardization:*__ Maintains uniformity across projects. Facilitates better communication and understanding among stakeholders. Key features include scalability, compliance with naming conventions, parallel processing, and vendor independence.
> 5. __*Improved Insight and Visibility:*__ Provides better tracking of changes, dependencies, and potential issues. Centralized storage allows for quick access and review by stakeholders.
> 6. __*Automation:*__ Automates various aspects of the development process, reducing manual effort and minimizing errors. Key aspects include automatic dependency handling, technical documentation generation, automatic data lineage, and easy reloading of datasets.
> 7. __*Metadata Model:*__ Defines the structure and relationships of data elements within a system. Captures key data elements such as datasets, attributes, transformations, and business keys. Ensures necessary information is obtained efficiently.
> 8. __*Git Repository and Development Process:*__ Ensures all changes to the metadata model are tracked and documented. Supports branching and merging for effective collaboration.
> 9. __*Front-End Tool:*__ A simple front-end tool, like Microsoft Access, can help manage the metadata. Should be programmed to extract metadata from the repository and present it in a user-friendly way. Stored in the Git repository for easy distribution and updates.

At the end of the article the a conclusion was given as follows, *"Capturing data ingestion and transformation requirements into a metadata model enhances the development process. Ensures requirements are accurately captured, managed, and utilized throughout the project lifecycle."*

## 1.2. __*Data Quality*__ requirements

With the above in mind, the same priciples should be applied to gathering __Requirement__ for __*Data Quality*__. Where in de previous [article](article-1-data-ingestion-transformation-requirements.md) the main __*Requirements*__ were related to __*Datasets*__ and __*Attributes**__ in the case of __*Ingestion*__ parameters were involved, for __*Data Quality*__ 6 more types of __*Requirements*__ are needed. The list below will provide nice short and compact overview. The first 3 are fairly static and are mostly used ider describe properties of the __*DAta Quality Controls*__ or how the __*Results*__ should interpreted.

| __Name__   | __Description__ | Is Static | Responsiblily |
|:-----------|:----------------|:----------|:-------------|
| Result Status | This is the posible outcome of the __*Mesurement*__ done by the __*Data Qualiaty Control*__, there a mainly 4 results, "OKE", "NOK", "OOS" (Out of Scope) and "UNK" (Unknown/Invalid). | Yes | Data Engineering |
| Risk Level | __*Data Quality Risk Level*__ refers to the potential impact and likelihood of data quality issues affecting an organization's operations, decision-making, and overall objectives. It assesses the severity of risks associated with poor data quality, such as inaccuracies, incompleteness, or inconsistencies, and helps prioritize areas that need attention. By evaluating the data quality risk level, organizations can implement appropriate measures to mitigate these risks and ensure reliable and accurate data for their needs. | Yes | Data Engineering |
| Dimensions | A __*Data Quality Dimension*__ is a specific aspect or characteristic used to evaluate the quality of data. These dimensions provide a framework for assessing how well data meets the needs of its intended use. Each dimension focuses on a different attribute of data, such as accuracy, completeness, consistency, and timeliness, among others. By examining these dimensions, organizations can ensure their data is reliable, accurate, and fit for purpose. | Yes | Data Engineering |
| Requirements | A __*Data Quality Requirement*__ is a specific criterion or standard that data must meet to be considered acceptable for its intended use. These requirements are defined based on the needs of the organization and the context in which the data will be used. They ensure that data is fit for purpose by specifying the necessary levels of accuracy, completeness, consistency, timeliness, and other quality dimensions. Meeting these requirements is crucial for reliable data analysis, decision-making, and operational efficiency. | No | Business |
| Control | __*Data Quality Control*__ refers to the implementation of the __*Data Quality Requirement*__ on specific dataset(s)/record(s). The __*Data Quality Control*__ is also linked to the __*Data Quality Dimension*__ and containts the __*Query*__ that should be executed to determine the __*Data Quality Results*__. | No | Business / Data Engineer |
| Threshold | Data Quality Thresholds are predefined limits or criteria that data must meet to be considered acceptable for its intended use. These thresholds are set based on the specific quality dimensions, such as accuracy, completeness, and consistency. They serve as benchmarks to evaluate whether data meets the required standards. For example, a threshold might specify that no more than 2% of data entries can be missing for the dataset to be deemed complete. By establishing these thresholds, organizations can systematically assess and ensure the quality of their data. | No | Business |

We should hold in mind that __*Data Quality Controls*__ are related to a __*Dataset*__ the __*Data Quality Requirements*__ are NOT. The entity diagram of the next section shows the relationship between the diffent __*Requirements*__.
The final to 2 entities in the __*Datamodel*__ are __*Data Quality Results*__ and __*Data Quality Totals*__, these are NOT requirements that need to be gather, but are the __*target*__-datasets of any __*Data Quality Control*__. Here the __*Data Quality Results*__ is where the outcome of the measurement for the __*Data Quality Control*__ is strored, here to reference to individual records by __*businesskey*__ is posible (the struction of the table should support multiple businesskey, how many depends on business requirements, for example if there are many __*Data Quality Controls*__ with 4 involved __*datasets*__ all should support max 4 __*businesskeys*__). The results are counted and aggregated over the __*Data Quality Result Status*__ into __*Data Quality Totals*__. By joining the __*Data Quality Totals*__ with the __*Data Quality Thresholds*__ a interpretation can be done and the __*Data Quality*__ of the __*Dataset*__  classified on the level of a __*Data Quality Control*__ and for __*Dataset*__ as a whole. 

In short the "__*Target*__"-datasets for __*Data Quality Results*__ and __*Data Quality Totals*__ have a perdictable format,see listing below (inline with the 4 __*businesskeys*__-example to illustate ther required attributes). 
 
 - __*Data Quality Results*__ 
   - Businesskey Value of Dataset 1 (Main dataset being measured)
   - Businesskey Value of Dataset 2 (If 2nd dataset is involved reference the related Businesskey.)
   - Businesskey Value of Dataset 3 (If 3rd dataset is involved reference the related Businesskey.)
   - Businesskey Value of Dataset 4 (If 4th dataset is involved reference the related Businesskey.)
   - Data Quality Result Status (OKE, NOK or OOS)
    
 - __*Data Quality Totals*__
   - \# OKE (count of records that reference "OKE")
   - \# NOK (count of records that reference "NOK")
   - \# OOS (count of records that reference "OOS")

Now we that we know what __*Requirements*__ are needed, the __*meta-data-mode*__ needs to be extented.  

### Extented meta-data-model with __*Data Quality*__-requirements

[![](https://mermaid.ink/img/pako:eNp1k8GSmzAMhl_F4zObJlnwAtPZmU5zbA_t9tTSgxNrwROwE1nuNE3y7jUksJSk3CR_-mX9Rke-sQp4zgFXWpYom8IUhoVPOfpR8JUk6YAK_vOSldRmPxChXnuCLn85wW195dkXL2tNB_ZVuy37BL-gHurVXk2plW7AgHHamhGGN2Kw9xohsDTCNlPsozWEdtyQpsi3CsFVtlaj26t9c9vQ-XrcS94IWZK1Gwgkd1-DvZAk7_5ph-x0eng4HdsZWM4Krh3Tza7uBgTFdDBjsGzKVtIxa5hF1liEFhzerEfDQ_XoIPR2OmragHQeQ8f1oeBseE1yb2zTs95Nbra5AzmyqE35fo3vnq_i7Uzuf4XyXqEsS4RSBie6EDsfe4k7IjTyBcbGXH_NKdkPQzZoEuAOsKd5xBvARmoV1uLY5gpOVZih4G2lkrht0XPgpCf7cjAbnr-GHwEijtaX1RD5nQoTXPdqyO6k-W5tiAn9JeT5kf_m-SKJZyLLntK5EHGSiMcs4geeZ4tZlmZPi1g8inSZLuJzxP90AvOZmKdxIpJkOV-mIhERB6WDi58vO92t9vkvHFNCGA?type=png)](https://mermaid.live/edit#pako:eNp1k8GSmzAMhl_F4zObJlnwAtPZmU5zbA_t9tTSgxNrwROwE1nuNE3y7jUksJSk3CR_-mX9Rke-sQp4zgFXWpYom8IUhoVPOfpR8JUk6YAK_vOSldRmPxChXnuCLn85wW195dkXL2tNB_ZVuy37BL-gHurVXk2plW7AgHHamhGGN2Kw9xohsDTCNlPsozWEdtyQpsi3CsFVtlaj26t9c9vQ-XrcS94IWZK1Gwgkd1-DvZAk7_5ph-x0eng4HdsZWM4Krh3Tza7uBgTFdDBjsGzKVtIxa5hF1liEFhzerEfDQ_XoIPR2OmragHQeQ8f1oeBseE1yb2zTs95Nbra5AzmyqE35fo3vnq_i7Uzuf4XyXqEsS4RSBie6EDsfe4k7IjTyBcbGXH_NKdkPQzZoEuAOsKd5xBvARmoV1uLY5gpOVZih4G2lkrht0XPgpCf7cjAbnr-GHwEijtaX1RD5nQoTXPdqyO6k-W5tiAn9JeT5kf_m-SKJZyLLntK5EHGSiMcs4geeZ4tZlmZPi1g8inSZLuJzxP90AvOZmKdxIpJkOV-mIhERB6WDi58vO92t9vkvHFNCGA)

### front-end tooling

In the previous article a front-end tool was discussed, what good candidate was and why we should want on. The same arguments are here also valid, even morea so where datamodel is abit more complex




# 2 How to use these __*Requirements*__?

text about how data quality controls are nothing more the transformations

## 2.1. Example for __*Data Quality Control*__

some text on what to do

table is attributes (nasme and description) and example values

## Why should we do this, in this way?

some text on Why should we do this, in this way? listing benifits and what business value is will deliver.

# 3 Automatically mapping __*Datasets*__ and __*Attributes*__ for __*Data Quality*__

## 3.1 Mapping for individual __*Data Quality Controls*__

### 3.1.1. Mapping __*Data Quality Control*__ to __*Dataset (for DQ Result)*__

mermaid diagram and mapping from DQ control/result to dataset / attribute definitions

### 3.1.2. Mapping __*Data Quality Result*__ to __*Dataset (for DQ Totals)*__

mermaid diagram and mapping from DQ control/totals to dataset / attribute definitions

## 3.2 Mapping the aggregation of individual __*Data Quality Results/Totals*__ to final __*Data Quality Result/Totals*__

mermaid diagram and mapping from DQ control/totals to dataset / attribute definitions
