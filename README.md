# Babili

Babili is a platform for studying resources on ancient babylon. It expects that researchers have a specific vocabulary which they use on data. It is also expected that researchers have a specific question in mind when gathering data. This is done in repositories, in which is primary data and literature, discussions and documents written by the researcher or commented on by the community on that specific question. Researchers can also gather in organizations or teams to work on a bigger scientific question, therefore they can have common repositories and vocabularies in addition to their own. Organizations and their vocabularies and repositories may be hidden for other non members. Repositories may be private and thereby also be hidden unless being an owner or invited to collaborate. Apart from those scientific question and user centric tools, babili also provides some central services which each researcher contributes to and benefits from. These are Zensus for Agents (individuals or groups) throughout history, Locate for places together with their different locations and toponyms thoughout history and a central Bibliograhy.

While being community driven at first, babili is a closed platform unless material is published. Users need to be approved. Some elements can only be edited by platform administrators.


## Dependencies

* ruby 2.7.3
* rails 5.2.8
* bundler 2.3.26
* node >= 16.15.1
* yarn 1.22.19
* postgres >= 15 or libpq-dev
* postgis (https://github.com/rgeo/activerecord-postgis-adapter#upgrading-an-existing-database)
* libgeos-dev
* libproj-dev
* opensearch >= 2.4
* redis-server >= 5.0.7
* mutool >= 1.7a (uses `mutool draw` as `mudraw`) -> `mupdf-tools`
* ffmpeg >= 4.2.7
* ImageMagick >= 6.9.10-23


## Installation

Make sure you have installed all dependencies first. Then download the application files from https://github.com/toboter/babili.

### rbenv
https://github.com/rbenv/rbenv#basic-git-checkout
https://github.com/rbenv/ruby-build#clone-as-rbenv-plugin-using-git
rbenv install 2.7.3


### nvm
https://github.com/nvm-sh/nvm#git-install
nvm install --lts
npm install --global yarn


To install the apps' gem dependencies

```bash
bundle install --deployment --without development test
```

Migrate the Database (you can also load the schema if installing for the first time)

```bash
bundle exec rails db:migrate RAILS_ENV=production
```

Compile the css and js assets used by the application, yarn dependencies will be installed automatically

```bash
bundle exec rails assets:clobber RAILS_ENV=production
bundle exec rails assets:precompile RAILS_ENV=production
```

Adding indices for elasticsearch

```bash
bundle exec rake searchkick:reindex CLASS=Namespace RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Biblio::Entry RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Discussion::Thread RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Writer::Document RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Vocab::Concept RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Zensus::Agent RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Zensus::Event RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Zensus::Appellation RAILS_ENV=production
bundle exec rake searchkick:reindex CLASS=Locate::Place RAILS_ENV=production
```

After every server restart

```bash
bundle exec sidekiq -d -L log/sidekiq.log -q default RAILS_ENV=production
```

## Development
For local development you will need to set api.dev.local on 127.0.0.1. This with your puma port will be the provider site for oauth applications.

## Maintainers

[Tobias Schmidt](https://github.com/toboter): [http://toboter.de](http://toboter.de/)
