# ACUWALL — ÚJ WEBOLDAL + AI VIDEÓSZEKVENCIÁK

**Teljes specifikáció Claude Code részére.** Ez az egyetlen forrás — minden itt van benne: a videógenerálás, a weboldal, a repo és az élesítés.

**Repo:** `https://github.com/broist/acuwall_website.git`
**Élesítés:** saját szerver, Dockerrel, saját reverse proxy mögött
**MCP:** Higgsfield (`https://mcp.higgsfield.ai/mcp`)

---

# TARTALOM

```
0.   A helyzet
1.   A koncepcióház
2.   Lépéssor
3.   FÁZIS 1 — Felmérés
4.   FÁZIS 2 — Master-render
5.   FÁZIS 3 — A 11 építési fázis
6.   FÁZIS 4 — Az építési videó
7.   FÁZIS 5 — A 8 belső tér
8.   FÁZIS 6–7 — Asset-előkészítés (ffmpeg)
9.   FÁZIS 8 — A weboldal
10.  FÁZIS 9 — Repo, Docker, deploy
11.  Az ajánlatkérő űrlap
12.  Élesítési ellenőrzőlista
13.  Az indítóprompt
```

---

# 0. A HELYZET

**Cég:** AcuWall — **acél** könnyűszerkezetes épületek generálkivitelezése, az ötlettől a kulcsátadásig
**Jelenlegi oldal:** www.acuwall.hu (Next.js) — **ezt váltjuk ki**, nem mellé építünk
**Kapcsolat:** acuwall@acuwall.hu · +36 30 830 5556 · országos kivitelezés
**Szlogen:** „Építsünk együtt."

### Mi a baj a jelenlegi oldallal?

A tartalom jó. A szerkezet jó. A **vizuális anyag** stock: a hero és a záró CTA ugyanaz a Pexels-fotó, az épülettípus-kártyák szintén stockok. Egy generálkivitelezőnél, aki 3D látványtervet is ad, ez ellentmondás.

### Mit csinálunk helyette?

Egy saját, végig egységes **koncepcióházat** generálunk, és köré építjük az oldalt:

| Rész | Mit csinál | Technika |
|---|---|---|
| **A — A ház felépül** | Fix kameraállásból, 11 fázisban felépül az acélvázas ház, ahogy görgetsz | Scroll-scrubbed képszekvencia canvas-en |
| **B — Belső terek** | 8 tér, mindegyik egy menüpont, teljes képernyős videóval | Loop-oló i2v klipek + overlay tipográfia |

A meglévő oldal **minden tartalma megmarad** (Szolgáltatások, LEAN, Folyamat, Épülettípusok, GYIK, Ajánlatkérés) — csak új vizuális gerincre kerül.

### ⚠️ A LEGFONTOSABB SZABÁLY

**A szerkezet ACÉL könnyűszerkezet (LGS), nem favázas.**

Ha bármelyik generált képen fenyő stud fal, OSB, vagy ragasztott fa gerenda jelenik meg, az **hibás és újragenerálandó**. Ez nem esztétikai kérdés — a favázas a konkurencia technológiája, és a videó aktívan félrevezetne. A horganyzott acélváz egyben az AcuWall vizuális érve is: látványosabb, mint a fa, és azonnal megkülönböztet.

---

# 1. A KONCEPCIÓHÁZ

**Név:** `AcuWall Koncepció 01 — „GERINC"` · angol eyebrow: `THE SPINE`

A név nem díszítés: az acélváz *a gerinc*. Az egész oldal erre az egy gondolatra fut ki — a ház gerincét látod felépülni, aztán bemész és látod, mit tart meg.

| | |
|---|---|
| **Stílus** | alpesi-modern |
| **Szerkezet** | hidegen hajlított, horganyzott acél C- és Z-szelvényes váz (LGS) |
| **Méret** | kétszintes, kb. 240 m², konzolos emeleti terasszal |
| **Helyszín** | magyar középhegységi gerinc, bükkös-fenyves erdőszél, ködbe vesző hegyvonulatok, bazalt sziklakibúvások, ősz eleje |

A magyar helyszín hitelesebb, mint egy svájci völgy — az AcuWall Magyarországon épít, és a magyar telektulajdonos így magára ismer. Ha mégis a teljes alpesi verziót akarod, a promptokban a `LOCATION` blokkot cseréld az ott megadott alternatívára; semmi más nem változik.

---

# 2. LÉPÉSSOR

```
FÁZIS 1  Credit- és modellfelmérés .............. Higgsfield MCP
FÁZIS 2  Master-render: a kész ház ............. 1 kép, ez az igazodási pont
FÁZIS 3  Építési fázisok: 11 állókép ........... fix kamera, acélváz
FÁZIS 4  Építési videó: 10 átmenet ............. first/last frame interpoláció
FÁZIS 5  Belső terek: 8 kép + 8 videó .......... terenként
FÁZIS 6  Upscale + letöltés .................... minden asset lokálba
FÁZIS 7  Frame-export + tömörítés .............. ffmpeg, scroll-scrub anyag
FÁZIS 8  Weboldal build ....................... Astro + GSAP
FÁZIS 9  Repo, Docker, deploy .................. GitHub Actions → GHCR
```

**Minden fázis végén állj meg és mutasd meg az eredményt.** Az AI-generálás pénzbe kerül; nem akarunk 40 rossz klipet.

---

# 3. FÁZIS 1 — FELMÉRÉS

Mielőtt bármit generálsz:

1. `balance` — mennyi kredit, milyen csomag
2. `models_explore` — a **jelenleg elérhető** modellek. Kell:
   - erős **text-to-image** (fotorealisztikus építészeti render)
   - **reference-alapú image** (konzisztencia)
   - **image-to-video** (lassú, filmes)
   - ha van **first-frame + last-frame interpoláció** → ez az építési szekvencia kulcsa
3. `presets_show` — kamera-presetek
4. `show_reference_elements` — van-e Elements a workspace-en

**Ne találj ki modellneveket.** Amit a `models_explore` visszaad, azzal dolgozz.

Írd le: melyik modell melyik feladatra és miért, plusz kb. mennyi kredit az egész (≈30 kép + ≈20 videó + upscale). **Utána állj meg és várd meg a jóváhagyást.**

---

# 4. FÁZIS 2 — A MASTER-RENDER

A legfontosabb egyetlen kép az egész projektben. Ehhez igazodik minden más. **4 variánst** generálj, mutasd meg őket.

```
Photoreal architectural photography of a completed two-storey
alpine-modern house built on a light-gauge galvanised steel frame.

FORM: crisp rectilinear volumes. A lower plinth clad in dry-stacked
local basalt. The upper volume clad in vertical charred-and-oiled larch
boards with a fine shadow-gap rhythm. Anthracite standing-seam metal
roof with a thin 900mm cantilevered overhang and concealed gutters.
Floor-to-ceiling glazing across the south face in dark anthracite
aluminium frames. A cantilevered upper terrace with a frameless glass
balustrade, its steel edge beam left honestly visible as a slim dark
line. Deep window reveals.

LOCATION (Hungarian uplands — default):
A ridge-top plot in the Hungarian central highlands. Mature beech and
Scots pine forest flanking the plot, basalt outcrops breaking through
low native grasses. Layered ridgelines receding into soft mist in the
far distance. Early autumn: the beech just turning copper. A raked
gravel approach with basalt slab stepping stones.

LOCATION (alpine alternative — only if swapped in):
A private plot in an alpine lake valley, granite peaks in the far
background, mature Scots pine forest flanking the plot.

CAMERA LOCK — reuse this block verbatim in every later shot:
Fixed tripod camera, three-quarter view from front-left, 35mm
full-frame equivalent lens, camera height 6 metres, 40 metres from the
building face, 4 degrees downward tilt. The building occupies the
central 60% of frame. Horizon line at 45% frame height.

LIGHT LOCK — reuse this block verbatim in every later shot:
Late-afternoon light, sun low from camera-left at roughly 25 degrees,
thin high cirrus, soft directional shadows falling to camera-right,
still air, no haze.

Hasselblad-grade detail, natural colour, no colour grading, no people,
no vehicles, no text, no logos, no watermark, 16:9.
```

**Amikor kiválasztottam a nyerőt:**
- mentsd reference element-ként: `gerinc-master`
- lokálba: `assets/master/gerinc-master.png`
- **minden további generálásnál** add meg referenciának

---

# 5. FÁZIS 3 — A 11 ÉPÍTÉSI FÁZIS

Ez a projekt szíve, és itt dől el, hogy az oldal elad-e. A néző látni fogja, hogy ez acél, nem fa.

A trükk: **a kamera és a fény soha nem mozdul.** Csak a ház változik.

## Minden prompt szerkezete

```
[CAMERA LOCK blokk szó szerint a FÁZIS 2-ből]
[LIGHT LOCK blokk szó szerint a FÁZIS 2-ből]
[LOCATION blokk szó szerint a FÁZIS 2-ből]
Reference: gerinc-master — same plot, same terrain, same ridgelines,
same treeline, identical framing.

STAGE CONTENT: <<< a fázisonként változó rész >>>

Photoreal construction documentary photography. No text, no logos,
no watermark, 16:9.
```

## A 11 fázis

### 01 — A TELEK / `RAW GROUND`
```
An empty ridge-top plot. Undisturbed native grasses and basalt outcrops
where the house will stand. A surveyor's timber batter board with taut
string lines marks the future footprint. Four orange setting-out pegs.
Nothing else built.
```

### 02 — FÖLDMUNKA / `EXCAVATION`
```
Excavation stage. A rectangular pit cut into the ridge, clean vertical
faces, dark exposed subsoil streaked with weathered basalt. A spoil heap
at the plot edge. A yellow tracked excavator parked at the pit's far
corner, boom lowered. Orange drainage pipe stubs and blue water service
protruding from the base. Timber formwork stacked on pallets.
```

### 03 — ALAPOZÁS / `THE SLAB`
```
Foundation complete. A crisp poured-concrete raft slab, still damp and
dark at the edges, power-floated smooth. Rigid insulation visible at the
slab edge. A precise regular grid of galvanised steel hold-down brackets
and cast-in anchor bolts protrudes along the perimeter and gridlines —
the steel connection points are the visual subject of this frame.
Formwork removed and stacked.
```

### 04 — TALPSZELVÉNY + FÖLDSZINTI VÁZ / `THE STEEL RISES`
```
Ground floor steel frame erected. Cold-formed galvanised steel C-section
studs at 600mm centres, bolted into galvanised bottom track anchored to
the slab. Bright zinc spangle finish catching the low sun — the frame
reads as a precise silver lattice, unmistakably steel, not timber.
Punched service holes visible in the web of every stud. Steel headers
over the large openings. Temporary bracing straps. Neat bundles of
labelled steel profiles laid out on the slab.
```

### 05 — EMELETI FÖDÉM / `UPPER DECK`
```
First floor structure in place. Galvanised steel C-section floor joists
span the ground floor walls at close centres, with a steel edge beam
running the perimeter. Half decked in structural sheeting, half showing
open steel joists with the slab visible below. A telescopic mobile crane
at the plot edge, boom extended, a bundle of steel profiles suspended
mid-lift. Full perimeter scaffolding beginning on the near elevation.
```

### 06 — EMELETI VÁZ / `UPPER FRAME`
```
Upper floor steel frame erected. Second-storey galvanised C-section stud
walls on the first floor deck, tall openings framed for the terrace
glazing. The cantilevered terrace steel joists project cleanly from the
upper volume. The full two-storey mass and roofline are now legible in
raw galvanised steel — a complete silver skeleton against the autumn
ridgelines. Scaffolding to full height.
```

### 07 — TETŐSZERKEZET / `THE ROOF FRAME`
```
Roof structure complete. Prefabricated galvanised steel roof trusses
seated on the wall tracks, with steel purlins running across them. The
deep 900mm overhang now cantilevers clear of the walls. The house is
fully framed but entirely open — sky visible through the steel skeleton
from every angle. The regularity and precision of the steel grid is the
subject: every member identical, every spacing exact.
```

### 08 — BURKOLATVÁZ + PÁRAZÁRÁS / `SKIN`
```
Weathertight stage. Roof decked and covered in anthracite standing-seam
metal sheet with a folded drip edge. Walls sheathed and wrapped in a
taut breather membrane, printed logo repeat visible, taped joints.
Anthracite aluminium window frames installed with glazing units in,
protective blue film still on the frames. Vertical cladding battens
fixed over the membrane, ready to receive the larch. Scaffolding still
up on the near elevation.
```

### 09 — HOMLOKZAT / `THE FACE`
```
Cladding stage. Roughly 70% of the vertical charred larch cladding fixed
to the upper volume, its dark grain sharp against the remaining pale
membrane and battens. Dry-stacked basalt plinth cladding two-thirds laid,
with a stack of stone on a pallet at the base. Protective film peeled
from the lower windows, still on the upper. Scaffolding removed from the
near elevation, remaining on the far. The house is becoming itself.
```

### 10 — KÉSZ / `COMPLETION`
```
The finished house, identical in every respect to the reference image
gerinc-master. All scaffolding, plant and materials removed. Raked gravel
approach laid, basalt slab stepping stones, low native planting
established, the frameless glass terrace balustrade in place. Clean,
calm, complete.
```

### 11 — HERO / `DUSK`
*Az egyetlen kép, ahol a LIGHT LOCK változik.*
```
The finished house at blue hour, twenty minutes after sunset. Same camera
lock exactly. Deep indigo sky, the last warm band behind the ridgelines,
mist settling into the valley below. Every interior light on — warm 2700K
glow pouring out through the full-height glazing, the ceilings lit from
within, the terrace washed by concealed linear uplighters. Reflections on
the damp basalt path. The house reads as a lantern on the ridge.
```

## Végrehajtás

- `generate_image_batch`, a 01–11 **egy batchben**
- Utána mutasd meg mind a 11-et **egy összefűzött kontaktlapon**
- Ellenőrizd, sorban:
  - **Elmozdult a kamera bárhol?** → újragenerálás
  - **Változott a háttér gerincvonala?** → újragenerálás
  - **A 04–07 fázisban a váz tényleg acélnak néz ki?** Ha fás, sárgás, gyalult deszkás → újragenerálás
- Mentés: `assets/build/stage-01.png` … `stage-11.png`

---

# 6. FÁZIS 4 — AZ ÉPÍTÉSI VIDEÓ

10 átmenet: 01→02 … 10→11.

### Ha van first/last frame interpoláció (preferált)
`first_frame = stage-N.png`, `last_frame = stage-N+1.png`, 3–4 mp.

```
Locked-off tripod shot, camera absolutely static, zero pan, zero zoom,
zero parallax. A construction time-lapse: the structure assembles itself
between the two frames. Steel members rise into place, workers and
machinery blur through as motion streaks. Cloud shadows drift across the
ridgelines. Smooth, continuous, no cuts, no camera shake. The background
terrain, ridgelines and treeline must remain perfectly still — no
morphing, no drifting, no warping on the landscape.
```

### Ha nincs interpoláció
`generate_video` image-to-video-val fázisonként, ugyanezzel a prompttal, majd ffmpeg keresztúsztatás. Gyengébb, de működik.

### Végrehajtás
- `generate_video_batch`, `jobs_wait`
- **Nézd meg mind a 10-et.** Ami „úszik" a háttérben, azt újragenerálod.
- `upscale_video` a jóváhagyottakra
- Mentés: `assets/build/clip-01-02.mp4` …

---

# 7. FÁZIS 5 — A 8 BELSŐ TÉR

Minden tér **egy menüpont**. Mindegyikhez: 1 hero állókép + 1 loop-olható klip.

| # | Menüpont (HU) | Eyebrow (EN) | Tér |
|---|---|---|---|
| 01 | Előtér | THRESHOLD | belépés, bazalt padló, beépített tölgy szekrénysor |
| 02 | Nappali | THE GREAT ROOM | dupla légtér, kandalló, panorámaüveg a gerincre |
| 03 | Konyha és étkező | HEARTH & TABLE | monolit sziget, tölgy front, rejtett világítás |
| 04 | Lépcső és galéria | THE RISE | lebegő tölgyfokok, feketített acél tartó, galéria |
| 05 | Hálószoba | UPPER CALM | emeleti háló, terasz-kilátás, textil falburkolat |
| 06 | Fürdőszoba | STONE BATH | tömör bazalt kád, mikrocement, lineáris felülvilágító |
| 07 | Dolgozó | THE QUIET ROOM | könyvtárfal, sarokablak az erdőre |
| 08 | Terasz | THE OUTER ROOM | konzolos terasz, tűzhely, alkonyat a gerincen |

## Közös prompt-fej

```
Photoreal interior architectural photography, inside the house from
reference gerinc-master. Consistent material palette throughout:
white-oiled oak floors and joinery, honed basalt, micro-cement walls in
warm grey, blackened steel details, linen textiles. Where structure is
expressed, it is slim blackened steel — never timber posts. Warm 2700K
concealed lighting plus strong natural daylight from full-height
glazing. Autumn beech forest and layered misty ridgelines visible
outside every window.

24mm full-frame lens, one-point perspective, verticals perfectly plumb,
camera at 1.4m eye height. Shot for an architectural monograph: calm,
unstyled, no clutter. No people, no text, no logos, no watermark. 16:9.

ROOM: <<< a táblázat szerinti tér, 2-3 mondatban részletezve >>>
```

## Videók

`generate_video`, image-to-video, minden térre ugyanaz:

```
Extremely slow, smooth dolly-in, roughly 15cm of travel over 5 seconds.
Locked horizon, no roll, no zoom. Subtle life: dust motes drifting in a
sunbeam, a linen curtain breathing, mist moving on the ridgelines
outside, a slow cloud shadow crossing the floor. Everything else
perfectly still. Cinematic, tripod-grade, seamlessly loopable.
```

Mentés: `assets/rooms/01-eloter.png` + `01-eloter.mp4` stb.

---

# 8. FÁZIS 6–7 — ASSET-ELŐKÉSZÍTÉS (FFMPEG)

## 8a. Építési szekvencia → képsorozat

**Ne `<video>` scrub-ot használj.** A `currentTime` scrubbing iOS Safariban akadozik. Képsorozat canvas-en, ahogy az Apple csinálja.

```bash
printf "file '%s'\n" assets/build/clip-*.mp4 > /tmp/list.txt
ffmpeg -f concat -safe 0 -i /tmp/list.txt -c copy assets/build/sequence.mp4

mkdir -p public/seq
ffmpeg -i assets/build/sequence.mp4 -vf "fps=30,scale=1920:-2" -q:v 2 public/seq/frame_%04d.jpg
for f in public/seq/frame_*.jpg; do
  avifenc --min 24 --max 34 --speed 4 "$f" "${f%.jpg}.avif"
done
rm public/seq/*.jpg

mkdir -p public/seq-sm
ffmpeg -i assets/build/sequence.mp4 -vf "fps=30,scale=960:-2" -q:v 3 public/seq-sm/frame_%04d.jpg
for f in public/seq-sm/frame_*.jpg; do
  avifenc --min 28 --max 38 --speed 4 "$f" "${f%.jpg}.avif"
done
rm public/seq-sm/*.jpg
```

**Célszám:** 180 kocka × ~50 KB ≈ 9 MB desktop, ~3 MB mobil. 12 MB fölött csökkentsd 120 kockára.

## 8b. Szobavideók → web

```bash
mkdir -p public/rooms
for f in assets/rooms/*.mp4; do
  b=$(basename "$f" .mp4)
  ffmpeg -i "$f" -c:v libsvtav1 -crf 34 -preset 6 -an -vf "scale=1600:-2" "public/rooms/$b.webm"
  ffmpeg -i "$f" -c:v libx264 -crf 26 -preset slow -an -movflags +faststart -vf "scale=1600:-2" "public/rooms/$b.mp4"
  ffmpeg -i "$f" -vframes 1 -vf "scale=1600:-2" "public/rooms/$b.jpg"
done
```

Minden szobavideó: **némítva, `playsinline`, `loop`, `preload="none"`**, IntersectionObserver indítja.

---

# 9. FÁZIS 8 — A WEBOLDAL

## Stack

```
Astro 5             statikus kimenet, nulla JS alapból
Tailwind 4          utility, a tokenek CSS változókban
GSAP ScrollTrigger  scroll-scrub és reveal-ek
Lenis               smooth scroll
```

**Ne Next.js**, még ha a mostani oldal az is. Ez statikus prezentációs oldal; az Astro build triviálisan dockerizálható nginx-szel, és a 180 AVIF kocka kiszolgálása így a leggyorsabb.

## Design tokenek

A paletta az **acél könnyűszerkezet saját anyagvilágából** jön:

```css
:root {
  --ink:     #0A0C0D;  /* antracit — az AcuWall saját épületszíne */
  --ink-2:   #14181A;  /* emelt felület */
  --bone:    #E6EAEC;  /* elsődleges szöveg */
  --zinc:    #8E9BA1;  /* horganyzott acél — másodlagos szöveg */
  --spangle: #C2D0D6;  /* cinkvirág — hajszálvonalak, elválasztók */
  --lumen:   #F0B267;  /* 2700K belső fény — AZ akcent */
}
```

**Az akcentszín logikája:** a `--lumen` nem márkaszín, hanem *a ház belsejében égő fény*. Ezért csak ott jelenik meg, ahol tényleg fény van: az építési sáv kitöltésén (görgetésre „bevilágosodik" a ház), az aktív menüponton, és a fókuszgyűrűn. Sehol máshol nincs szín. Ez a fegyelem adja a profi érzetet.

## Tipográfia

```
Display:  Archivo Expanded  w200–300, uppercase, letter-spacing 0.18em
Body:     Archivo           w400
Utility:  Martian Mono      w300, 11px, uppercase, a műszaki adatoszlophoz
```

Mind ingyenes (OFL). Egy család két szélességben + egy mono = kohézió variancia nélkül.

```
display-xl  clamp(3.5rem, 9vw, 9rem)
display-l   clamp(2.5rem, 6vw, 5.5rem)
eyebrow     0.6875rem  mono, tracking 0.3em
body        1.0625rem / 1.65
data        0.6875rem  mono, tabular-nums
```

## Signature elem

**A bal szélen végigfutó építési sáv.** 1px vonal a viewport bal oldalán, 11 osztásjellel, mellettük a fázisnevek mono-ban. Görgetésre a `--lumen` kitöltés emelkedik, az aktív fázis `--bone`-ra vált, a többi `--zinc`.

A számozás **indokolt**: az építés tényleg sorrend, és az AcuWall folyamata már ma is 01–05-ként van számozva a jelenlegi oldalon. Ez a meglévő márkalogika kiterjesztése, nem díszítés.

## Oldalszerkezet

A jelenlegi oldal **minden tartalma** megmarad, új gerincre húzva:

```
┌──────────────────────────────────────────────────────────┐
│ 00  BELÉPÉS                                              │
│     stage-11 kékórás hero · „Építsünk együtt"            │
│     H1: Könnyűszerkezetes épület kulcsrakészen,          │
│         egy felelőssel.                                  │
│     Nincs klasszikus navbar — sarokban menügomb + logó   │
├──────────────────────────────────────────────────────────┤
│ 01  A HÁZ FELÉPÜL              ← SIGNATURE               │
│     sticky 100vh canvas, ~600vh görgetési magasság       │
│     Bal sáv: 01–11 építési fázisindikátor                │
│     Fázisonként overlay szövegblokk (bal alsó, mono)     │
│     A szöveg valódi kivitelezési tartalmat mond:         │
│     „04 · ACÉLVÁZ — horganyzott C-szelvények, 600 mm"    │
├──────────────────────────────────────────────────────────┤
│ 02  BELSŐ TEREK                ← 8 menüpont              │
│     Térenként 100vh, snap-scroll, videóháttér            │
│     Bal: display cím + eyebrow + 1 mondat                │
│     Jobb: 5 soros műszaki adatoszlop, mono               │
│     Jobb alsó: 01/08 számláló · alul vízszintes nav      │
├──────────────────────────────────────────────────────────┤
│ 03  EGY FELELŐS                ← meglévő „Bemutatkozás"  │
│     Egy szerződés · Ütemezett fizetés · Végig átlátható  │
├──────────────────────────────────────────────────────────┤
│ 04  MIÉRT AZ ACUWALL           ← meglévő 6 pont          │
├──────────────────────────────────────────────────────────┤
│ 05  SZOLGÁLTATÁSOK             ← Tervek / Statika /      │
│     3D modell / Kulcsrakész kivitelezés                  │
├──────────────────────────────────────────────────────────┤
│ 06  LEAN                       ← meglévő tartalom        │
│     Amit csökkentünk: Várakozás · Hibák · Anyagveszteség │
├──────────────────────────────────────────────────────────┤
│ 07  A FOLYAMAT                 ← meglévő 01–05           │
│     Ugyanaz a numerikus nyelv, mint a hero sávban        │
├──────────────────────────────────────────────────────────┤
│ 08  ÉPÜLETTÍPUSOK              ← 6 típus                 │
│     Garázs · Műhely/csarnok · Irodaház · Nyaraló ·       │
│     Lakóház · Saját fejlesztés                           │
│     FONTOS: itt is generált képek kellenek, nem stock    │
├──────────────────────────────────────────────────────────┤
│ 09  GYIK                       ← meglévő 8 kérdés        │
├──────────────────────────────────────────────────────────┤
│ 10  AJÁNLATKÉRÉS               ← a meglévő 9 mezős űrlap │
│     Név · E-mail · Telefon · Helyszín · Épülettípus ·    │
│     Alapterület · Telek állapota · Tervezés · Indulás ·  │
│     Megjegyzés · GDPR checkbox                           │
│     Alatta: +36 30 830 5556 · acuwall@acuwall.hu ·       │
│     Országos · 24h válaszidő · H–P 08:00–17:00           │
└──────────────────────────────────────────────────────────┘
```

> **Az épülettípusokhoz:** a 6 típuskártya jelenleg stockfotó. Ha marad kredit a fő szekvencia után, generálj mind a 6-hoz egy-egy képet ugyanazzal az anyagpalettával (antracit + horganyzott acél + fa). Különben a lenyűgöző hero után egy stockfotós szekcióba fut a látogató.

## A scroll-scrub implementáció

```
1. Előtöltés: az első 20 kockát blokkolóan, a többit háttérben, progresszíven
2. Canvas devicePixelRatio-val skálázva, de max 2x
3. ScrollTrigger scrub: 0.5 — nem 1, nem true.
   A 0.5 adja a „nehéz, súlyos" építkezés-érzetet
4. Rajzolás requestAnimationFrame-ben, csak ha a frame index változott
5. object-fit: cover logika kézzel a drawImage-ben
6. prefers-reduced-motion esetén: nincs scrub, 4 statikus kép egymás alatt
```

**Lenis:** `lerp: 0.08`, `wheelMultiplier: 0.9`, a GSAP tickerhez kötve.

## Minőségi alapelvárások

- Mobilon 380px-től működik, a `seq-sm` képekkel
- Látható fókuszgyűrű billentyűzetnél (`--lumen`)
- `prefers-reduced-motion` teljesen tiszteletben tartva
- Lighthouse: Performance 90+, Accessibility 95+, SEO 100
- Minden kép `width`/`height` attribútummal, nulla layout shift
- Az űrlap JS nélkül is elküldhető
- Szemantikus `<h1>`/`<h2>` hierarchia — a jelenlegi oldal SEO-ját nem szabad elveszíteni
- **A meglévő meta-leírásokat és kulcsszavakat vidd át**, és a `/adatkezeles` oldal maradjon

---

# 10. FÁZIS 9 — REPO, DOCKER, DEPLOY

## 10a. Mi megy gitbe, mi nem

Ez a legfontosabb döntés a repóban. Kétféle asset lesz:

| Mappa | Tartalom | Méret | Gitbe? |
|---|---|---|---|
| `assets/` | Nyers anyag: 4K masterek, eredeti klipek, `sequence.mp4` | **több GB** | ❌ NEM |
| `public/seq/` | 180 AVIF kocka, 1920px | ~9 MB | ✅ igen |
| `public/seq-sm/` | 180 AVIF kocka, 960px | ~3 MB | ✅ igen |
| `public/rooms/` | 8 tér × (webm + mp4 + jpg) | ~50–80 MB | ✅ igen |
| `public/img/` | Épülettípus-képek, OG-kép | ~5 MB | ✅ igen |

**Összesen ~70–100 MB a repóban.** Rendben van: a GitHub 100 MB-os korlátja *fájlonként* él, és nálunk a legnagyobb egyedi fájl egy ~8 MB-os szobavideó.

**Git LFS-t ne használj**, hacsak nem nő 300 MB fölé. Az LFS a szerveren külön kliens-telepítést és hitelesítést igényel — feleslegesen bonyolítja a `git pull`-t.

> **A nyers anyag hova kerül?** Az `assets/` a te gépeden marad. Mentsd külön (NAS, külső HDD, felhő) — ha valaha újra kell vágni a szekvenciát vagy más felbontásban exportálni, ez az egyetlen forrás. Higgsfieldről később már nem biztos, hogy letölthető.

## 10b. `.gitignore`

**Ennek készen kell lennie az ELSŐ generált fájl előtt.** Ha egyszer bekerül a history-ba egy 800 MB-os master, azt utólag `git filter-repo`-val kell kiszedni, és mindenkinek újra kell klónoznia.

```gitignore
# Nyers generált anyag — több GB, soha nem megy gitbe
assets/

# Node
node_modules/
.astro/
dist/

# Környezeti változók — SOHA
.env
.env.*
!.env.example

# Rendszer
.DS_Store
Thumbs.db
*.log
```

## 10c. `.dockerignore`

**Nem ugyanaz, mint a `.gitignore`** — más a cél. A gitignore azt zárja ki, amit nem verziózunk; a dockerignore azt, ami lassítja a build contextet.

```dockerignore
assets/
node_modules/
dist/
.git/
.github/
*.md
.env
.env.*
```

A `.git/` külön fontos: a repo history önmagában is tíz-húsz MB, és semmi keresnivalója a build contextben.

## 10d. Repo-szerkezet

```
acuwall_website/
├── .github/workflows/build.yml   ← image build + push GHCR-be
├── public/
│   ├── seq/                      180 AVIF kocka (desktop)
│   ├── seq-sm/                   180 AVIF kocka (mobil)
│   ├── rooms/                    8 tér videói + poszterei
│   ├── img/                      épülettípusok, OG-kép
│   └── favicon.svg
├── src/
│   ├── components/
│   ├── layouts/
│   ├── pages/
│   │   ├── index.astro
│   │   └── adatkezeles.astro     ← a meglévő oldalról átvéve
│   └── styles/tokens.css
├── mailer/                       ← csak ha a B) űrlap-opció kell
├── assets/                       ← GITIGNORE-olva, csak lokálisan
├── Dockerfile
├── nginx.conf
├── compose.yaml                  ← fejlesztéshez, helyi buildhez
├── compose.prod.yaml             ← élesítéshez, kész image-dzsel
├── .env.example
├── .gitignore
├── .dockerignore
├── BRIEF.md                      ← ez a fájl
└── README.md
```

## 10e. `Dockerfile`

```dockerfile
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.27-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost/ >/dev/null || exit 1
```

## 10f. `nginx.conf` (a konténeren belül)

```nginx
server {
  listen 80;
  root /usr/share/nginx/html;
  index index.html;

  gzip on;
  gzip_types text/css application/javascript image/svg+xml;

  location /seq/ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    access_log off;
  }
  location /rooms/ {
    expires 1y;
    add_header Cache-Control "public, immutable";
  }
  location ~* \.(js|css|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
  }
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

## 10g. Build: GitHub Actions → GHCR

A szervered ne buildeljen. Az `npm ci` + Astro build + 360 AVIF fájl másolása egy kisebb VPS-en 3–8 perc, és node-ot is kellene telepíteni. Ehelyett a GitHub buildel, a szerver csak lehúzza a kész image-et.

### `.github/workflows/build.yml`

```yaml
name: Build and push image

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/metadata-action@v5
        id: meta
        with:
          images: ghcr.io/broist/acuwall_website
          tags: |
            type=raw,value=latest
            type=sha,format=short
      - uses: docker/build-push-action@v6
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

Minden `main`-re pusholt commit után ~2 perccel kész az új image `ghcr.io/broist/acuwall_website:latest` néven, plusz egy commit-hash taggel (ez kell a visszaállításhoz).

> **Egyszeri beállítás a GitHubon:** repo → Settings → Actions → General → Workflow permissions → *Read and write permissions*. Enélkül a GHCR push 403-mal elszáll.

## 10h. `compose.prod.yaml`

```yaml
services:
  web:
    image: ghcr.io/broist/acuwall_website:${IMAGE_TAG:-latest}
    container_name: acuwall-web
    restart: unless-stopped
    ports:
      - "127.0.0.1:8080:80"
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost/"]
      interval: 30s
      timeout: 3s
      retries: 3
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"

  # Csak ha a B) opciót választod az űrlaphoz (lásd 11. fejezet)
  mailer:
    build: ./mailer
    container_name: acuwall-mailer
    restart: unless-stopped
    env_file: .env
    ports:
      - "127.0.0.1:8081:3000"
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

**A `127.0.0.1:` előtag fontos.** Enélkül a konténer portja kifelé is nyitva van, és a reverse proxy megkerülhető.

Ha a proxyd is konténerben fut (Traefik, Nginx Proxy Manager), akkor `ports` helyett közös docker network:

```yaml
services:
  web:
    image: ghcr.io/broist/acuwall_website:${IMAGE_TAG:-latest}
    restart: unless-stopped
    networks: [proxy]
    # nincs ports szekció — a proxy a hálózaton belül éri el

networks:
  proxy:
    external: true
```

## 10i. Élesítés a szerveren

### Első alkalommal

```bash
cd /opt
git clone https://github.com/broist/acuwall_website.git
cd acuwall_website

cp .env.example .env
nano .env                      # SMTP adatok, ha kell

# GHCR bejelentkezés (ha privát a repo)
# Token: GitHub → Settings → Developer settings →
#        Personal access tokens → Fine-grained → read:packages
echo "$GHCR_TOKEN" | docker login ghcr.io -u broist --password-stdin

docker compose -f compose.prod.yaml up -d
docker compose -f compose.prod.yaml ps
curl -I http://localhost:8080
```

### Frissítéskor

```bash
cd /opt/acuwall_website
git pull
docker compose -f compose.prod.yaml pull
docker compose -f compose.prod.yaml up -d
docker image prune -f
```

Három parancs, ~30 másodperc, nulla állásidő.

### Visszaállítás

```bash
docker compose -f compose.prod.yaml down
IMAGE_TAG=sha-a1b2c3d docker compose -f compose.prod.yaml up -d
```

## 10j. A szervered nginx-e (a konténer előtt)

Ez a **te oldalad**, nem a repóé — de két dolog el tudja rontani a hero szekvenciát:

1. **Ha van globális `limit_req` vagy `limit_conn`**, a `/seq/` útvonalat vedd ki alóla. A böngésző 180 fájlt tölt le gyors egymásutánban; egy szigorú rate limit ezt megfojtja, és pont a hero fog akadozni.
2. **HTTP/2 vagy HTTP/3 legyen bekapcsolva.** A sok apró fájl ott nyer sokat.

```nginx
server {
  listen 443 ssl;
  http2 on;
  server_name acuwall.hu www.acuwall.hu;

  ssl_certificate     /etc/letsencrypt/live/acuwall.hu/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/acuwall.hu/privkey.pem;

  location /seq/ {
    proxy_pass http://127.0.0.1:8080;
    proxy_buffering off;
  }

  location /api/ {                          # csak a B) űrlap-opciónál
    proxy_pass http://127.0.0.1:8081;
    proxy_set_header X-Real-IP $remote_addr;
  }

  location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}

server {
  listen 80;
  server_name acuwall.hu www.acuwall.hu;
  return 301 https://$host$request_uri;
}
```

---

# 11. AZ AJÁNLATKÉRŐ ŰRLAP

Egy statikus Astro-oldal **nem tud e-mailt küldeni.** A 9 mezős ajánlatkérő az egyetlen nem-statikus darab. Két út:

### A) Külső form-szolgáltatás — *leggyorsabb*
Web3Forms / Formspree / Resend. Az űrlap `POST`-ol egy külső endpointra, az küldi az e-mailt.
- ➕ nulla infrastruktúra, működik azonnal, ingyenes csomagok is vannak
- ➖ a leadadat átfut egy harmadik félen (a GDPR-tájékoztatóban jelölni kell)

### B) Saját mailer-konténer — *ajánlott, mert saját szervered van*
Egy apró konténer (Node vagy Go, ~15 MB), ami `POST /api/ajanlat`-ot fogad és SMTP-n továbbküld.
- ➕ az adat nem hagyja el a szervered, nincs havi díj, teljes kontroll
- ➖ kell hozzá egy SMTP-hozzáférés

**Az SMTP-hez** annak a szolgáltatónak az adatai kellenek, ahol az `acuwall@acuwall.hu` postafiók van (bármelyik levelezőrendszer működik: Google Workspace, Microsoft 365, cPanel-es tárhely, vagy egy tranzakciós szolgáltató mint a Resend/Brevo/Mailgun/SMTP2GO).

> **Ne állíts fel saját mailszervert nulláról.** SPF, DKIM, DMARC, IP-reputáció, blacklistek — a leveleid a spam mappában landolnának, és az ajánlatkéréseid vesznének el. Relay-t használj, ne saját MTA-t.

### `.env.example` (ez mehet gitbe, kitöltetlenül)

```bash
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=
MAIL_TO=acuwall@acuwall.hu
MAIL_FROM=noreply@acuwall.hu
```

A valódi `.env` **csak a szerveren létezik**, gitignore-olva.

---

# 12. ÉLESÍTÉSI ELLENŐRZŐLISTA

```
[ ] beta.acuwall.hu-n fut, mobilon is végignézve
[ ] A hero szekvencia sima 4G-n is (DevTools → Network throttle)
[ ] Az ajánlatkérő űrlap tényleg küld e-mailt az acuwall@acuwall.hu-ra
[ ] /adatkezeles oldal él és elérhető az űrlap alól
[ ] A meglévő meta-tagek átvéve (title, description, og:*)
[ ] A régi horgonyok élnek: #fooldal #szolgaltatasok #lean #folyamat
    #epulettipusok #gyik #kapcsolat #ajanlatkeres
[ ] Lighthouse: Perf 90+, A11y 95+, SEO 100
[ ] .env NINCS a repóban (git log -- .env üres)
[ ] Konténer újraindul szerver-reboot után (restart: unless-stopped)
[ ] Csak ezután: DNS-váltás
```

---