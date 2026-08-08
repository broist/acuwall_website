<#
.SYNOPSIS
  A kivagott JPEG kockasorozatot AVIF-fa alakitja, avifenc nelkul.

.DESCRIPTION
  A BRIEF 8a eredetileg avifenc-et ir elo, az viszont nincs telepitve.
  Az ffmpeg 9.0 libaom-av1 encodere ugyanezt tudja still-picture modban.

  Merve, 1920px-es kockan:
    crf 36 -> 87 KB/kocka -> 15.3 MB
    crf 40 -> 68 KB/kocka -> 12.0 MB
    crf 44 -> 52 KB/kocka ->  9.2 MB   <- ez tartja a BRIEF 9 MB-os celjat

  A mobil keszlet 960px szeles, ott a crf 46 hozza a ~3 MB-ot.

.EXAMPLE
  .\tools\seq-to-avif.ps1
  .\tools\seq-to-avif.ps1 -KeepJpg      # nem torli a JPEG forrast
#>
param(
  [string]$Ffmpeg = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-9.0-full_build\bin\ffmpeg.exe",
  [int]$CrfDesktop = 44,
  [int]$CrfMobile  = 46,
  [int]$CpuUsed    = 6,
  [switch]$KeepJpg
)

if (-not (Test-Path $Ffmpeg)) { throw "ffmpeg nem talalhato: $Ffmpeg" }

foreach ($set in @(
  @{ dir = "public\seq";    crf = $CrfDesktop },
  @{ dir = "public\seq-sm"; crf = $CrfMobile  }
)) {
  $files = Get-ChildItem (Join-Path $set.dir "frame_*.jpg") | Sort-Object Name
  if (-not $files) { Write-Output "$($set.dir): nincs JPEG kocka, kihagyva"; continue }

  $n = 0
  foreach ($f in $files) {
    $out = [IO.Path]::ChangeExtension($f.FullName, ".avif")
    & $Ffmpeg -hide_banner -loglevel error -y -i $f.FullName `
      -c:v libaom-av1 -crf $set.crf -cpu-used $CpuUsed -still-picture 1 -pix_fmt yuv420p $out
    $n++
    if ($n % 30 -eq 0) { Write-Output "  $($set.dir): $n / $($files.Count)" }
  }

  if (-not $KeepJpg) { $files | Remove-Item -Force }

  $avif = Get-ChildItem (Join-Path $set.dir "frame_*.avif")
  $mb = [Math]::Round((($avif | Measure-Object -Property Length -Sum).Sum / 1MB), 2)
  $avg = [Math]::Round((($avif | Measure-Object -Property Length -Average).Average / 1KB), 1)
  Write-Output ("{0,-16} {1} kocka   {2} MB   atlag {3} KB/kocka" -f $set.dir, $avif.Count, $mb, $avg)
}
