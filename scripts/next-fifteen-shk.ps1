$ErrorActionPreference = 'Stop'

function Write-Utf8NoBom {
  param([string]$Path, [string]$Content)
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Replace-All {
  param([string]$Text, [hashtable]$Map)
  foreach ($key in $Map.Keys) {
    $Text = $Text.Replace($key, [string]$Map[$key])
  }
  return $Text
}

$root = Join-Path $PSScriptRoot '..\showcases'
$template = Join-Path $root 'bissinger-gmbh'

$sites = @(
  @{Slug='friedrichs-sanitaer-heizung'; Name='Friedrichs Sanitär - Heizung'; City='Essen'; Title='Friedrichs Sanitär - Heizung | Essen'; Website='https://www.friedrichs-shk.de/'; Email='sanitaerfriedrichs@t-online.de'; Phone='0201 570161'; Address='Alte Hauptstraße 67, 45289 Essen'; Lead='Friedrichs Sanitär - Heizung steht für Planung, Bad und Heizungsmodernisierung in Essen.'; Desc='Friedrichs Sanitär - Heizung in Essen: Heizung, Bad und Sanitär mit klarer Ausrichtung.'; Footer='Vorschau für Friedrichs Sanitär - Heizung.'; Form='Kontakt anfragen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Friedrichs+Sanit%C3%A4r'}
  @{Slug='gelsenbad-heizung-sanitaer-gmbh'; Name='GELSENBAD Heizung und Sanitär GmbH'; City='Gelsenkirchen'; Title='GELSENBAD Heizung und Sanitär GmbH | Gelsenkirchen'; Website='https://www.gelsenbad.de/'; Email='info@gelsenbad.de'; Phone='0209 / 000000'; Address='Gelsenkirchen'; Lead='GELSENBAD zeigt Kompetenz in Heizung und Sanitär mit viel regionaler Sichtbarkeit.'; Desc='GELSENBAD Heizung und Sanitär GmbH in Gelsenkirchen: Fachbetrieb mit großem Potenzial für eine klare Premium-Präsenz.'; Footer='Vorschau für GELSENBAD Heizung und Sanitär GmbH.'; Form='Projekt anfragen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=GELSENBAD'}
  @{Slug='hgt-haus-gebaeudetechnik-gladbeck'; Name='HGT Haus & Gebäudetechnik Gladbeck'; City='Gladbeck'; Title='HGT Haus & Gebäudetechnik Gladbeck'; Website='https://hgt-gladbeck.de/'; Email='info@hgt-gladbeck.de'; Phone='+49 (0) 2043 98 22 180'; Address='Bottroperstr. 136, 45964 Gladbeck'; Lead='HGT Haus & Gebäudetechnik Gladbeck verbindet Heizung, Sanitär und Notdienst in einem starken regionalen Auftritt.'; Desc='HGT Haus & Gebäudetechnik Gladbeck & Umgebung: Fachbetrieb mit 24-Stunden-Notdienst und klarer Kundenansprache.'; Footer='Vorschau für HGT Haus & Gebäudetechnik Gladbeck.'; Form='Kontakt aufnehmen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=HGT+Gladbeck'}
  @{Slug='ks-sanitaer-heizungsbau-gmbh'; Name='K&S Sanitär- & Heizungsbau GmbH'; City='Werne'; Title='K&S Sanitär- & Heizungsbau GmbH | Werne'; Website='https://www.ks-sanitaer.de/'; Email='*protected email*'; Phone='02389/ 952 931 0'; Address='Landwehrstraße 114, 59368 Werne'; Lead='K&S Sanitär- & Heizungsbau GmbH zeigt Meisterbetrieb, Klarheit und einen sehr soliden Leistungsfokus.'; Desc='K&S Sanitär- & Heizungsbau GmbH in Werne: Meisterbetrieb für Privat- und Gewerbekunden mit starkem Leistungsprofil.'; Footer='Vorschau für K&S Sanitär- & Heizungsbau GmbH.'; Form='Beratung anfragen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=K%26S+Werne'}
  @{Slug='dinis-bad-und-heizung'; Name="Dini's Bad und Heizung"; City='Gladbeck'; Title="Dini's Bad und Heizung | Gladbeck"; Website='https://dinis-bad-heizung.de/'; Email='info@dinis-bad-heizung.de'; Phone='02043 - 98 22 483'; Address='Feldhauserstrasse 323, 45966 Gladbeck'; Lead="Dini's Bad und Heizung zeigt Notdienst, Heizungsmodernisierung und Badlösungen mit hoher Alltagsrelevanz."; Desc="Dini's Bad und Heizung in Gladbeck: Meisterbetrieb mit starker Serviceorientierung und 24-Stunden-Notdienst."; Footer="Vorschau für Dini's Bad und Heizung."; Form='Anfrage senden'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Dini%27s+Gladbeck'}
  @{Slug='heinke-sanitaer-heizung'; Name='Heinke Sanitär & Heizung'; City='Schwerte'; Title='Heinke Sanitär & Heizung | Schwerte'; Website='https://www.heinke-sanitaer.de/'; Email='info@heinke-sanitaer.de'; Phone='02304-17995'; Address='Holzener Weg 6, 58239 Schwerte'; Lead='Heinke Sanitär & Heizung steht für Meisterbetrieb, Badsanierung und moderne Heiztechnik mit Erfahrung seit 1972.'; Desc='Heinke Sanitär & Heizung in Schwerte: regional verankerter Meisterbetrieb mit breiter SHK-Kompetenz.'; Footer='Vorschau für Heinke Sanitär & Heizung.'; Form='Projekt anfragen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Heinke+Schwerte'}
  @{Slug='rueckmann-gmbh'; Name='Rückmann GmbH'; City='Gladbeck'; Title='Rückmann GmbH | Gladbeck'; Website='https://rueckmann-gmbh.de/'; Email='info@rueckmann-gmbh.de'; Phone='02043 / 000000'; Address='Gladbeck'; Lead='Rückmann GmbH bietet die Grundlage für eine starke, moderne Darstellung rund um Sanitär und Heizung.'; Desc='Rückmann GmbH in Gladbeck: traditionsnaher Betrieb mit viel Potenzial für eine frische Premium-Website.'; Footer='Vorschau für Rückmann GmbH.'; Form='Kontakt anfragen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=R%C3%BCckmann'}
  @{Slug='sanitaer-weber-gmbh'; Name='Sanitär Weber GmbH'; City='Schwerte'; Title='Sanitär Weber GmbH | Schwerte'; Website='https://www.sanitaer-weber-gmbh.de/'; Email='info@sanitaer-weber-gmbh.de'; Phone='(0 23 04) 4 39 34'; Address='Ostberger Straße 69a, 58239 Schwerte'; Lead='Sanitär Weber GmbH ist ein Familienbetrieb mit starker Historie, der online noch mehr Wirkung bekommen kann.'; Desc='Sanitär Weber GmbH in Schwerte: Familienunternehmen für Sanitär, Heizung und Kücheninstallationen.'; Footer='Vorschau für Sanitär Weber GmbH.'; Form='Beratung anfragen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Sanit%C3%A4r+Weber'}
  @{Slug='temeltas-sanitaer-heizung-klima'; Name='Temeltas Sanitär-Heizung-Klima'; City='Witten'; Title='Temeltas Sanitär-Heizung-Klima | Witten'; Website='https://temeltas-shk.de/'; Email='info@temeltas-shk.de'; Phone='02302 / 000000'; Address='Witten'; Lead='Temeltas Sanitär-Heizung-Klima setzt auf moderne Heizungsmodernisierung und Förderthemen.'; Desc='Temeltas Sanitär-Heizung-Klima in Witten: moderner Meisterbetrieb mit starkem Fokus auf Heizung und SHK.'; Footer='Vorschau für Temeltas Sanitär-Heizung-Klima.'; Form='Angebot anfordern'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Temeltas'}
  @{Slug='bogdanis-mrowicki'; Name='Bogdanis & Mrowicki'; City='Herne'; Title='Bogdanis & Mrowicki | Herne'; Website='https://bum-herne.de/'; Email='info@bum-herne.de'; Phone='02323 / 000000'; Address='Herne'; Lead='Bogdanis & Mrowicki bringt ein breites Leistungsspektrum und klare lokale Verankerung mit.'; Desc='Bogdanis & Mrowicki in Herne: vielseitiger SHK-Betrieb mit gutem Potenzial für eine modernere Außendarstellung.'; Footer='Vorschau für Bogdanis & Mrowicki.'; Form='Kontakt aufnehmen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Bogdanis+%26+Mrowicki'}
  @{Slug='dieter-wende-gmbh'; Name='Dieter Wende GmbH'; City='Herne'; Title='Dieter Wende GmbH | Herne'; Website='https://www.wende-gmbh.de/'; Email='info@wende-gmbh.de'; Phone='02323 / 000000'; Address='Herne'; Lead='Dieter Wende GmbH ist ein solider Traditionsbetrieb mit starkem Hebel für sichtbare Vorher-Nachher-Wirkung.'; Desc='Dieter Wende GmbH in Herne: etablierter Betrieb mit Potenzial für eine visuell stärkere Website.'; Footer='Vorschau für Dieter Wende GmbH.'; Form='Projekt starten'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Dieter+Wende'}
  @{Slug='gerno-opper-waermetechnik'; Name='Gerno Opper Wärmetechnik'; City='Mülheim an der Ruhr'; Title='Gerno Opper Wärmetechnik | Mülheim an der Ruhr'; Website='https://www.gerno-opper.de/'; Email='info@gerno-opper.de'; Phone='0208 / 000000'; Address='Mülheim an der Ruhr'; Lead='Gerno Opper Wärmetechnik steht für erfahrene Wärmetechnik mit einem sauberen regionalen Stand.'; Desc='Gerno Opper Wärmetechnik in Mülheim an der Ruhr: Fachbetrieb mit gutem Grundstock für eine neue Darstellung.'; Footer='Vorschau für Gerno Opper Wärmetechnik.'; Form='Beratung vereinbaren'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Gerno+Opper'}
  @{Slug='ihr-monteur-wegener-pfuetzenreuter-gbr'; Name='Ihr Monteur Wegener & Pfützenreuter GbR'; City='Witten'; Title='Ihr Monteur Wegener & Pfützenreuter GbR | Witten'; Website='https://www.ihr-monteur.de/'; Email='info@ihr-monteur.de'; Phone='02302 / 000000'; Address='Witten'; Lead='Ihr Monteur Wegener & Pfützenreuter GbR setzt auf direkte Kundenansprache und schnelle Hilfe.'; Desc='Ihr Monteur Wegener & Pfützenreuter GbR in Witten: regionaler Installateur mit viel Potenzial für eine starke Preview.'; Footer='Vorschau für Ihr Monteur Wegener & Pfützenreuter GbR.'; Form='Kontakt senden'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Ihr+Monteur'}
  @{Slug='kuno-eick'; Name='Kuno Eick'; City='Castrop-Rauxel'; Title='Kuno Eick | Castrop-Rauxel'; Website='https://www.kuno-eick.de/'; Email='info@kuno-eick.de'; Phone='02305 / 000000'; Address='Castrop-Rauxel'; Lead='Kuno Eick bringt ein breites Leistungsspektrum und eine klare lokale Sichtbarkeit mit.'; Desc='Kuno Eick in Castrop-Rauxel: solide Basis für eine neue, verkaufsstarke Vorschau.'; Footer='Vorschau für Kuno Eick.'; Form='Anfrage senden'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Kuno+Eick'}
  @{Slug='molitor-sanitaer-heizung-klima'; Name='Molitor Sanitär, Heizung, Klima'; City='Mülheim an der Ruhr'; Title='Molitor Sanitär, Heizung, Klima | Mülheim an der Ruhr'; Website='https://www.molitor-shk.de/'; Email='info@molitor-shk.de'; Phone='0208 / 000000'; Address='Mülheim an der Ruhr'; Lead='Molitor Sanitär, Heizung, Klima ist ein klarer Servicepartner vor Ort mit gutem Potenzial für eine hochwertige Preview.'; Desc='Molitor Sanitär, Heizung, Klima in Mülheim an der Ruhr: moderne SHK-Präsenz mit starkem regionalen Bezug.'; Footer='Vorschau für Molitor Sanitär, Heizung, Klima.'; Form='Projekt anfragen'; Og='https://placehold.co/1200x630/0b1020/ffffff?text=Molitor+SHK'}
)

foreach ($site in $sites) {
  $dest = Join-Path $root $site.Slug
  if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
  Copy-Item -Path $template -Destination $dest -Recurse -Force

  Get-ChildItem -Path $dest -Recurse -File | ForEach-Object {
    $text = [System.IO.File]::ReadAllText($_.FullName)
    $map = @{
      'Bissinger GmbH' = $site.Name
      'Bissinger' = $site.Name.Split(' ')[0]
      'Recklinghausen' = $site.City
      'Herzlich willkommen - Bissinger GmbH' = $site.Title
      'Klare Lösungen für Heizung und Sanitär mit Gefühl für Qualität.' = $site.Lead
      'Bissinger GmbH in Recklinghausen: moderne Haustechnik mit klarem Prozess, verlässlicher Ausführung und persönlicher Betreuung.' = $site.Desc
      'Vorschau für die Bissinger GmbH.' = $site.Footer
      'info@bissinger-re.de' = $site.Email
      '02361 / 000000' = $site.Phone
      'https://www.bissinger-re.de/' = $site.Website
      'https://www.bissinger-re.de/assets/generated/pictures/78386/cFGRr/favicon_bissinger.png' = $site.Og
      'Beratung anfragen' = $site.Form
      'Bissinger GmbH Website' = $site.Name
      'Haustechnik in Recklinghausen' = "Haustechnik in $($site.City)"
    }
    $text = Replace-All -Text $text -Map $map
    [System.IO.File]::WriteAllText($_.FullName, $text, (New-Object System.Text.UTF8Encoding($false)))
  }
}
