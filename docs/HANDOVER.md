# Übergabedokumentation Babili

**Zielgruppe:** Verwaltung und Betrieb.  
**Stand:** Oktober 2026 — Modernisierung Ruby 3.4 / Rails 8.1.  
**Schwestersystem:** ADGB (nutzt Babili als Anmelde- und Datei-/API-Dienst).

---

## 1. Worum handelt es sich?

Babili ist die zentrale Plattform für digitale Ressourcen zum antiken Babylon.
Darin arbeiten Forschende in **Repositories** (Primärdaten, Literatur,
Diskussionen, Textdokumente), organisieren sich in **Organisationen** und
nutzen Querschnittsdienste:

- **Zensus** — Personen / Agenten und Ereignisse  
- **Locate** — Orte und Toponyme  
- **Bibliography** — Literaturverwaltung  
- **Vocab** — kontrolliertes Vokabular (inkl. optional Getty AAT)  
- **Raw / Dateien** — zentraler Dateispeicher (Bilder, PDFs, …)  
- **OAuth2 (Doorkeeper)** — Anmeldung und API-Zugang für ADGB und weitere Clients  

Unveröffentlichte Inhalte sind geschlossen; Veröffentlichung und Freigaben
steuern die Sichtbarkeit.

Produktions-Hosts liegen unter **`*.babylon-online.org`** (z. B. Web-UI,
`api.`-Subdomain). Cross-Origin-Zugriffe (CORS) sind in Production auf diese
Domain-Familie beschränkt.

---

## 2. Was wurde modernisiert?

Die Modernisierung erneuert Laufzeit, Bibliotheken und ausgewählte
Komponenten, **ohne** die Anwendung neu zu erfinden und **ohne** ein neues
visuelles Design (Bootstrap 3 bleibt).

| Thema | Nach der Modernisierung |
|---|---|
| Ruby / Rails | **3.4.2** / **8.1.4** |
| Hintergrundjobs | **Solid Queue** (in Puma; **kein Redis/Sidekiq** mehr nötig) |
| Echtzeit/Cable | **Solid Cable** (Postgres) |
| Dateien | Shrine; Uploads u. a. von ADGB und dem Trix-Editor |
| Editor Dokumente | **Trix** (kommerzielles Froala entfernt) |
| Suche | OpenSearch lokal, HTTP ohne SSL |
| Pagination | Pagy |
| OAuth | Doorkeeper (Tokens absichtlich langlebig — siehe Sicherheit) |

**Nicht** im Auftrag: Bootstrap-5-Frontend, Penetrationstest, laufender
Betrieb außerhalb der vereinbarten Leistungen, grundlegende Neuentwicklungen.

---

## 3. Architektur im Überblick

```text
  Browser
     |
     +--> Babili Web (Devise-Login, Repositories, Editor, …)
     |
     +--> ADGB --OAuth/API/Uploads--> Babili API (api.* / Doorkeeper)
                                         |
                                         +-- PostgreSQL (inkl. Solid Queue/Cable)
                                         +-- Dateispeicher (Shrine unter public/uploads o. konfiguriert)
                                         +-- OpenSearch http://localhost:9200
```

**Betriebliche Kopplung mit ADGB**

- Doorkeeper-Application für ADGB: Client-ID/Secret, Redirect-URI, ggf. Webhook
  auf ADGB `/api/hooks/update_accessibilities`.
- Datei-Uploads von ADGB landen als `Raw::Image` (o. ä.) in Babili; ADGB speichert
  die UUID (`file_id`).

---

## 4. Server- und Softwarevoraussetzungen

| Komponente | Anforderung |
|---|---|
| Host | bestehendes Zielsystem — **Aktualisierung**, kein Neuaufbau |
| Ruby | 3.4.2 |
| Node / Yarn | Asset-Pipeline (Sprockets) |
| PostgreSQL | ≥ 15, **ohne PostGIS** |
| OpenSearch | ≥ 2.4 auf demselben Host, **HTTP, ohne SSL** |
| ImageMagick und/oder libvips | Bildderivate |
| ffmpeg | Video |
| mutool (`mupdf-tools`) | PDF-Vorschau |
| Puma | App-Server; optional Solid Queue im gleichen Prozess |

### Secrets / Credentials

Verschlüsselte Credentials + `RAILS_MASTER_KEY` auf dem Server. Beispielhafte
Schlüssel (siehe auch `config/credentials.yml.example`):

- `secret_key_base`, `host`
- `FROM` / `TO`, optional Gmail-SMTP
- `recaptcha_site_key` / `recaptcha_secret_key`
- `opensearch_url: http://localhost:9200`

---

## 5. OpenSearch (wichtig für Verwaltung)

**Betriebsmodell:** OpenSearch läuft nur lokal auf dem Anwendungsserver.

- URL typisch: `http://localhost:9200`
- **Kein SSL** erforderlich und nicht vorgesehen
- **Nicht** aus dem Internet erreichbar machen (Firewall / Bind an 127.0.0.1)

Wenn die Suche leer oder fehlerhaft ist: Dienststatus prüfen, dann Reindex
(Klassenliste in der README bzw. Abschnitt 7).

---

## 6. Hintergrundjobs (Solid Queue)

Früher: Redis + Sidekiq.  
Jetzt: **Solid Queue** in PostgreSQL.

- Standard: Jobs laufen **innerhalb von Puma** (`SOLID_QUEUE_IN_PUMA=true`).
- Alternativ eigener Prozess: `SOLID_QUEUE_IN_PUMA=false bin/jobs`
- Alte Sidekiq-/Redis-Dienste können nach erfolgreichem Update **beendet und
  deinstalliert** werden, sofern nichts anderes sie noch braucht.

Tabellen entstehen mit der **einen** neuen Migration dieses Upgrades:
`db/migrate/20261027120000_create_solid_queue_and_cable_tables.rb`
(Solid Queue + Solid Cable). ADGB hat dafür keine Schema-Migration.

---

## 7. Aktualisierung in Produktion

Vollständige Checkliste: [CUTOVER.md](CUTOVER.md) und ADGB
`docs/CUTOVER.md`.

Kurzablauf:

1. Backup: Postgres **und** Dateispeicher (Shrine).
2. Code ausrollen.
3. `bundle install --deployment` → `db:migrate` (nur diese Solid-Tabellen
   neu) → `assets:precompile`.
4. Optional: `TRUNCATE versions;` (ungenutzte PaperTrail-Writer-Entwürfe).
5. Puma neu starten (Solid Queue mitstarten).
6. Searchkick-Reindex aller relevanten Klassen.
7. Smoke-Tests (unten).

**Kein** Einspielen eines „konvertierten“ Gesamtdumps nötig. Bestehende
Fachdaten bleiben; `db:migrate` legt nur die neuen Solid-Tabellen an.

---

## 8. Smoke-Tests nach einem Update

- [ ] Login mit Benutzerkonto (Devise)
- [ ] Login aus ADGB (OAuth-Rundreise)
- [ ] Repository öffnen, Datensatz lesen
- [ ] Datei hochladen (ADGB-Quelle oder Writer/Trix)
- [ ] Bibliographie / Vocab-Suche
- [ ] Ein Hintergrundjob wird verarbeitet (z. B. nach Upload-Derivaten)
- [ ] Webhook/Accessibility-Update Richtung ADGB (falls genutzt)

---

## 9. Module für den Alltag (Orientierung)

| Bereich | Was Verwaltung wissen sollte |
|---|---|
| Benutzer / Freigaben | Registrierung, Bestätigung, Organisationsmitgliedschaften |
| Repositories | Arbeitsbereiche; Rechte über Mitglieder/Kollaboration |
| Writer | Textdokumente mit Trix; alte Froala-Inhalte werden angezeigt, komplexes Layout kann beim erneuten Speichern vereinfacht werden |
| Dateien (Raw) | zentraler Speicher; Varianten (large/medium/…) für Bilder |
| Bibliography | Literatur, Verknüpfung mit Repositories |
| Zensus / Locate | Personen- bzw. Ortsdaten |
| OAuth-Anwendungen | Doorkeeper-Admin: Clients wie ADGB pflegen |

---

## 10. Sicherheit (Verwaltungs-Zusammenfassung)

### Erledigt / konfiguriert

- CORS Production nur `*.babylon-online.org`
- Log-Filter für Passwörter und Tokens
- `sanitize` / `rexml` aktualisiert
- Namespace-Einstellungen: Typ-Allowlist (`Organization` / `Person`)
- Statische Analyse (Brakeman) und Dependency-Audit auf dem aktuellen Stack

### Offene / bewusst akzeptierte Risiken

Vollständige Einschätzung und Behandlung: [SECURITY.md](SECURITY.md)
(kein Changelog der Fixes — nur Restpunkte).

Kurz: langlebige Doorkeeper-Tokens und OpenSearch ohne TLS auf localhost
sind bewusst akzeptiert; redaktionelles Trix-HTML und einzelne Biblio-
`constantize`-Stellen sind dokumentierte Restpunkte.

### Empfehlungen

- Regelmäßig Backups testweise wiederherstellen  
- Nach Bundle-Updates erneut Security-Audit  
- OAuth-Redirect-URIs und Webhook-URLs bei Domain-Änderungen prüfen  

---

## 11. Dateien und Speicher

- Shrine speichert unter dem konfigurierten Dateisystem-Pfad (Standardentwicklung:
  `public/uploads/…`).
- Bei Serverumzug: **Dateiordner mitkopieren**, sonst fehlen Bilder/PDFs.
- ADGB speichert nur Metadaten/IDs; die Bytes liegen in Babili.

---

## 12. Bekannte Einschränkungen / spätere Themen

Diese Punkte **blockieren den Betrieb nicht**, sollten aber bekannt sein:

1. **Getty AAT:** externe SPARQL-Suche kann langsam sein; lokale Vocab-Treffer
   haben Vorrang.  
2. **html-pipeline / commonmarker / linkeddata:** ältere Major-Versionen,
   bewusst gehalten; Upgrade eigenes Projekt.  
3. **Frontend:** Bootstrap 3 bleibt bis zu einem eigenen UI-Projekt.  
4. **acts_as_dag:** Abhängigkeit vom Git-Fork — Repository erreichbar halten.

---

## 13. Tests

```bash
bin/rails test
bin/rails test test/controllers/api/json_contract_test.rb
```

Viele alte Scaffold-Tests sind übersprungen; die API-Contract-Tests prüfen
wesentliche JSON-/OAuth-Schnittstellen.

---

## 14. Dokumentenlandkarte

| Dokument | Inhalt |
|---|---|
| [README.md](../README.md) | Abhängigkeiten, lokales Setup, Reindex-Befehle |
| [CUTOVER.md](CUTOVER.md) | Checkliste Update-Fenster |
| [SECURITY.md](SECURITY.md) | Offene / akzeptierte Rest-Risiken |
| ADGB `docs/HANDOVER.md` | Übergabe der Client-Anwendung |

---

## 15. Übergabe-Checkliste für die Verwaltung

- [ ] Zugang zum App-Host und zu Credentials/`RAILS_MASTER_KEY` geregelt  
- [ ] Backup-Konzept (DB + Dateien) bestätigt  
- [ ] OpenSearch nur lokal / HTTP dokumentiert und so betrieben  
- [ ] Doorkeeper-App für ADGB geprüft (Redirect, Secret)  
- [ ] Smoke-Tests nach letztem Update abgehakt  
- [ ] Ansprechpartner für fachliche vs. technische Fragen benannt  
