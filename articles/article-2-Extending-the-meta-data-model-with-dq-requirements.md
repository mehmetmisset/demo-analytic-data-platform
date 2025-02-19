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

> __*General Idea (the same goes for data quality):*__ Requirements should be documented in a structured way to ensure they are accessible, traceable, and manageable.

> __*Importance of Requirements Gathering:*__ Gathering requirements is fundamental in any data project.
Storing requirements in a structured way saves time and reduces the risk of missing or misinterpreting them.

> __*Integration into Development Process:*__ Integrating structured storage of requirements ensures consistency and alignment across the project lifecycle. Enhances collaboration and streamlines the development process.

> __*Benefits of Standardization:*__ Maintains uniformity across projects. Facilitates better communication and understanding among stakeholders. Key features include scalability, compliance with naming conventions, parallel processing, and vendor independence.

> __*Improved Insight and Visibility:*__ Provides better tracking of changes, dependencies, and potential issues. Centralized storage allows for quick access and review by stakeholders.

> __*Automation:*__ Automates various aspects of the development process, reducing manual effort and minimizing errors. Key aspects include automatic dependency handling, technical documentation generation, automatic data lineage, and easy reloading of datasets.

> __*Metadata Model:*__ Defines the structure and relationships of data elements within a system. Captures key data elements such as datasets, attributes, transformations, and business keys. Ensures necessary information is obtained efficiently.

> __*Git Repository and Development Process:*__ Ensures all changes to the metadata model are tracked and documented. Supports branching and merging for effective collaboration.

> __*Front-End Tool:*__ A simple front-end tool, like Microsoft Access, can help manage the metadata. Should be programmed to extract metadata from the repository and present it in a user-friendly way.
Stored in the Git repository for easy distribution and updates.

At the end of the article the a conclusion was given as follows, *"Capturing data ingestion and transformation requirements into a metadata model enhances the development process. Ensures requirements are accurately captured, managed, and utilized throughout the project lifecycle."*

With this in mind, I would like to add another "__*General Idea*__", "*The implementation of a __Data Quality Requirement__ into __Data Quality Control__ which would measure the level of compliance and stores the result. In essence this is nothing more then a __Data Transformation__*".<br>
Of course there other requirements related to __*Data Quality*__ must be gathered and stored, but the excution requires very little. A __*Transformation*__-query would do. Most of these other requirements must be provided by the __business__, but these can be structure as well and some relationship between them can be implemneted.

# 2. Extending the meta-data-model

__*Data Quality*__ is implemented by building __*Data Quality Control*__, however this is not everthing, the __*result*__ of the __*measurements*__ need to be interperted, the interpertation can differ from different perspectives. For example the marketing department would be ok if 60 % of there mail campaings would reacht the customers, thus a level of complaince above 60 % is good data quality. However the finance department would have a very differenc appinion about this.
