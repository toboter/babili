# Changelog

## next **

### todo
* removing rails-bootstrap-markdown
* removing old cms for blog and help
* update doorkeeper and remove oauth-accessibility class, therefor adding integrations to repositories
* new Event/Activity-Model for Zensus
* adding referencations for file uploads on zensus
* add zensus to main search
* add zensus events and activity from bibliography create
* adding possibility to reference agents in documents and discussions
* adding possibility to reference literature and concepts in documents
* adding module for a periodization model
* repo private attribute
* adding license selector on repository
* adding png-preview for transliterations from tablet data model
* adding tablet data model
* adding transliterations and morphems on toponyms, concepts, appellation_parts and epoch_points
* Ladegeschwindigkeit bei bibliographie
* split ability file (https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities%3A-Best-Practices#split-your-abilityrb-file)
* discussions need to use the repo permission control?
* better error pages in production
* favicon


## *docs* 2018-09-22

Features:
* repositories now can have collaborators
* adding collaborators to discussion moderators 
* new docs feature on repositories
* adding collaborators to repositories and adding settings page on repositories
* using froala to write documents
* new blog / help / dev categories feature for repo docs; adding by categorization
* new insight view on person with latest docs, repos and literature
* person and agent connection and corresponding partials
* robots handling and better titles
* google search console implementation
* new file_upload publishing. When adding a file to a comment or when publishing a document, the file will be published too.

Changes:
* rewritten ability class
* rewritten repo permission control for user/organization owned repositories and collaborators
* moving existing cms for blog and help to /old-cms, now deprecated
* review of all meta tags
* rails-bootstrap-markdown is deprecated

Bugfixes:
* many


## *trix* 2018-08-24

Features:
* new discussions feature on repositories: mentions, references (to literature and concepts) and file attachments
* discussion moderators set to repo owners
* adding partials to concepts and literature to view references to discussions
* now using trix from basecamp to write comments
* now using uppy for file uploads
* implementing file upload for images, videos, audios or documents, with image versions and previews for pdf docs and videos
* adding referencations for file uploads on literature and new views on literature index and show. Showing aggs on index.
* api subdomain and versioning of api

Changes:
* using rails 5.2
* rails-bootstrap-markdown is deprecated
* removing dropzone
* api subdomain and versioning of api now: e.g. http://api.babylon-online.org/v1

Bugfixes:
* many


## *aggr* 2018-08-02

Features:
* adding repositories
* new data feature on repositories, with tabular-upload or lido-file-import as data event, adding tabular-rows or lido-file as data commit on an item and aggregating repo items on an overall babylon object identifier called boi (alpha)
* adding api to commit data to a repository (early alpha)

Changes:
* using ruby 2.4.1

Bugfixes:
* many


## before

for older changes see commit log