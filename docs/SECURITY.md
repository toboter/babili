# Babili — Sicherheit (Modernisierung ab Mitte Oktober 2026)

Kein Penetrationstest. Dieses Dokument hält fest, **was seit dem
Ruby-/Rails-Upgrade (Mitte Oktober 2026) sicherheitsrelevant gehärtet
wurde**, und welche **Rest- bzw. akzeptierten Risiken** danach noch
bestehen. Abschlussprüfung mit `brakeman` und `bundler-audit` auf dem
aktuellen Stand (Rails 8.1 / Ruby 3.4).

## Behoben / gehärtet seit Mitte Oktober 2026

| Thema | Was geändert wurde |
|---|---|
| Runtime-Stack | Ruby **3.4.2**, Rails **~> 8.1** — Framework-Security-Patches und unterstützte Laufzeit |
| CORS (Production) | Wildcard `*` entfernt; nur Origins `https://…babylon-online.org` / Subdomains |
| HTML-Sanitizer / XML | `sanitize` ≥ 7.0.1, `rexml` ≥ 3.3.9 (bekannte CVEs geschlossen) |
| Doorkeeper | Upgrade auf aktuelle 5.x; Token-Policy unverändert bewusst (siehe B2) |
| Jobs / Angriffsfläche | Sidekiq/Redis zugunsten von **Solid Queue** (Postgres) abgelöst — kein Redis-Job-Stack mehr nötig |
| Dynamisches `constantize` (Namespaces) | Typ-Parameter auf `Organization` / `Person` beschränkt |
| Log-Filter | Erweitert u. a. um `access_token`, `refresh_token`, `client_secret`, `authenticity_token`, `recaptcha_secret_key` |
| Audit | `brakeman` und `bundle-audit` nach den Upgrades ausgeführt; Findings priorisiert (siehe unten) |

## Offen / akzeptiert

| ID | Thema | Einschätzung | Behandlung |
|---|---|---|---|
| B1 | `raw(...)` auf Trix-/Writer-HTML (Hilfe, Developer-Artikel) | Mittel bis niedrig. XSS möglich, wenn ein authentisierter Autor bösartiges HTML speichert. | Akzeptiert unter Vertrauensmodell „nur berechtigte Editoren“. Optional Sanitizer/CSP. |
| B2 | Doorkeeper: kein Access-Token-Expiry + Wiederverwendung | Mittel bei Diebstahl: gültig bis manueller Widerruf. Clients (ADGB) erwarten stabile Tokens. | Akzeptiert. Widerruf über Doorkeeper; Änderung nur mit allen Clients. |
| B3 | OpenSearch ohne TLS (`http://localhost:9200`) | Niedrig auf Loopback; hoch bei öffentlicher Exposition. | Akzeptiert. Betrieb: nur `127.0.0.1` binden. |
| B4 | Weitere `constantize` in Biblio-Controllern | Niedrig bis mittel; Namespaces bereits allowlisted. | Bei Gelegenheit gleiche Allowlist; Priorität mittel. |
| B5 | CVEs in Test-Gems (`selenium-webdriver` / transitives `rubyzip`) | Produktionsrisiko vernachlässigbar. | Dev/Test-Bundle beim nächsten Update; vor Prod-Deploy erneut auditieren. |

## Betrieb

- OpenSearch nicht nach außen exposieren.
- OAuth-Redirect-URIs und Client-Secrets pflegen; gestohlene Tokens widerrufen.
- Secrets nur über `credentials` / `RAILS_MASTER_KEY`.
- Nach größeren Bundle-Updates erneut `brakeman` und `bundle-audit check`.
