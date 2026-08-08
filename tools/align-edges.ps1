<#
.SYNOPSIS
  A fix kameraallas ket szelso savjat egyetlen kanonikus kockarol masolja at
  az osszes tobbi epitesi kockara, lagy atmenettel.

.DESCRIPTION
  A CAMERA LOCK szerint az epulet a kep kozponti 70 szazalekat foglalja el,
  tehat a bal es jobb szelso ~15 szazalek garantaltan csak taj: bukk balra,
  erdeifenyok jobbra. Ha ezek kockarol kockara valtoznak, a nezo azt latja,
  hogy megmozdult a kamera — ez a leggyakoribb hiba a scroll-szekvenciakban,
  es a videoklipekben "uszo" hatterkent jelenik meg.

  A szkript ezt a ket savot atmasolja a kanonikus kockarol, es ketiranyban
  halvanyitja el: befele az epulet fele, illetve lefele a talaj fele, mert a
  talaj jogosan valtozik fazisrol fazisra. Igy a fak fixek maradnak, a
  foldmunka viszont szabadon valtozhat.

  Az atlatszosag pixelenkent, LockBits-szel keszul. A Graphics.DrawImage
  ImageAttributes/ColorMatrix utja itt nem mukodott — merve 0.01 valtozast
  adott 14-bol, vagyis gyakorlatilag no-op volt.

  A kekoras kockat (11) alapertelmezesben kihagyja: ott mas a szinhomerseklet,
  a nappali sav bevilagitana.

.EXAMPLE
  .\tools\align-edges.ps1 -Canonical 04 -Skip 11
#>
param(
  [string]$BuildDir  = "assets\build",
  [string]$OutDir    = "assets\build\aligned",
  [string]$Canonical = "04",
  [string[]]$Skip    = @("11"),
  [double]$EdgeFrac  = 0.15,   # sav szelessege a kepszelesseg aranyaban
  [double]$TopFrac   = 0.60,   # meddig tart lefele
  [double]$HSolid    = 0.55,   # a sav mekkora resze teljesen atlathatatlan
  [double]$VSolid    = 0.72
)

Add-Type -AssemblyName System.Drawing

# A kanonikus kocka egyik szelso savja, pixelenkenti alfa-atmenettel.
function New-FeatheredEdge {
  param(
    [System.Drawing.Bitmap]$Canon,
    [int]$X0, [int]$W, [int]$H,
    [bool]$MirrorFade   # jobb oldalon a befele-halvanyodas tukrozve van
  )
  $strip = New-Object System.Drawing.Bitmap $W, $H, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($strip)
  $src = New-Object System.Drawing.Rectangle $X0, 0, $W, $H
  $dst = New-Object System.Drawing.Rectangle 0, 0, $W, $H
  $g.DrawImage($Canon, $dst, $src, [System.Drawing.GraphicsUnit]::Pixel)
  $g.Dispose()

  $rect = New-Object System.Drawing.Rectangle 0, 0, $W, $H
  $data = $strip.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite,
                          [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $stride = $data.Stride
  $bytes = New-Object byte[] ($stride * $H)
  [Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)

  # sorok es oszlopok halvanyodasa elore kiszamolva
  $hA = New-Object double[] $W
  for ($x = 0; $x -lt $W; $x++) {
    $t = if ($MirrorFade) { 1.0 - ($x / [double]($W - 1)) } else { $x / [double]($W - 1) }
    $hA[$x] = if ($t -le $HSolid) { 1.0 } else { [Math]::Max(0.0, 1.0 - (($t - $HSolid) / (1.0 - $HSolid))) }
  }
  $vA = New-Object double[] $H
  for ($y = 0; $y -lt $H; $y++) {
    $u = $y / [double]($H - 1)
    $vA[$y] = if ($u -le $VSolid) { 1.0 } else { [Math]::Max(0.0, 1.0 - (($u - $VSolid) / (1.0 - $VSolid))) }
  }

  for ($y = 0; $y -lt $H; $y++) {
    $row = $y * $stride
    $v = $vA[$y]
    for ($x = 0; $x -lt $W; $x++) {
      # 32bppArgb bajtsorrend: B G R A
      $bytes[$row + $x*4 + 3] = [byte][Math]::Round(255 * $hA[$x] * $v)
    }
  }

  [Runtime.InteropServices.Marshal]::Copy($bytes, 0, $data.Scan0, $bytes.Length)
  $strip.UnlockBits($data)
  return $strip
}

New-Item -ItemType Directory -Force $OutDir | Out-Null
$canonPath = (Resolve-Path (Join-Path $BuildDir "stage-$Canonical.png")).Path
$canon = New-Object System.Drawing.Bitmap $canonPath

$W = $canon.Width; $H = $canon.Height
$ew = [int]($W * $EdgeFrac)
$th = [int]($H * $TopFrac)

$leftStrip  = New-FeatheredEdge -Canon $canon -X0 0            -W $ew -H $th -MirrorFade $false
$rightStrip = New-FeatheredEdge -Canon $canon -X0 ($W - $ew)   -W $ew -H $th -MirrorFade $true

Get-ChildItem (Join-Path $BuildDir "stage-??.png") | Sort-Object Name | ForEach-Object {
  $n = [IO.Path]::GetFileNameWithoutExtension($_.Name) -replace 'stage-', ''
  $out = Join-Path $OutDir "stage-$n.png"

  if ($Skip -contains $n) {
    Copy-Item $_.FullName $out -Force
    Write-Output "$n  kihagyva (valtozatlanul atmasolva)"
    return
  }

  $img = New-Object System.Drawing.Bitmap $_.FullName
  $bmp = New-Object System.Drawing.Bitmap $img.Width, $img.Height
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
  $g.DrawImage($img, 0, 0, $img.Width, $img.Height)
  $g.DrawImage($leftStrip,  0,             0)
  $g.DrawImage($rightStrip, ($img.Width - $ew), 0)
  $g.Dispose()

  $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose(); $img.Dispose()
  Write-Output "$n  kesz"
}

$leftStrip.Dispose(); $rightStrip.Dispose(); $canon.Dispose()
