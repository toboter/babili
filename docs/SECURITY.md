# Babili — Sicherheit (Modernisierung ab Mitte Oktober 2026)

Kein Penetrationstest. Dieses Dokument hält fest, **was seit dem
Ruby-/Rails-Upgrade (Mitte Oktober 2026) sicherheitsrelevant gehärtet
wurde**, und welche **Rest- bzw. akzeptierten Risiken** danach noch
bestehen. Nachgezogene Bundle-Updates bis **November 2026**
(Rails **8.1.4.1**, Puma 8.x, rubyzip 3.x, commonmarker 0.23.12, …).
Audits mit `brakeman` / `bundler-audit` auf dem aktuellen Stand (Ruby 3.4).

## Behoben / gehärtet seit Mitte Oktober 2026

| Thema | Was geändert wurde |
|---|---|
| Runtime-Stack | Ruby **3.4.2**, Rails **8.1.4.1** (inkl. Active-Storage-Security-Patches) |
| App-Server | **Puma ≥ 7.2.1** (Lock: 8.1.1) |
| CORS (Production) | Wildcard `*` entfernt; nur Origins `https://…babylon-online.org` / Subdomains |
| CORS-Gem | `rack-cors` ≥ 2.0.2 (Lock: 3.0.0) |
| HTML-Sanitizer / XML | `sanitize` ≥ 7.0.1, `rexml` ≥ 3.3.9 |
| Markdown (GFM) | `commonmarker` **~> 0.23.10** (Lock: 0.23.12) — CVE-Fix ohne Sprung auf 2.x/Rust |
| ZIP / Excel | `rubyzip` ≥ 3.4 (Lock: 3.7.0), `roo` ≥ 4.0 |
| msgpack | ≥ 1.8.7 |
| Active Storage / Bilder | `mini_magick` **~> 5.1** (Lock: 5.4.0); Variant-Processor weiter MiniMagick |
| Doorkeeper | 5.9.x; Token-Policy unverändert bewusst (siehe B2) |
| Jobs / Angriffsfläche | Sidekiq/Redis → **Solid Queue** (Postgres) |
| Dynamisches `constantize` (Namespaces) | Typ-Parameter auf `Organization` / `Person` |
| Log-Filter | Tokens/Secrets inkl. `recaptcha_secret_key` |
| Test-Stack | `selenium-webdriver` ≥ 4.38 (Lock: 4.52.0) |
| Audit | `brakeman` / `bundle-audit` nach den Upgrades |

**Hinweis Trix (npm):** weiter **0.12.x** — Sprung auf 2.1.x bewusst zurückgestellt (Asset-Pfad + Custom Mentions/Toolbar); kein aktueller Blocker für den Cutover.

## Offen / akzeptiert

| ID | Thema | Einschätzung | Behandlung |
|---|---|---|---|
| B1 | `raw(...)` auf Trix-/Writer-HTML (Hilfe, Developer-Artikel) | Mittel bis niedrig. XSS möglich, wenn ein authentisierter Autor bösartiges HTML speichert. | Akzeptiert unter Vertrauensmodell „nur berechtigte Editoren“. Optional Sanitizer/CSP. |
| B2 | Doorkeeper: kein Access-Token-Expiry + Wiederverwendung | Mittel bei Diebstahl: gültig bis manueller Widerruf. Clients (ADGB) erwarten stabile Tokens. | Akzeptiert. Widerruf über Doorkeeper; Änderung nur mit allen Clients. |
| B3 | OpenSearch ohne TLS (`http://localhost:9200`) | Niedrig auf Loopback; hoch bei öffentlicher Exposition. | Akzeptiert. Betrieb: nur `127.0.0.1` binden. |
| B4 | Weitere `constantize` in Biblio-Controllern | Niedrig bis mittel; Namespaces bereits allowlisted. | Bei Gelegenheit gleiche Allowlist; Priorität mittel. |

## Betrieb

- OpenSearch nicht nach außen exposieren.
- OAuth-Redirect-URIs und Client-Secrets pflegen; gestohlene Tokens widerrufen.
- Secrets nur über `credentials` / `RAILS_MASTER_KEY`.
- Nach größeren Bundle-Updates erneut `brakeman` und `bundle-audit check`.
