# Production cutover (Babili + ADGB)

See also [`~/dev/adgb/docs/CUTOVER.md`](../../adgb/docs/CUTOVER.md). Shared checklist: code + schema migrations only on existing production databases.

## Babili-specific

- [ ] Backup Postgres and Shrine file storage
- [ ] Redis up for Sidekiq
- [ ] After `db:migrate`: `TRUNCATE versions;` if any PaperTrail rows remain (Writer drafts unused)
- [ ] Reindex Searchkick classes listed in README
- [ ] `bundle exec sidekiq -d -L log/sidekiq.log -q default RAILS_ENV=production`
- [ ] Smoke Devise, OAuth for ADGB, uploads, vocab/biblio search
