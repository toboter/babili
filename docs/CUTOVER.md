# Production cutover (Babili + ADGB)

See also [`~/dev/adgb/docs/CUTOVER.md`](../../adgb/docs/CUTOVER.md). Shared checklist: code + schema migrations only on existing production databases.

## Babili-specific

- [ ] Backup Postgres and Shrine file storage
- [ ] After `db:migrate`: Solid Queue / Cable tables present; `TRUNCATE versions;` if any PaperTrail rows remain (Writer drafts unused)
- [ ] Reindex Searchkick classes listed in README
- [ ] Puma with Solid Queue plugin (default) or `bin/jobs` — Redis not required
- [ ] Smoke Devise, OAuth for ADGB, uploads, vocab/biblio search
