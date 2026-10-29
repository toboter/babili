# Produktions-Aktualisierung (Babili + ADGB)

**Kein Neu-Deploy.** Bestehendes System und bestehende Datenbanken werden
aktualisiert. Gemeinsame Checkliste und Reihenfolge: auch
[`ADGB docs/CUTOVER.md`](../../adgb/docs/CUTOVER.md).

## Babili-spezifisch

- [ ] Backup Postgres und Shrine-Datei-Storage
- [ ] `db:migrate`: einzige neue Migration dieses Upgrades —
      `20261027120000_create_solid_queue_and_cable_tables` (Solid Queue + Cable);
      ADGB braucht dafür **keine** Schema-Migration
- [ ] Nach Migrate: Solid-Queue-/Cable-Tabellen vorhanden; bei Bedarf
      `TRUNCATE versions;` (Writer-PaperTrail-Entwürfe ungenutzt)
- [ ] Searchkick-Klassen aus der README reindizieren gegen
      `http://localhost:9200` (OpenSearch lokal, HTTP, ohne SSL)
- [ ] Puma mit Solid-Queue-Plugin (Standard) oder `bin/jobs` — Redis/Sidekiq
      nicht erforderlich; ggf. alte Sidekiq-Prozesse beenden
- [ ] Smoke: Devise-Login, OAuth für ADGB, Uploads, Vocab/Biblio/Suche,
      Webhook nach ADGB (`/api/hooks/update_accessibilities`)

## Kurzablauf

```bash
bundle install --deployment --without development test
bin/rails db:migrate RAILS_ENV=production   # legt Solid-Queue-/Cable-Tabellen an
bin/rails assets:precompile RAILS_ENV=production
# TRUNCATE versions;  # optional, wenn noch PaperTrail-Zeilen existieren
# Searchkick-Reindex (Klassen siehe README)
# Puma neu starten (Solid Queue im Prozess)
```

Bestehende Fachdaten bleiben; die Migration legt **nur neue** Tabellen an.
Shrine-/Datei-Storage unverändert lassen. Doorkeeper-Webhook auf ADGB
`/api/hooks/update_accessibilities` belassen bzw. prüfen.

## Hinweis zu `schema.rb` vs. Migrationen

Details und ADGB-Seite: [`ADGB docs/CUTOVER.md`](../../adgb/docs/CUTOVER.md)
(Abschnitt „Hinweis zu schema.rb vs. Migrationen“). Kurz für Babili:

- Großer Schema-Diff Okt. 2026 = Neu-Dump (u. a. `precision: nil`,
  `pg_catalog.plpgsql`), keine Fach-Migrationen.
- `vector`/pgvector war Dump-Müll und ist aus `schema.rb` entfernt.
- PostGIS/`locate_locations` fehlen seit 2023 im Schema (ohne Drop-Migration);
  nicht nachinstallieren.
- Neu für dieses Upgrade nur Solid Queue/Cable via obige Migration.
