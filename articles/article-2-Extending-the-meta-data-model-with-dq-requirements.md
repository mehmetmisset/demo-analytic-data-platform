# __Data Quality Requirements__
## *__How to capture them into (meta) data model and why you should!__*

by Mehmet (P.R.M.) Misset

##  __1. The General Idea__

<p style="text-align: center;"><i>
    "Let agree that the implementation of a `Data Quality`-control is in essence the same thing as a `Data Transformation`, with the special feature that the all the results end up in the same `target`-dataset."
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

With the above in mind, the same priciples should be applied to gathering __Data Quality Requirement__. Where in de previous [article](article-1-data-ingestion-transformation-requirements.md) the main __*Requirements*__ were related to __*Datasets*__ and __*Attributes**__ in the case of __*Ingestion*__ parameters were involved. However with __*Data Quality*__ 6 more types of __*Requirements*__ are needed. The list below will provide nice short and compact overview. The first 3 are fairly static and are mostly used ider describe properties of the __*DAta Quality Controls*__ or how the __*Results*__ should interpreted.

| __Name__   | __Description__ | Is Static | Responsiblily |
|:-----------|:----------------|:----------|:-------------|
| Result Status | This is the posible outcome of the __*Mesurement*__ done by the __*Data Qualiaty Control*__, there a mainly 4 results, "OKE", "NOK", "OOS" (Out of Scope) and "UNK" (Unknown/Invalid). | Yes | Data Engineering |
| Risk Level | __*Data Quality Risk Level*__ refers to the potential impact and likelihood of data quality issues affecting an organization's operations, decision-making, and overall objectives. It assesses the severity of risks associated with poor data quality, such as inaccuracies, incompleteness, or inconsistencies, and helps prioritize areas that need attention. By evaluating the data quality risk level, organizations can implement appropriate measures to mitigate these risks and ensure reliable and accurate data for their needs. | Yes | Data Engineering |
| Dimensions | A __*Data Quality Dimension*__ is a specific aspect or characteristic used to evaluate the quality of data. These dimensions provide a framework for assessing how well data meets the needs of its intended use. Each dimension focuses on a different attribute of data, such as accuracy, completeness, consistency, and timeliness, among others. By examining these dimensions, organizations can ensure their data is reliable, accurate, and fit for purpose. | Yes | Data Engineering |
| Requirements | A __*Data Quality Requirement*__ is a specific criterion or standard that data must meet to be considered acceptable for its intended use. These requirements are defined based on the needs of the organization and the context in which the data will be used. They ensure that data is fit for purpose by specifying the necessary levels of accuracy, completeness, consistency, timeliness, and other quality dimensions. Meeting these requirements is crucial for reliable data analysis, decision-making, and operational efficiency. | No | Business |
| Control | __*Data Quality Control*__ refers to the implementation of the __*Data Quality Requirement*__ on specific dataset(s)/record(s). The __*Data Quality Control*__ is also linked to the __*Data Quality Dimension*__ and containts the __*Query*__ that should be executed to determine the __*Data Quality Results*__. | No | Business / Data Engineer |
| Threshold | Data Quality Thresholds are predefined limits or criteria that data must meet to be considered acceptable for its intended use. These thresholds are set based on the specific quality dimensions, such as accuracy, completeness, and consistency. They serve as benchmarks to evaluate whether data meets the required standards. For example, a threshold might specify that no more than 2% of data entries can be missing for the dataset to be deemed complete. By establishing these thresholds, organizations can systematically assess and ensure the quality of their data. | No | Business |











Will need something that describe the general properties and/or aims of __*Data Quality Control*__,  I would like to add another "__*General Idea*__", "*The implementation of a __Data Quality Requirement__ into __Data Quality Control__ which would measure the level of compliance and stores the result. In essence this is nothing more then a __Data Transformation__*".<br>
Of course there other requirements related to __*Data Quality*__ must be gathered and stored, but the excution requires very little. A __*Transformation*__-query would do. Most of these other requirements must be provided by the __business__, but these can be structure as well and some relationship between them can be implemneted.

# 2. Extending the meta-data-model

__*Data Quality*__ is implemented by building __*Data Quality Control*__, however this is not everthing, the __*result*__ of the __*measurements*__ need to be interperted, the interpertation can differ from different perspectives. For example the marketing department would be ok if 60 % of there mail campaings would reacht the customers, thus a level of complaince above 60 % is good data quality. However the finance department would have a very differenc appinion about this.
