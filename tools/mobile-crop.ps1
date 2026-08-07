<#
.SYNOPSIS
  Szimulalja, mit lat a mobil latogato egy 16:9 kepbol.

.DESCRIPTION
  A hero kep a mobilon `object-fit: cover`-rel jelenik meg egy 380x800-as
  viewportban. A bongeszo ilyenkor a magassagra skaláz, es a kep szelessegenek
  csak a kozepso savjat mutatja:

      lathato savszelesseg = (380/800) / (16/9) = 26.72%

  Ez a szkript pontosan ezt a savot vagja ki, majd 380x800-ra meretezi.
  Nem kell hozza ffmpeg — csak .NET System.Drawing, ami Windowson adott.

.EXAMPLE
  .\tools\mobile-crop.ps1 -Path assets\master\gerinc-master.png
  .\tools\mobile-crop.ps1 -Path assets\build\stage-11.png -ViewportW 380 -ViewportH 800
#>
param(
  [Parameter(Mandatory = $true)][string]$Path,
  [int]$ViewportW = 380,
  [int]$ViewportH = 800,
  [string]$OutPath
)

Add-Type -AssemblyName System.Drawing

$src = Resolve-Path -LiteralPath $Path -ErrorAction Stop
if (-not $OutPath) {
  $dir  = Split-Path -Parent $src
  $name = [IO.Path]::GetFileNameWithoutExtension($src)
  $OutPath = Join-Path $dir "$name.mobile-${ViewportW}x${ViewportH}.png"
}

$img = [System.Drawing.Image]::FromFile($src)
try {
  $srcAspect      = $img.Width / $img.Height
  $viewportAspect = $ViewportW / $ViewportH

  if ($viewportAspect -lt $srcAspect) {
    # A viewport keskenyebb: magassagra skalazunk, oldalt vagunk.
    $visibleFrac = $viewportAspect / $srcAspect
    $cropW = [int][Math]::Round($img.Width * $visibleFrac)
    $cropH = $img.Height
  } else {
    # A viewport szelesebb: szelessegre skalazunk, fent-lent vagunk.
    $visibleFrac = $srcAspect / $viewportAspect
    $cropW = $img.Width
    $cropH = [int][Math]::Round($img.Height * $visibleFrac)
  }

  $cropX = [int][Math]::Round(($img.Width  - $cropW) / 2)
  $cropY = [int][Math]::Round(($img.Height - $cropH) / 2)

  $dst = New-Object System.Drawing.Bitmap $ViewportW, $ViewportH
  $g   = [System.Drawing.Graphics]::FromImage($dst)
  try {
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $srcRect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropW, $cropH
    $dstRect = New-Object System.Drawing.Rectangle 0, 0, $ViewportW, $ViewportH
    $g.DrawImage($img, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
  } finally { $g.Dispose() }

  $dst.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $dst.Dispose()

  $pct = [Math]::Round($visibleFrac * 100, 1)
  Write-Output "forras     : $($img.Width)x$($img.Height)  (aspect $([Math]::Round($srcAspect,3)))"
  Write-Output "viewport   : ${ViewportW}x${ViewportH}  (aspect $([Math]::Round($viewportAspect,3)))"
  Write-Output "lathato sav: ${pct}%  ->  kivagas ${cropW}x${cropH} @ ${cropX},${cropY}"
  Write-Output "kimenet    : $OutPath"
} finally { $img.Dispose() }
