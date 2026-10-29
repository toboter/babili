# Babili

Babili ist die Plattform für Ressourcen zum antiken Babylon: Repositories
(Primärdaten, Literatur, Diskussionen, Dokumente), Organisationen sowie die
Dienste **Zensus** (Personen/Agenten), **Locate** (Orte) und die zentrale
**Bibliography**. Unveröffentlichte Inhalte sind geschlossen; Zugang nach
Freigabe.

Schwesteranwendung **ADGB** nutzt Babili als OAuth2-Provider sowie für
Datei-Uploads, Vokabular und Bibliographie. Betriebshandbuch:
[docs/HANDOVER.md](docs/HANDOVER.md), Aktualisierung: [docs/CUTOVER.md](docs/CUTOVER.md).

## Abhängigkeiten (Stand Modernisierung 2026)

| Komponente | Version / Hinweis |
|---|---|
| Ruby | **3.4.2** |
| Rails | **8.1.4** |
| Bundler | 2.5.x |
| Node / Yarn | ≥ 16.15 / 1.22.x |
| PostgreSQL | ≥ 15 (**ohne** PostGIS) |
| OpenSearch | ≥ 2.4, **lokal, HTTP ohne SSL** (`http://localhost:9200`) |
| mutool | ≥ 1.7a (`mupdf-tools`) — PDF-Vorschauen |
| ffmpeg | ≥ 4.2 — Video |
| ImageMagick **oder** libvips | Bildverarbeitung (Shrine); auf dem Dev-Host oft libvips |

### Wichtige Gems

| Bereich | Stand |
|---|---|
| Jobs | **Solid Queue** (in Puma; Redis/Sidekiq entfallen) |
| Action Cable | **Solid Cable** |
| OAuth-Provider | Doorkeeper 5.9 |
| Uploads | Shrine 3.4 |
| Suche | Searchkick 6 + opensearch-ruby 3 |
| Pagination | Pagy 43 |
| Editor | **Trix** (Froala entfernt) |
| Auth | Devise + reCAPTCHA |

### JavaScript (Yarn)

- Uppy **4.18**, `@rails/ujs` **7.1**, Trix 0.12  
- jQuery, Selectize, Toastr  

### Frontend (bewusst unverändert)

**Bootstrap 3 + jQuery + Turbolinks + Sprockets.** Bootstrap-5-/Turbo-Umbau ist
nicht Teil dieser Modernisierung.

### Besondere Hinweise

- **`acts_as_dag`:** Git-Fork `toboter/acts_as_dag` für Vocab-Hierarchien —
  nicht stillschweigend durch Rubygems-Gem ersetzen.  
- **html-pipeline / commonmarker / linkeddata:** für den Cutover gepinnt;
  siehe Abschnitt „Zukünftige TODOs“.  
- **CORS (Production):** nur Origins unter `*.babylon-online.org`.

## Lokale Einrichtung

```bash
cp config/database.yml.example config/database.yml
# bin/rails credentials:edit  → host, FROM/TO, recaptcha, opensearch_url, …
rbenv install 3.4.2   # falls nötig
bundle install
yarn install
bin/rails db:setup
```

Hosts: `api.dev.local` / `dev.local` → `127.0.0.1`. Babili Port **3000**.

```yaml
# credentials
opensearch_url: http://localhost:9200
```

Jobs: Solid Queue im Puma-Prozess (`SOLID_QUEUE_IN_PUMA=true`). Separat:

```bash
bin/jobs
```

PaperTrail-Entwürfe für Writer sind ungenutzt; Tabelle `versions` leer halten
bzw. bei Bedarf `TRUNCATE versions`.

## OpenSearch / Searchkick

Nur lokal, HTTP, ohne SSL. Nicht öffentlich binden.

```bash
export OPENSEARCH_URL='http://localhost:9200'
for c in Namespace Biblio::Entry Discussion::Thread Writer::Document \
         Vocab::Concept Zensus::Agent Zensus::Event Zensus::Appellation Locate::Place
do
  bundle exec rake searchkick:reindex CLASS=$c
done
```

## Tests

```bash
bin/rails test
# API-Verträge (OAuth/JSON):
bin/rails test test/controllers/api/json_contract_test.rb
```

Legacy-Scaffold-Controller-Tests sind übersprungen; API-Contract-Tests sind
maßgeblich.

## Dokumentation

| Dokument | Inhalt |
|---|---|
| [docs/HANDOVER.md](docs/HANDOVER.md) | Übergabe Verwaltung / Betrieb |
| [docs/CUTOVER.md](docs/CUTOVER.md) | Produktions-**Aktualisierung** |
| [docs/SECURITY.md](docs/SECURITY.md) | Sicherheitskurzbefund |

## Produktions-Aktualisierung (Kurz)

Bestehendes System aktualisieren (kein Neu-Deploy): Code, `bundle install`,
`db:migrate` (**eine** neue Migration: Solid Queue/Cable-Tabellen; ADGB ohne
Schema-Änderung), Assets, Puma neu starten, Reindex. Details:
[docs/CUTOVER.md](docs/CUTOVER.md).

## Zukünftige TODOs (nicht Cutover-Blocker)

- Getty AAT SPARQL / Linked.Art-Endpoint  
- `acts_as_dag`-Fork absichern oder zu `closure_tree` migrieren  
- html-pipeline durch `sanitize`/Loofah ersetzen oder gezielt upgraden  
- Frontend-Modernisierung (Bootstrap 5, Turbo, Propshaft) — separates Projekt  

## Maintainers

[Tobias Schmidt](https://github.com/toboter)
