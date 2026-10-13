# Babili

Babili is a platform for studying resources on ancient Babylon. Researchers work in repositories (primary data, literature, discussions, documents), gather in organizations, and contribute to shared services: **Zensus** (agents), **Locate** (places/toponyms), and a central **Bibliography**. The platform is closed unless material is published; users need approval.

Sibling app: **ADGB** (`~/dev/adgb`) uses Babili as its OAuth2 provider and for file uploads / vocab / bibliography. See also `docs/CUTOVER.md`.

## Dependencies

* ruby 3.4.2
* rails 8.1.4
* bundler 2.5.x
* node >= 16.15.1
* yarn 1.22.x
* postgresql >= 15
* opensearch >= 2.4
* redis-server >= 5 (Sidekiq only — Action Cable is unused scaffold)
* mutool >= 1.7a (`mupdf-tools`)
* ffmpeg >= 4.2.7
* ImageMagick >= 6.9.10

PostGIS / `libgeos` / `libproj` are **not** required (adapter dropped; Locate `loc` is plain text).

## Local setup

```bash
cp config/database.yml.example config/database.yml
# Encrypted credentials (see config/credentials.yml.example):
#   bin/rails credentials:edit
# Needs config/master.key (gitignored). Set host, FROM/TO, recaptcha,
# opensearch_url, …
rbenv install 3.4.2   # if needed
bundle install
yarn install
bin/rails db:setup    # or restore a production dump
```

Map hosts (WSL `/etc/hosts` and the Windows hosts file) so `api.dev.local` and `dev.local` resolve to `127.0.0.1`. Babili on port **3000** is the OAuth provider for ADGB (`provider_site: http://api.dev.local:3000`).

Second process for jobs:

```bash
bundle exec sidekiq -q default
```

(Sidekiq 7 no longer supports `-d` daemonize; use foreground, systemd, or a process manager.)

Writer document PaperTrail drafts are unused and removed from the app; keep the `versions` table empty (or `TRUNCATE versions`) so no YAML remains for Psych 4.

## OpenSearch / Searchkick

Searchkick reads `OPENSEARCH_URL` (defaults to `http://localhost:9200`).

With the security plugin enabled:

```bash
export OPENSEARCH_URL='https://admin:YOUR_PASSWORD@localhost:9200'
```

**Deploy:** set `OPENSEARCH_URL` in production (env / secrets) including credentials when security is on. Prefer real TLS with certificate verification in production; local Docker self-signed certs are allowed via `config/initializers/opensearch.rb` only for `https://` URLs.

Reindex:

```bash
bundle exec rake searchkick:reindex CLASS=Namespace
bundle exec rake searchkick:reindex CLASS=Biblio::Entry
bundle exec rake searchkick:reindex CLASS=Discussion::Thread
bundle exec rake searchkick:reindex CLASS=Writer::Document
bundle exec rake searchkick:reindex CLASS=Vocab::Concept
bundle exec rake searchkick:reindex CLASS=Zensus::Agent
bundle exec rake searchkick:reindex CLASS=Zensus::Event
bundle exec rake searchkick:reindex CLASS=Zensus::Appellation
bundle exec rake searchkick:reindex CLASS=Locate::Place
```

## Production deploy (cutover)

Go-live is **code + schema migrations** on the existing production DB — not a converted-dump restore. Full checklist: [`docs/CUTOVER.md`](docs/CUTOVER.md).

```bash
bundle install --deployment --without development test
bin/rails db:migrate RAILS_ENV=production
bin/rails assets:precompile RAILS_ENV=production
# TRUNCATE versions;  # if any PaperTrail rows remain
# reindex Searchkick (classes above)
bundle exec sidekiq -q default RAILS_ENV=production
```

Keep Shrine/file storage in place across the cutover. Point the Doorkeeper webhook at ADGB `/api/hooks/update_accessibilities`.

### Production cutover checklist

1. Maintenance window; backup Postgres, and Shrine/file storage.
2. Deploy final Babili + ADGB (Ruby 3.4 / Rails 8.1).
3. Set env / credentials, including `OPENSEARCH_URL` with credentials when security is on.
4. `bin/rails db:migrate RAILS_ENV=production` (schema only).
5. `TRUNCATE versions;` if any PaperTrail rows remain.
6. Reindex Searchkick; restart Sidekiq.
7. Smoke: Devise login, OAuth login from ADGB, file upload, vocab/biblio/search, webhooks into ADGB.

**Not required at cutover:** restoring a converted dump, PostGIS / `loc` geometry casts, or YAML→JSON PaperTrail rewrites.

## Maintainers

[Tobias Schmidt](https://github.com/toboter): [http://toboter.de](http://toboter.de/)
