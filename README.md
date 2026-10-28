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
* mutool >= 1.7a (`mupdf-tools`)
* ffmpeg >= 4.2.7
* ImageMagick >= 6.9.10

PostGIS / `libgeos` / `libproj` are **not** required (adapter dropped; Locate `loc` is plain text).

### `acts_as_dag` (vocab hierarchies)

`Vocab::Concept` uses `acts_as_dag` from the git dependency
`https://github.com/toboter/acts_as_dag.git` (not the rubygems gem).
**That fork is the source of truth** for this app’s DAG behaviour and schema
expectations (`vocab_links` / `vocab_descendants`). Keep the repository
alive (accessible, tagged/released as needed); do not silently switch to
another upstream without checking concept hierarchy behaviour. Optional
later work: vendor the gem into this org, or migrate hierarchies to
`closure_tree` (already used elsewhere in Babili).

### Frontend (Yarn / Sprockets)

Still **Bootstrap 3 + jQuery + Turbolinks + Sprockets**. Recent updates:

* **Froala removed** — Writer documents use the same **Trix** stack as
  discussions (`trix-editor` + `/raw/files.json`). Legacy Froala HTML still
  displays; re-editing may drop tables/colors/Embedly. Attachment extraction
  accepts both `data-trix-attachment` and legacy `data-attachment`.
* **Uppy 4.18** (was 0.27) — Dashboard/XHR/Form via `uppy/dist/uppy.min.js`.
* **`@rails/ujs` 7.1** (was npm `rails-ujs` 5.2).

Deferred (larger UI sprints): Bootstrap 3→5, Turbolinks→Turbo/Stimulus,
Trix 0.12→2.x (adapt `app/assets/javascripts/trix/*`), Propshaft/jsbundling,
`rails-bootstrap-markdown` removal (keep Redcarpet).

### html-pipeline / commonmarker / linkeddata

Pinned for cutover; **not** a go-live blocker. Do not bump major versions
casually — APIs changed.

* **`html-pipeline` 2.14** — used only for HTML sanitization
  (`ApplicationHelper#commentify` / `#documentify` →
  `HTML::Pipeline::SanitizationFilter`). The Markdown filter is commented
  out; user-facing Markdown goes through **Redcarpet**, not this pipeline.
  **3.x** renames the namespace to `HTMLPipeline`, drops
  `SanitizationFilter` (Selma-based config instead), and needs an adapter
  pass. Safer near-term exit: replace the two helpers with `sanitize` /
  Loofah (already available) and drop `html-pipeline` entirely.
* **`commonmarker` 0.23** — present for the old pipeline/markup stack;
  app code does not call it directly. **2.x** is a rewrite
  (`CommonMarker` → `Commonmarker`). Keep or drop together with the
  html-pipeline decision; do not bump alone.
* **`linkeddata` + `sparql-client`** — RDF/SPARQL stack for
  `Vocab::AATConcept` (Getty AAT). `linkeddata` is a meta-gem that pulls
  many `rdf-*` extras; runtime needs are mainly `sparql-client`. Treat
  bumps as one follow-up with the Getty AAT TODO (endpoint / query shape).
  Optional later: depend on `sparql-client` (and minimal RDF gems) only
  and drop the `linkeddata` umbrella.

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

Jobs use **Solid Queue** (Postgres). Puma loads the Solid Queue plugin by default (`SOLID_QUEUE_IN_PUMA=true`), so no Redis and no separate Sidekiq process. For a standalone worker:

```bash
bin/jobs
```

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
# Solid Queue runs inside Puma (or: SOLID_QUEUE_IN_PUMA=false bin/jobs)
```

Keep Shrine/file storage in place across the cutover. Point the Doorkeeper webhook at ADGB `/api/hooks/update_accessibilities`.

### Production cutover checklist

1. Maintenance window; backup Postgres, and Shrine/file storage.
2. Deploy final Babili + ADGB (Ruby 3.4 / Rails 8.1).
3. Set env / credentials, including `OPENSEARCH_URL` with credentials when security is on.
4. `bin/rails db:migrate RAILS_ENV=production` (schema only; includes Solid Queue / Cable tables).
5. `TRUNCATE versions;` if any PaperTrail rows remain.
6. Reindex Searchkick; restart Puma (Solid Queue plugin) or `bin/jobs`.
7. Smoke: Devise login, OAuth login from ADGB, file upload, vocab/biblio/search, webhooks into ADGB.

**Not required at cutover:** restoring a converted dump, PostGIS / `loc` geometry casts, or YAML→JSON PaperTrail rewrites.

## Future TODOs

* **Getty AAT SPARQL (vocab tag / concept search):** Tag and concept selectize fields call `Vocab::AATConcept.search` against `http://vocab.getty.edu/sparql`. The endpoint still exists (Getty LOD for AAT/TGN/ULAN), but live Lucene queries are often slow or hang from our network, so `/vocabularies/search/terms` currently returns **local** `Vocab::Concept` hits first and treats AAT as optional (short timeout). Follow up later: switch to the newer Linked.Art / `https://data.getty.edu/vocab/sparql` endpoint (and updated query shape), or drop live AAT from the tag box and keep local vocab only. Note Getty’s Fall 2026 vocab platform refresh when revisiting. Pair any AAT work with a `linkeddata` / `sparql-client` dependency tidy (see Dependencies).
* **`acts_as_dag` fork ownership:** See Dependencies — keep `toboter/acts_as_dag` available as the source of truth, or plan a deliberate move (vendor / `closure_tree`).
* **html-pipeline / commonmarker:** See Dependencies — stay on 2.x / 0.23 for now, or replace sanitization with `sanitize`/Loofah and drop both gems. Do not upgrade to html-pipeline 3 / commonmarker 2 without that adapter (or removal) pass.
* **Frontend modernization:** See Dependencies — Bootstrap 5, Turbo/Stimulus, Trix 2.x, Propshaft/jsbundling, and dropping `rails-bootstrap-markdown` are deliberate later sprints (not cutover blockers).

## Maintainers

[Tobias Schmidt](https://github.com/toboter): [http://toboter.de](http://toboter.de/)
