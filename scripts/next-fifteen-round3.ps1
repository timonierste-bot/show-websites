$ErrorActionPreference = 'Stop'

function Write-Utf8NoBom {
  param([string]$Path, [string]$Content)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Decode-Text {
  param([string]$Text)
  if ([string]::IsNullOrWhiteSpace($Text)) { return $Text }
  return [System.Net.WebUtility]::HtmlDecode($Text).Trim()
}

function Resolve-Url {
  param([string]$BaseUrl, [string]$MaybeRelativeUrl)
  if ([string]::IsNullOrWhiteSpace($MaybeRelativeUrl)) { return $null }
  try {
    $base = [Uri]::new($BaseUrl)
    $resolved = [Uri]::new($base, $MaybeRelativeUrl)
    return $resolved.AbsoluteUri
  } catch {
    return $MaybeRelativeUrl
  }
}

function Get-SourceData {
  param([string]$Url, [string]$FallbackName, [string]$FallbackCity)
  $result = [ordered]@{
    Url = $Url
    Title = "$FallbackName | $FallbackCity"
    Description = "Fertige Kundenversion für $FallbackName mit klarer Leistungsführung und direktem Kontakt in $FallbackCity."
    Phone = ''
    Email = ''
    Address = $FallbackCity
    Logo = ''
    OgImage = ''
  }
  try {
    $html = (Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 10).Content
    $ogTitlePattern = @'
(?is)<meta[^>]+property=["'']og:title["''][^>]+content=["'']([^"']+)["'']
'@
    $titlePattern = @'
(?is)<title>(.*?)</title>
'@
    $ogDescPattern = @'
(?is)<meta[^>]+property=["'']og:description["''][^>]+content=["'']([^"']+)["'']
'@
    $descPattern = @'
(?is)<meta[^>]+name=["'']description["''][^>]+content=["'']([^"']+)["'']
'@
    $ogImagePattern = @'
(?is)<meta[^>]+property=["'']og:image["''][^>]+content=["'']([^"']+)["'']
'@
    $iconPattern = @'
(?is)<link[^>]+rel=["''](?:shortcut icon|icon)["''][^>]+href=["'']([^"']+)["'']
'@

    if ($html -match $ogTitlePattern) { $result.Title = Decode-Text $matches[1] }
    elseif ($html -match $titlePattern) { $result.Title = Decode-Text $matches[1] }

    if ($html -match $ogDescPattern) {
      $result.Description = Decode-Text $matches[1]
    } elseif ($html -match $descPattern) {
      $result.Description = Decode-Text $matches[1]
    }

    if ($html -match $ogImagePattern) {
      $result.OgImage = Resolve-Url -BaseUrl $Url -MaybeRelativeUrl (Decode-Text $matches[1])
    }

    if ($html -match $iconPattern) {
      $result.Logo = Resolve-Url -BaseUrl $Url -MaybeRelativeUrl (Decode-Text $matches[1])
    }
    if ([string]::IsNullOrWhiteSpace($result.Logo) -and -not [string]::IsNullOrWhiteSpace($result.OgImage)) {
      $result.Logo = $result.OgImage
    }

    $mailPattern = @"
(?is)mailto:([^"'<>?\s]+)
"@
    $telPattern = @"
(?is)tel:([^"'<>?\s]+)
"@
    if ($html -match $mailPattern) { $result.Email = Decode-Text $matches[1] }
    if ($html -match $telPattern) { $result.Phone = Decode-Text $matches[1] }

    $street = $null
    $plz = $null
    $locality = $null
    if ($html -match '(?is)"streetAddress"\s*:\s*"([^"]+)"') { $street = Decode-Text $matches[1] }
    if ($html -match '(?is)"postalCode"\s*:\s*"([^"]+)"') { $plz = Decode-Text $matches[1] }
    if ($html -match '(?is)"addressLocality"\s*:\s*"([^"]+)"') { $locality = Decode-Text $matches[1] }
    if ($street -or $plz -or $locality) {
      $parts = @()
      if ($street) { $parts += $street }
      if ($plz -or $locality) { $parts += ($plz, $locality | Where-Object { $_ }) -join ' ' }
      $result.Address = ($parts -join ', ')
    }
  } catch {
    # Keep fallbacks when a site is temporarily unavailable.
  }
  return [pscustomobject]$result
}

$root = Join-Path $PSScriptRoot '..\showcases'
$template = Join-Path $root 'bissinger-gmbh'

$sites = @(
  @{Slug='haustechnik-duisburg'; Name='Haustechnik Duisburg'; City='Duisburg'; Source='https://www.haustechnik-duisburg.com/'; Why='Regional stark und mit genug Substanz, um daraus eine deutlich verkaufsstärkere Vorschau zu bauen.'; Form='Kontakt anfragen'}
  @{Slug='klassen-sanitaer-heizungstechnik'; Name='Klaßen Sanitär & Heizungstechnik e.K.'; City='Duisburg'; Source='https://heizungstechnik-duisburg.de/'; Why='Klarer Fachbetrieb mit regionalem Bezug und gutem Potenzial für eine hochwertige Neukomposition.'; Form='Projekt anfragen'}
  @{Slug='liffers-specht-gbr'; Name='Liffers & Specht GbR'; City='Schwerte'; Source='https://liffers-specht-shk.de/'; Why='Solider SHK-Betrieb mit Raum für eine moderne, vertrauensstarke Preview.'; Form='Beratung anfragen'}
  @{Slug='markus-weber-gebaeudetechnik'; Name='Markus Weber Gebäudetechnik Sanitär-Heizung-Klima'; City='Witten'; Source='https://www.gebaeudetechnik-mweber.de/'; Why='Breites Gebäudetechnik-Profil, das sich gut in eine starke digitale Darstellung übersetzen lässt.'; Form='Anfrage senden'}
  @{Slug='scheithauer-heizung-sanitaer-klima-gmbh'; Name='Scheithauer Heizung-Sanitär-Klima GmbH'; City='Castrop-Rauxel'; Source='https://scheithauerhsk.de/'; Why='Etablierter Betrieb mit genügend Material für eine moderne und überzeugende Website-Vorschau.'; Form='Projekt starten'}
  @{Slug='shk-d-frommer'; Name='SHK D. Frommer'; City='Castrop-Rauxel'; Source='https://www.shkdfrommer.de/'; Why='Regional verankerter Fachbetrieb, bei dem eine klare Vorschau direkt mehr Professionalität zeigt.'; Form='Kontakt aufnehmen'}
  @{Slug='thermo-rhein-west'; Name='Thermo Rhein West'; City='Mülheim an der Ruhr'; Source='https://www.thermo-rheinwest.de/'; Why='Gute Ausgangslage für eine wertigere, conversionstärkere Außendarstellung.'; Form='Beratung vereinbaren'}
  @{Slug='brinkmann-heizung-sanitaer'; Name='Brinkmann Heizung + Sanitär'; City='Mülheim an der Ruhr'; Source='https://brinkmann-heizung.de/'; Why='Solider Betrieb mit klarer Leistungsbasis, der sich visuell deutlich aufwerten lässt.'; Form='Kontakt senden'}
  @{Slug='dowa-haustechnik'; Name='DOWA Haustechnik'; City='Mülheim an der Ruhr'; Source='https://www.dowa-haustechnik.de/'; Why='Moderner Fachbetrieb mit genug Substanz für eine hochwertige, verkaufsstarke Vorschau.'; Form='Angebot anfragen'}
  @{Slug='heinz-moelleken-gmbh'; Name='Heinz Mölleken GmbH'; City='Dinslaken'; Source='https://www.heinz-moelleken.de/'; Why='Länger gewachsener Betrieb mit guter Basis für eine vertrauensstarke Neugestaltung.'; Form='Termin anfragen'}
  @{Slug='lsg-sanitaer-heizung'; Name='LSG Sanitär & Heizung Meisterbetrieb'; City='Dinslaken'; Source='https://www.lsgsanitaerheizung.de/'; Why='Meisterbetrieb mit viel Potenzial für eine klare und überzeugende Premium-Darstellung.'; Form='Rückruf anfragen'}
  @{Slug='nb-sanitaer-heizung-klima-gmbh'; Name='N&B Sanitär, Heizung & Klima GmbH'; City='Mülheim an der Ruhr'; Source='https://nb-shk.de/'; Why='Starker SHK-Betrieb mit einer guten Grundlage für eine hochwertige Kundenpräsentation.'; Form='Projekt anfragen'}
  @{Slug='albers-haustechnik-muelheim'; Name='Albers Haustechnik Mülheim'; City='Mülheim an der Ruhr'; Source='https://www.albers-sanitaer-heizung.de/'; Why='Regionaler Fachbetrieb mit gutem Hebel für eine klarere und modernere Online-Wirkung.'; Form='Beratung starten'}
  @{Slug='haustechnik-all-in'; Name='Haustechnik All In Heizung und Sanitär'; City='Oberhausen'; Source='https://sellwerk.de/firmenprofil/haustechnik-all-in-heizung-und-sanitaer---badrenovierung'; Why='Interessanter Betrieb mit Potenzial für eine deutlich hochwertigere Präsentation als aktuelle Standardprofile.'; Form='Kontakt öffnen'}
  @{Slug='huebner-heizung-lueftung-sanitaer'; Name='Hübner Heizung-Lüftung-Sanitär'; City='Gelsenkirchen'; Source='https://www.evng.de/content/dam/revu-global/evng/documents/installateure/installateure_gas.pdf'; Why='Technisch breiter Betrieb, der mit einer guten Preview direkt professioneller wirkt.'; Form='Beratung anfragen'}
)

foreach ($site in $sites) {
  $dest = Join-Path $root $site.Slug
  if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
  Copy-Item -Path $template -Destination $dest -Recurse -Force

  $meta = Get-SourceData -Url $site.Source -FallbackName $site.Name -FallbackCity $site.City
  $short = ($site.Name -replace '\b(GmbH|GbR|KG|e\.K\.|GmbH & Co\. KG)\b','').Trim()
  if ([string]::IsNullOrWhiteSpace($short)) { $short = $site.Name }
  $logo = if ($meta.Logo) { $meta.Logo } elseif ($meta.OgImage) { $meta.OgImage } else { "https://placehold.co/200x200/0b1020/ffffff?text=$([Uri]::EscapeDataString(($short -replace '\s+','+')))" }
  $hero = if ($meta.OgImage) { $meta.OgImage } else { "https://placehold.co/1200x630/0b1020/ffffff?text=$([Uri]::EscapeDataString($short))" }
  $email = if ($meta.Email) { $meta.Email } else { "info@{0}.de" -f ($site.Slug -replace '[^a-z0-9\-]','') }
  $phone = if ($meta.Phone) { $meta.Phone } else { "$($site.City) auf Anfrage" }
  $address = if ($meta.Address) { $meta.Address } else { $site.City }

  $replacements = [ordered]@{
    'Bissinger GmbH' = $site.Name
    'Bissinger' = $short
    'Recklinghausen' = $site.City
    'Herzlich willkommen - Bissinger GmbH' = "$($site.Name) | $($site.City)"
    'Klare Lösungen für Heizung und Sanitär mit Gefühl für Qualität.' = $site.Why
    'Bissinger GmbH in Recklinghausen: moderne Haustechnik mit klarem Prozess, verlässlicher Ausführung und persönlicher Betreuung.' = $site.Why
    'Vorschau für die Bissinger GmbH.' = "Vorschau für $($site.Name)."
    'info@bissinger-re.de' = $email
    '02361 / 000000' = $phone
    'https://www.bissinger-re.de/' = $site.Source
    'https://www.bissinger-re.de/assets/generated/pictures/78386/cFGRr/favicon_bissinger.png' = $logo
    'Beratung anfragen' = $site.Form
    'Bissinger GmbH Website' = $site.Name
    'Haustechnik in Recklinghausen' = "Haustechnik in $($site.City)"
    'Leistungen ansehen' = 'Leistungen ansehen'
    'Fachbetrieb mit Profil' = 'Fachbetrieb mit Profil'
  }

  Get-ChildItem -Path $dest -Recurse -File | ForEach-Object {
    if ($_.Name -eq 'README.md') {
      $readme = @"
# $($site.Name) Website

Kundenfertige Vorschau für $($site.Name) in $($site.City). Die Seite zeigt die bestehende Website in einer deutlich klareren, hochwertigeren und verkaufsstärkeren Form.

## Seiten
- `index.html` Startseite mit Hero, Leistungen, Vertrauen und Kontakt
- `impressum.html` Rechtliche Angaben
- `datenschutz.html` Datenschutzhinweise

## Quelle
- Original: $($site.Source)
- Fokus: $($site.Why)

## Hinweise
- Die Vorschau ist für WhatsApp, Mail und Präsentation gedacht.
- Die finale Live-Version wird bei Bedarf auf den Kunden weiter angepasst.
"@
      Write-Utf8NoBom -Path $_.FullName -Content $readme
    } elseif ($_.Name -eq 'HANDOFF.md') {
      $handoff = @"
# Handoff – $($site.Name)

- Ort: $($site.City)
- Quelle: $($site.Source)
- Ziel: verkaufsstarke Kunden-Vorschau
- Status: Vorschau fertig

## Was enthalten ist
- Startseite mit klarem Einstiegs-Hero
- Impressum
- Datenschutz
- hochwertige Kontaktführung

## Nächste Schritte
- bei Zusage auf die finale Kundenversion anpassen
- Inhalte, Referenzen und Kontaktangaben verfeinern
- anschließend live deployen
"@
      Write-Utf8NoBom -Path $_.FullName -Content $handoff
    } else {
      $text = [System.IO.File]::ReadAllText($_.FullName)
      foreach ($key in $replacements.Keys) {
        $value = [string]$replacements[$key]
        if ($null -ne $value) {
          $text = $text.Replace($key, $value)
        }
      }
      if ($meta.Title) { $text = $text.Replace([string]$meta.Title, "$($site.Name) | $($site.City)") }
      if ($meta.Description) { $text = $text.Replace([string]$meta.Description, $site.Why) }
      if ($meta.Phone) { $text = $text.Replace([string]$meta.Phone, $phone) }
      if ($meta.Email) { $text = $text.Replace([string]$meta.Email, $email) }
      if ($meta.Address) { $text = $text.Replace([string]$meta.Address, $address) }
      [System.IO.File]::WriteAllText($_.FullName, $text, (New-Object System.Text.UTF8Encoding($false)))
    }
  }
}