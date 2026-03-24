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
  @{Slug='ruhrtherm-shk'; Name='RuhrTherm SHK'; City='Castrop-Rauxel'; Source='https://ruhrtherm-shk.de/'; Why='Meistergeführter Betrieb mit gutem Leistungsbild und hoher Eignung für eine Preview.'; Form='Kontakt anfragen'}
  @{Slug='ellerbrock-herne'; Name='Ellerbrock Herne'; City='Herne'; Source='https://ellerbrock-herne.de/'; Why='Guter regionaler Fit und klare Chance, die Website visuell und inhaltlich zu modernisieren.'; Form='Projekt anfragen'}
  @{Slug='mechlinski-heizung-sanitaer'; Name='Mechlinski Heizung + Sanitär'; City='Dorsten'; Source='https://www.mechlinski-sanitaer.de/'; Why='Etablierter Betrieb mit Badausstellung und viel Hebel für eine stärkere visuelle Ansprache.'; Form='Beratung anfragen'}
  @{Slug='miles-heizung-sanitaer'; Name='Miles Heizung Sanitär'; City='Gladbeck'; Source='https://mileshaustechnik.de/'; Why='Junger Fachbetrieb mit modernem Auftritt und direktem Potenzial für eine bessere Conversion.'; Form='Anfrage senden'}
  @{Slug='ruhr-haustechnik'; Name='Ruhr Haustechnik'; City='Marl'; Source='https://ruhr-haustechnik.de/'; Why='Großer, technisch breiter Betrieb mit starkem Hebel für eine hochwertige Vorschau.'; Form='Projekt starten'}
  @{Slug='shr-sanitaer-heizungsservice-ruhrgebiet-gmbh'; Name='SHR Sanitär- und Heizungsservice Ruhrgebiet GmbH'; City='Herne'; Source='https://www.shr-herne.de/'; Why='Gute Dienstleistungsbreite und genug Raum, um online mehr Vertrauen und Führung aufzubauen.'; Form='Kontakt aufnehmen'}
  @{Slug='van-bevern-gmbh'; Name='Van Bevern GmbH'; City='Herne'; Source='https://www.sh-vanbevern.de/'; Why='Solider Betrieb mit genügend Potenzial für eine hochwertigere Anmutung.'; Form='Beratung vereinbaren'}
  @{Slug='christian-kemper-installateur-und-heizungsbau'; Name='Christian Kemper Installateur und Heizungsbau'; City='Gelsenkirchen'; Source='https://www.kemper-shk.de/'; Why='Aktiver Meisterbetrieb mit klarer Kontaktstruktur und hoher Eignung für eine Preview.'; Form='Kontakt senden'}
  @{Slug='michael-lethmate-sanitaer-heizung'; Name='Michael Lethmate Sanitär & Heizung'; City='Gelsenkirchen'; Source='https://www.shk-lethmate.de/'; Why='Seit 1998 geführt und regional sichtbar, daher guter Kandidat für eine neue Vorschau.'; Form='Angebot anfragen'}
  @{Slug='ostkamp-sanitaer-und-heizung-gmbh'; Name='Ostkamp Sanitär und Heizung GmbH'; City='Herne'; Source='https://www.ostkamp-sanitaer.de/'; Why='Langer Bestand und viel Substanz; eine Preview kann hier sehr glaubwürdig wirken.'; Form='Termin anfragen'}
  @{Slug='pauwels'; Name='PAUWELS'; City='Waltrop'; Source='https://www.pauwelsshk.de/'; Why='Frischer, moderner Meisterbetrieb mit gutem Hebel für eine edlere Außendarstellung.'; Form='Rückruf anfragen'}
  @{Slug='ruhrbad-gmbh'; Name='Ruhrbad GmbH'; City='Oer-Erkenschwick'; Source='https://www.ruhrbad.de/'; Why='Meisterbetrieb mit viel Substanz und gutem Ansatz für eine saubere Vorher-Nachher-Preview.'; Form='Projekt anfragen'}
  @{Slug='skiba-heizung-sanitaer-gmbh'; Name='Skiba Heizung & Sanitär GmbH'; City='Bottrop'; Source='https://www.sanitaer-bottrop.de/'; Why='Solider Bottroper Fachbetrieb mit guter Basis für eine neue Premium-Darstellung.'; Form='Kontakt öffnen'}
  @{Slug='gerwerth-gmbh'; Name='Gerwerth GmbH'; City='Waltrop'; Source='https://www.gerwerth-waltrop.de/'; Why='Traditionsbetrieb mit genügend Material für eine überzeugende Vorher-Nachher-Preview.'; Form='Beratung starten'}
  @{Slug='gith-gmbh'; Name='Gith GmbH'; City='Mülheim an der Ruhr'; Source='https://www.gith-gmbh.de/'; Why='Langjähriger Betrieb, bei dem eine saubere Preview direkt mehr Premium ausstrahlen kann.'; Form='Anfrage absenden'}
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