# README

This README would normally document whatever steps are necessary to get the
application up and running.

# Dependencies
sudo apt-get update
sudo apt-get install postgis
&& https://github.com/rgeo/activerecord-postgis-adapter#upgrading-an-existing-database
* rails db:gis:setup
* sudo apt-get install libgeos-dev libproj-dev

* elasticsearch
* redis
* postgres 9.5
* mutool (uses `mutool draw` but as `mudraw`)
* ffmpeg


# Changelog
Coming with *docs*:
* rewritten ability class
* repositories now can have collaborators
* rewritten repo permission control for user/group owned repositories and collaborators.
* discussion mods 
* new docs feature on repositories.
* new blog / help / dev categories feature for repo docs

* many many bugfixes


# todo
* discussions need to use the repo permission control.
* better error pages in production
* favicon
* robots handling and better titles / search console
* ...