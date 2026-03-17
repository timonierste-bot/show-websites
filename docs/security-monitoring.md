# Security & Monitoring

Dieses Dokument beschreibt das defensive Sicherungs- und Ueberwachungssystem fuer die Show-Websites.

## Was wir absichern koennen
- Website-Verfuegbarkeit
- Deploy-Status und Fehler
- DNS und SSL
- GitHub-Zugriffe und Branch-Schutz
- Netlify-Zugriffe und Deploy-Events
- Notion-Zugriffe und Dokumentationsstand
- Mailkonten und Alarmwege
- Backups und Wiederherstellung
- Kalenderzugriffe und Gerätesynchronisation

## Wichtige Risiken
- abgelaufene Zertifikate
- defekte DNS-Eintraege
- kompromittierte Accounts
- gelöschte oder ueberschriebene Deploys
- verlorene Secrets
- unbemerkte Formfehler oder Ausfaelle

## Leitlinien
- MFA fuer alle kritischen Konten
- minimale Rechtevergabe
- Secrets nur ueber sichere Umgebungsvariablen
- regelmaessige Audit- und Update-Checks
- klare Dokumentation in Notion
- keine stille Aenderung ohne Freigabe bei geschäftsrelevanten Themen
- private und geschäftliche Kalender getrennt halten
- keine automatische Synchronisation zwischen privaten und geschäftlichen Kalendern ohne ausdrückliche Freigabe
- nur vertrauenswürdige Geräte fuer Kalender und Mail verwenden
- verlorene oder alte Geräte aus allen Konten entfernen

## Geplante Bestandteile
- Asset-Inventar
- Zugriffs-Inventar
- Monitoring-Checkliste
- Alerting-Konzept
- Backup-Konzept
- Incident-Runbook
- Kalender- und Geräte-Regeln
