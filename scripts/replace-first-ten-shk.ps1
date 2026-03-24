$root = 'C:\Users\timon\OneDrive\01 Nierste-Distribution\07_Projekte\Show Websites\showcases'

$sites = @(
  [pscustomobject]@{Slug='kolk-sanitaer-energietechnik'; Name='Kolk Sanitär- und Energietechnik GmbH'; Short='Kolk'; City='Gelsenkirchen'; Phone='0209/959840'; Email='info@kolk.de'; Website='https://kolk.de/'; Og='https://kolk.de/wp-content/uploads/2025/06/Asset-2.png'; Title='Kolk Sanitär- und Energietechnik GmbH | Gelsenkirchen'; Lead='Kolk Sanitär- und Energietechnik steht für Heizungsbau, Badmodernisierung, Wartung und erneuerbare Energien.'; Footer='Vorschau für Kolk Sanitär- und Energietechnik GmbH.'; Form='Projekt anfragen'}
  [pscustomobject]@{Slug='bunse-sanitaer-heizung'; Name='Bunse Sanitär-Heizung GmbH'; Short='Bunse'; City='Gelsenkirchen'; Phone='0209 140270'; Email='info@bunse.tv'; Website='https://bunse.tv/'; Og='https://bunse.tv/wp-content/uploads/2022/03/Bunse-logo2.png'; Title='Bunse Sanitär-Heizung GmbH | Gelsenkirchen'; Lead='Bunse Sanitär-Heizung GmbH macht aus Ihrer Idee ein Konzept, das individuell auf Ihre Wünsche eingeht.'; Footer='Vorschau für Bunse Sanitär-Heizung GmbH.'; Form='Beratung anfragen'}
  [pscustomobject]@{Slug='hense-sanitaer'; Name='Hense Sanitär'; Short='Hense'; City='Gelsenkirchen'; Phone='0209 140223'; Email='info@hense-sanitaer.de'; Website='https://www.hense-sanitaer.de/'; Og='https://www.hense-sanitaer.de/fileadmin/Setup/Resources/Public/Gfx/Frondend/icon-hires.png'; Title='Hense Sanitär | Gelsenkirchen'; Lead='Hense Sanitär setzt auf freundliche Beratung, sorgfältige Planung und saubere Umsetzung.'; Footer='Vorschau für Hense Sanitär.'; Form='Beratung vereinbaren'}
  [pscustomobject]@{Slug='daschner-heizung-sanitaer'; Name='Daschner Heizung & Sanitär'; Short='Daschner'; City='Duisburg'; Phone='0203 / 88 00 8'; Email='info@daschner-gmbh.de'; Website='https://www.daschner-gmbh.de/'; Og='https://www.daschner-gmbh.de/scripts/get.aspx?media=/config/theme/og-image.png'; Title='Sanitär Heizung Duisburg | Daschner Heizung & Sanitär'; Lead='Daschner Heizung & Sanitär steht für Planung, Beratung, Kompetenz und pünktliche Umsetzung.'; Footer='Vorschau für Daschner Heizung & Sanitär.'; Form='Anfrage absenden'}
  [pscustomobject]@{Slug='a-team-sanitaertechnik-gmbh'; Name='A-Team Sanitärtechnik GmbH'; Short='A-Team'; City='Oberhausen'; Phone='+49 208 845633'; Email='a-team-gmbh@online.de'; Website='https://www.a-team-gmbh-oberhausen.de/'; Og='https://www.a-team-gmbh-oberhausen.de/s/misc/logo.jpg?t=1772679652'; Title='A-Team Sanitärtechnik GmbH | Oberhausen'; Lead='A-Team Sanitärtechnik GmbH wirkt persönlich, nahbar und technisch klar.'; Footer='Vorschau für A-Team Sanitärtechnik GmbH.'; Form='Kontakt aufnehmen'}
  [pscustomobject]@{Slug='hsl-heizung-sanitaer-lueftung-gmbh'; Name='HSL-Heizung-Sanitär-Lüftung'; Short='HSL'; City='Gelsenkirchen'; Phone='0209 134075'; Email='info@hsl-gmbh.net'; Website='https://www.hsl-gmbh.net/'; Og='https://www.hsl-gmbh.net/scripts/get.aspx?media=/config/theme/og-image.png'; Title='HSL-Heizung-Sanitär-Lüftung | Gelsenkirchen'; Lead='HSL-Heizung-Sanitär-Lüftung steht für Qualität, vorbildlichen Kundenservice und freundliche Beratung.'; Footer='Vorschau für HSL-Heizung-Sanitär-Lüftung.'; Form='Projekt anfragen'}
  [pscustomobject]@{Slug='schulz-sanitaer-heizung-klima'; Name='Schulz Sanitär - Heizung - Klima'; Short='Schulz'; City='Duisburg'; Phone='0203 / 000000'; Email='info@schulz-haustechnik.de'; Website='https://www.schulz-haustechnik.de/'; Og='https://www.schulz-haustechnik.de/scripts/get.aspx?media=/config/theme/og-image.png'; Title='Schulz Sanitär - Heizung - Klima | Duisburg'; Lead='Schulz Sanitär - Heizung - Klima zeigt Kompetenz in Sanitär, Heizung und Klima.'; Footer='Vorschau für Schulz Sanitär - Heizung - Klima.'; Form='Anfrage senden'}
  [pscustomobject]@{Slug='croelle-haustechnik'; Name='Crölle Haustechnik'; Short='Crölle'; City='Recklinghausen'; Phone='02361 970 211-0'; Email='info@croelle.com'; Website='https://www.croelle.com/'; Og='https://www.croelle.com/img/social-preview.jpg'; Title='Crölle Haustechnik GmbH – Sanitär, Heizung, Elektro in Recklinghausen'; Lead='Crölle Haustechnik verbindet Sanitär, Heizung, Elektro und Energie in einem starken, hochwertigen Auftritt.'; Footer='Vorschau für Crölle Haustechnik GmbH.'; Form='Angebot anfordern'}
)

foreach ($site in $sites) {
  $dest = Join-Path $root $site.Slug
  Get-ChildItem -Path $dest -Recurse -File | ForEach-Object {
    $content = [System.IO.File]::ReadAllText($_.FullName)
    $content = $content.Replace('Bissinger GmbH', $site.Name)
    $content = $content.Replace('Bissinger', $site.Short)
    $content = $content.Replace('Recklinghausen', $site.City)
    $content = $content.Replace('Herzlich willkommen - Bissinger GmbH', $site.Title)
    $content = $content.Replace('Klare Lösungen für Heizung und Sanitär mit Gefühl für Qualität.', $site.Lead)
    $content = $content.Replace('Bissinger GmbH in Recklinghausen: moderne Haustechnik mit klarem Prozess, verlässlicher Ausführung und persönlicher Betreuung.', $site.Lead)
    $content = $content.Replace('Vorschau für die Bissinger GmbH.', $site.Footer)
    $content = $content.Replace('info@bissinger-re.de', $site.Email)
    $content = $content.Replace('02361 / 000000', $site.Phone)
    $content = $content.Replace('https://www.bissinger-re.de/', $site.Website)
    $content = $content.Replace('https://www.bissinger-re.de/assets/generated/pictures/78386/cFGRr/favicon_bissinger.png', $site.Og)
    $content = $content.Replace('Beratung anfragen', $site.Form)
    $content = $content.Replace('Bissinger GmbH Website', $site.Name)
    [System.IO.File]::WriteAllText($_.FullName, $content, (New-Object System.Text.UTF8Encoding($false)))
  }
}