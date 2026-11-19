# Generates icons/icon-192.png and icons/icon-512.png from a 24x24 pixel-art daisy.
# Run from the repo root:  pwsh tools/make-icons.ps1
Add-Type -AssemblyName System.Drawing

$art = @(
  '........................',
  '........................',
  '..........W.W.W.........',
  '.........WWWWWWW........',
  '........WWWYYYWWW.......',
  '.......WWWYYYYYWWW......',
  '........WWYYOYYWW.......',
  '.......WWWYYYYYWWW......',
  '........WWWYYYWWW.......',
  '.........WWWWWWW........',
  '..........W.G.W.........',
  '............G...........',
  '...........GG...LL......',
  '...LL......G...LGL......',
  '...LGL.....G..LGL.......',
  '....LGL....G.LGL........',
  '.....LGL...GLGL.........',
  '......LGG..GGL..........',
  '.........GGG............',
  '.......PPPPPPP..........',
  '........PPPPP...........',
  '.......PP.G.PP..........',
  '..........G.............',
  '........................'
)
$colors = @{
  'W' = '#ffffff'; 'Y' = '#f7c62e'; 'O' = '#e08a10'; 'G' = '#4f8a2b'
  'L' = '#86c04e'; 'P' = '#e84a7a'
}
$bg = [System.Drawing.ColorTranslator]::FromHtml('#2b2864')
$outDir = Join-Path $PSScriptRoot '..\icons'
New-Item -ItemType Directory -Force $outDir | Out-Null

foreach ($size in 192, 512) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.Clear($bg)
  # keep art inside the maskable safe zone (centre 80%)
  $cell = [math]::Floor($size * 0.8 / 24)
  $off = [math]::Floor(($size - $cell * 24) / 2)
  for ($y = 0; $y -lt 24; $y++) {
    for ($x = 0; $x -lt 24; $x++) {
      $ch = [string]$art[$y][$x]
      if ($ch -ne '.') {
        $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.ColorTranslator]::FromHtml($colors[$ch]))
        $g.FillRectangle($brush, $off + $x * $cell, $off + $y * $cell, $cell, $cell)
        $brush.Dispose()
      }
    }
  }
  $g.Dispose()
  $bmp.Save((Join-Path $outDir "icon-$size.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}
Write-Output "icons written to $outDir"
