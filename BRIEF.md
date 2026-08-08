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
| **Stílus** | modern csűr (barn-modern) — meredek nyeregtető, ereszkinyúlás nélkül |
| **Szerkezet** | hidegen hajlított, horganyzott acél C- és Z-szelvényes váz (LGS), meredek acél rácsostartós nyeregtetővel |
| **Méret** | másfél szintes, kb. 200 m² — teljes belmagasságú nagytér + tölgy galéria, mellette hosszú alacsony szárny |
| **Burkolat** | homokszínű klinker **lapburkolat lécvázon** az oromfalon + antracit korcolt lemez, ami a hosszoldalon lefordul a falra |
| **Helyszín** | magyar középhegységi gerinc, drámai rétegzett hegyvonulatok, bükkös-fenyves, bazalt kibúvások, tükröződő vízfelület, ősz eleje |

A név most háromszorosan is talál: az acél rácsostartók **bordázata egy gerinc mentén**, a **hegygerinc**, amin a ház áll, és a **tartószerkezet mint gerinc**. A csűrforma ráadásul az acélnak kedvez — egy meredek nyeregtető horganyzott rácsostartókból sokkal látványosabb, mint egy lapos doboz.

A magyar helyszín hitelesebb, mint egy svájci völgy — az AcuWall Magyarországon épít, és a magyar telektulajdonos így magára ismer. A `LOCATION` blokk ezért drámaian hegyvidéki, de magyar karakterű: meredek, erdős lejtők, egymás mögé rétegződő hegyvonulatok. Ha mégis a teljes alpesi verziót akarod, a `LOCATION` blokkot cseréld az ott megadott alternatívára; semmi más nem változik.

### ⚠ A klinker és az acél viszonya

A homlokzat **lapburkolat**, nem tömör falazat. Ez valós építési mód acélvázon, és a szekvencia becsületessége múlik rajta: a **09-es fázisban látszania kell, hogy a klinkerlapok lécvázra mennek fel.** Ha a kész ház tömör téglafalúnak olvasódik, az egész építési videó önmagának mond ellent — acélvázat mutatnánk, amiből tégla ház lesz.

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
Photoreal architectural photography of a completed single-and-a-half
storey modern barn house built on a light-gauge galvanised steel frame.

FORM: one long primary volume under a steep symmetrical gable roof at
45 degrees, with NO eaves overhang anywhere — the roof plane stops flush
with the wall in a sharp knife edge, gutters fully concealed. The roof is
anthracite standing-seam metal that continues down over both long
elevations, so roof and flank read as one continuous dark skin with an
unbroken seam rhythm. The gable end facing the valley is clad in warm
sand-coloured brick slips in a fine stack bond. Full-height glazing fills
that gable end in slim matte-black aluminium frames, carried up into the
triangular apex as a single glazed gable light. A recessed covered
terrace is cut into the ground floor beneath the gable, its soffit lined
in oiled oak. A long low single-storey wing extends to camera-right,
flat-roofed in the same anthracite metal, with deep-set square windows.
Through the gable glazing an oak mezzanine gallery is visible, its
blackened steel edge beam left honestly exposed as a slim dark line.

LOCATION (Hungarian uplands — default):
A ridge-top plot high in the Hungarian central highlands. Steep forested
slopes fall away below the plot on the valley side. Mature beech and
Scots pine forest flanking the plot, large basalt outcrops breaking
through low native grasses and ornamental feather grasses. Range after
range of layered mountain ridgelines receding into soft mist far below
and beyond, the furthest almost dissolved into the sky. Early autumn:
the beech just turning copper. A still dark reflecting pool with a
basalt slab edge lies in front of the gable, mirroring the roofline. A
raked gravel approach with basalt slab stepping stones. Low frosted-glass
sphere lights sitting down in the grasses.

LOCATION (alpine alternative — only if swapped in):
A ridge-top plot in an alpine valley, granite peaks in the far
background, mature Scots pine forest flanking the plot.

CAMERA LOCK — reuse this block verbatim in every later shot:
Fixed tripod camera, three-quarter view from front-left, so the full
glazed gable end and one long flank are both visible. 35mm full-frame
equivalent lens, camera height 4 metres, 55 metres from the gable face,
1.5 degrees downward tilt. The building occupies the central 70% of
frame. Horizon line at 52% frame height.

LIGHT LOCK — reuse this block verbatim in every later shot:
Late-afternoon light, sun low from camera-left at roughly 25 degrees,
thin high cirrus, soft directional shadows falling to camera-right,
still air, no haze.

Hasselblad-grade detail, natural colour, no colour grading, no people,
no vehicles, no text, no logos, no watermark, 16:9.
```

> **Miért változott a CAMERA LOCK?** A régi (6 m magasság, 40 m távolság,
> 4° letekintés, központi 60%) egy tömör kétszintes kockára készült. A csűr
> hosszú, alacsony tömeg egy magas oromfallal: 6 méterről lenézve az oromfal
> ellaposodik és elveszti a sziluettjét. A 4 m magasság és az 1,5°-os
> letekintés megtartja a tető égbe vágó élét, az 55 m távolság és a központi
> 70% pedig befogja a hosszú szárnyat is.

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
Reference: <<<gerinc-master element id>>> gerinc-master — same plot, same
terrain, same ridgelines, same treeline, identical framing.

STAGE CONTENT: <<< a fázisonként változó rész >>>

CRITICAL — WHAT DOES NOT EXIST YET IN THIS FRAME:
<<< fázisonként: mi az, ami ekkor még nincs meg >>>

SITE STATE — an active building site, not a finished garden:
The reflecting pool is an empty unlined excavation with raw earth sides.
No planting established, no ornamental grasses, no sphere lights, no
raked gravel and no stepping stones yet — only bare churned earth,
compacted site tracks and stacked materials where the landscape will
later go.

Photoreal construction documentary photography. No people. No text, no
logos, no watermark, 16:9.
```

### A két új blokkról

A `CAMERA LOCK` / `LIGHT LOCK` / `LOCATION` **érinthetetlen**. A `STAGE CONTENT`
viszont a prompt kifejezetten fázisonként változó része — ezért került alá két
új alblokk, a KAPU 2 tanulságai alapján:

- **WHAT DOES NOT EXIST YET** — enélkül a modell a referenciakép teljes tömege
  felé húz, és a 04-re is kész tetőt rajzol. Fázisonként változik.
- **SITE STATE** — enélkül a `LOCATION` verbatim másolása kész kertet
  eredményez az építkezésen: tele medence, beállt növényzet, lerakott kavics.
  A 01–09-en végig azonos, a 09-nél enyhül (kavics részben lerakva), a 10–11-nél
  elmarad.

## A 11 fázis

### 01 — A TELEK / `RAW GROUND`
```
An empty ridge-top plot. Undisturbed native grasses and basalt outcrops
where the house will stand. A surveyor's timber batter board with taut
string lines marks the future footprint — a long rectangle with a shorter
wing off one side. Four orange setting-out pegs. A shallow natural hollow
where the reflecting pool will later sit. Nothing else built.
```

### 02 — FÖLDMUNKA / `EXCAVATION`
```
Excavation stage. A long rectangular pit cut into the ridge with a
shorter arm off one side, clean vertical faces, dark exposed subsoil
streaked with weathered basalt. A spoil heap at the plot edge. A yellow
tracked excavator parked at the pit's far corner, boom lowered. Orange
drainage pipe stubs and blue water service protruding from the base.
Timber formwork stacked on pallets.
```

### 03 — ALAPOZÁS / `THE SLAB`
```
Foundation complete. A crisp poured-concrete raft slab in the long barn
footprint with its side wing, still damp and dark at the edges,
power-floated smooth. Rigid insulation visible at the slab edge. A
precise regular grid of galvanised steel hold-down brackets and cast-in
anchor bolts protrudes along the perimeter and gridlines — the steel
connection points are the visual subject of this frame. Formwork removed
and stacked.
```

### 04 — ACÉLVÁZ / `THE STEEL RISES`
*Átfazírozva a KAPU 2 után: a falak és az oromfal-háromszögek együtt állnak fel — valós LGS-építésnél is így megy, és a modell is ezt adja megbízhatóan. Tető még nincs.*
```
Ground floor steel frame erected. Cold-formed galvanised steel C-section
studs at 600mm centres, bolted into galvanised bottom track anchored to
the slab. Bright zinc spangle finish catching the low sun — the frame
reads as a precise silver lattice, unmistakably steel, not timber.
Punched service holes visible in the web of every stud. Tall steel
headers over the full-height gable opening and over the wing's square
windows. The long barn footprint and its low side wing are both legible
in raw steel. Temporary bracing straps. Neat bundles of labelled steel
profiles laid out on the slab. The tall triangular gable-end walls are
framed in steel to their full apex, the raking top tracks climbing
cleanly to the ridge points — but nothing spans between them.
```
```
CRITICAL — WHAT DOES NOT EXIST YET IN THIS FRAME:
No roof structure whatsoever. No trusses, no rafters, no purlins, no
ridge beam — nothing spans between the two gable apexes, open sky
between them. No mezzanine and no upper floor joists; the slab is
visible across the whole footprint.
```

### 05 — GALÉRIAFÖDÉM / `MEZZANINE DECK`
```
Mezzanine structure in place. Galvanised steel C-section floor joists
span only the rear two-thirds of the long volume, leaving the tall
gable-end bay open to the slab below — the double-height great room is
already readable as a void. A galvanised steel edge beam runs along the
open edge of the mezzanine. Half decked in structural sheeting, half
showing open steel joists. A telescopic mobile crane at the plot edge,
boom extended, a bundle of steel profiles suspended mid-lift. Perimeter
scaffolding beginning on the near flank.
```

### 06 — TETŐGERINC / `THE RIDGE`
*Átfazírozva: a régi „oromfal-váz" beolvadt a 04-be, helyette a tető emelésének kezdete — ez adja a szekvencia legdinamikusabb klipjét.*
```
The roof is going up. A long galvanised steel ridge beam now spans
between the two gable apexes, and the first three or four steep
galvanised roof trusses are seated on the wall tracks at the far end,
standing alone against the sky with wide gaps between them. The rest of
the roof is still open. A telescopic mobile crane at the plot edge, boom
extended high, a single truss suspended mid-lift on slings. Bundles of
remaining trusses laid out on the mezzanine deck. Scaffolding to full
height on the near flank.
```

### 07 — TETŐSZERKEZET / `THE ROOF FRAME`
*A szekvencia csúcspontja. Ez a kocka adja el az acélt.*
```
Roof structure complete. Prefabricated galvanised steel roof trusses at a
steep 45 degrees seated on the wall tracks, with steel purlins running
across them — a long silver ribcage marching down the ridge against the
misty autumn mountains. No overhang anywhere: the trusses stop flush at
the gable. The house is fully framed but entirely open, sky visible
through the steel skeleton from every angle. The regularity and precision
of the steel grid is the subject: every member identical, every spacing
exact.
```

### 08 — BURKOLATVÁZ + PÁRAZÁRÁS / `SKIN`
```
Weathertight stage. Roof decked and covered in anthracite standing-seam
metal sheet, the seams running unbroken from the ridge down over both
long elevations with a folded drip edge and no overhang. Walls sheathed
and wrapped in a taut breather membrane, printed logo repeat visible,
taped joints. Matte-black aluminium window frames installed with glazing
units in, including the full-height gable glazing, protective blue film
still on the frames. Horizontal cladding battens fixed over the membrane
on the gable end, ready to receive the brick slips. Scaffolding still up
on the near flank.
```

### 09 — HOMLOKZAT / `THE FACE`
*A becsületesség-kocka. Itt kell látszania, hogy a klinker burkolat, nem falazat.*
```
Cladding stage. Roughly 70% of the warm sand-coloured brick slips fixed
to the gable end in a fine stack bond. The cut edge of the unfinished
area is the subject of this frame: the thin slips are clearly a cladding
layer fixed to horizontal battens over the membrane, not solid masonry —
the batten cavity behind them is legible. A stack of slips on a pallet
and a bucket of adhesive at the base. Protective film peeled from the
lower glazing, still on the gable light above. Scaffolding removed from
the near flank, remaining on the far. The house is becoming itself.
```

### 10 — KÉSZ / `COMPLETION`
```
The finished house, identical in every respect to the reference image
gerinc-master. All scaffolding, plant and materials removed. The
reflecting pool filled and perfectly still, mirroring the gable. Raked
gravel approach laid, basalt slab stepping stones, ornamental feather
grasses and low native planting established. Clean, calm, complete.
```

### 11 — HERO / `DUSK`
*Az egyetlen kép, ahol a LIGHT LOCK változik.*
```
The finished house at blue hour, twenty minutes after sunset. Same camera
lock exactly. Deep indigo sky, the last warm band behind the mountain
ridgelines, mist settling into the valley far below. Every interior light
on — warm 2700K glow pouring out through the full-height gable glazing
and up into the triangular apex, the mezzanine gallery lit from within,
the recessed terrace washed by concealed linear uplighters. The frosted
sphere lights glowing down in the grasses. Reflections doubling the whole
gable in the still pool. The house reads as a lantern on the ridge.
```

## Végrehajtás

- `generate_image_batch`, a 01–11 **egy batchben**
- Utána mutasd meg mind a 11-et **egy összefűzött kontaktlapon**
- Ellenőrizd, sorban:
  - **Elmozdult a kamera bárhol?** → újragenerálás
  - **Változott a háttér gerincvonala?** → újragenerálás
  - **A 04–07 fázisban a váz tényleg acélnak néz ki?** Ha fás, sárgás, gyalult deszkás → újragenerálás
  - **A 07-es tényleg meredek nyeregtetős acél rácsostartót mutat, ereszkinyúlás nélkül?** Ez a szekvencia csúcspontja; ha lapos vagy fedett, újragenerálás
  - **A 09-esen látszik, hogy a klinker lapburkolat lécvázon?** Ha tömör falazatnak olvasódik, az egész acél-történet megbukik → újragenerálás
- Mentés: `assets/build/stage-01.png` … `stage-11.png`

---

# 6. FÁZIS 4 — AZ ÉPÍTÉSI VIDEÓ

10 átmenet: 01→02 … 10→11.

A klipek **nem** absztrakt morfolások. Látszania kell, hogy **gépek dolgoznak és emberek szerelik a házat.** Ez a szekvenció érzelmi tartalma: nem magától épül fel, hanem megépítik.

### Ha van first/last frame interpoláció (preferált)
`start_image = stage-N.png`, `end_image = stage-N+1.png`, `seedance1_5`, 4 mp, 1080p, néma.

### Közös klip-fej — minden átmenetbe szó szerint

```
Locked-off tripod shot, camera absolutely static, zero pan, zero zoom,
zero parallax. A construction time-lapse compressing several days into a
few seconds. The structure genuinely transforms between the two frames.

THE CREW IS VISIBLE AND LEGIBLE. Workers in orange and yellow hi-vis
vests and white hard hats move about the site with the smeared,
trailing motion blur of time-lapse — you can always tell what each
person is doing, but never see a face. Plant and machinery move with
the same blur. This is a busy, working site, not an empty one.

Cloud shadows drift across the ridgelines. Smooth, continuous, no cuts,
no camera shake. The background terrain, ridgelines and treeline must
remain perfectly still — no morphing, no drifting, no warping on the
landscape.
```

### Fázisonkénti koreográfia — mi történik a klipben

| Klip | Aki dolgozik és amivel |
|---|---|
| **01→02** | Két lánctalpas markoló vágja ki a munkagödröt, dömper fordul, földkupac nő. Geodéta állványos műszerrel. |
| **02→03** | Zsaluzó brigád rakja a táblákat, betonszivattyú karja leng ki, mixerkocsi ürít, majd simítógép köröz a friss betonon. |
| **03→04** | Acélszerelők csavarozzák a C-szelvényeket, kis teleszkópos rakodó adogatja a kötegeket. A falak sorra állnak fel. |
| **04→05** | Autódaru emeli be a födémgerenda-kötegeket, szerelők fogadják és rögzítik, majd terítik a födémlemezt. |
| **05→06** | Daru emeli a gerincgerendát és az első rácsostartókat, szerelők vezetik be a helyükre. Állványzat nő. |
| **06→07** | Rácsostartók sorban repülnek be, tetőn dolgozó szerelők rögzítik a szelemeneket. Az ezüst bordázat kirajzolódik. |
| **07→08** | Tetőfedők terítik a korcolt lemezt, membránozó brigád húzza a fóliát, ablakosok emelik be az üvegeket. |
| **08→09** | Állványon burkolók ragasztják a klinkerlapokat, raklapokat mozgat a rakodó, fóliát húznak le az üvegekről. |
| **09→10** | Állványbontás, kis forgókotró mélyíti a medencét, kertépítők ültetnek, kavicsterítés. A hely kertté válik. |
| **10→11** | **Nincsenek emberek.** Csak a fény: sorra gyulladnak a belső lámpák, a köd leszáll a völgybe, az ég indigóba fordul. |

### ⚠ Miért nem kockázatos itt az ember

Az emberalak a leggyakoribb AI-artefakt forrás — kéz, arc, végtag. **A mi CAMERA LOCK-unk ezt kivédi:** 55 méter távolságból egy ember a képmagasság kb. 3%-a, nagyjából 30 pixel. Nincs arc, amit el lehetne rontani. A hi-vis mellény és a fehér sisak viszont ezen a méreten is azonnal olvasható, és épp azt közli, amit kell: *itt szakemberek dolgoznak.*

Ezért a **hi-vis kötelező elem**, nem díszítés — ez teszi a 30 pixeles alakot értelmezhetővé.

### Az állóképek maradnak ember nélkül

A 11 stage-kép továbbra is `no people`. Ezek a klipek **kulcskockái**: a munka a kockák *között* zajlik. Így a scroll-scrub közben a néző hol üres, tiszta építési állapotot lát, hol nyüzsgő munkát — pont az a ritmus, amitől él a dolog.

### Ha nincs interpoláció
`generate_video` image-to-video-val fázisonként, ugyanezzel a prompttal, majd ffmpeg keresztúsztatás. Gyengébb, de működik.

### Végrehajtás
- `generate_video_batch`, `jobs_wait`
- **Nézd meg mind a 10-et.** Ami „úszik" a háttérben, azt újragenerálod.
- Mentés: `assets/build/clip-01-02.mp4` …

---

# 7. FÁZIS 5 — A 8 BELSŐ TÉR

Minden tér **egy menüpont**. Mindegyikhez: 1 hero állókép + 1 loop-olható klip.

| # | Menüpont (HU) | Eyebrow (EN) | Tér |
|---|---|---|---|
| 01 | Előtér | THRESHOLD | belépés az alacsony szárnyból, bazalt padló, beépített tölgy szekrénysor |
| 02 | Nappali | THE GREAT ROOM | teljes belmagasságú nagytér a nyeregtető alatt, kandalló, oromfal-üveg a hegyekre |
| 03 | Konyha és étkező | HEARTH & TABLE | monolit sziget, sötét tölgy front, rejtett világítás, gömblámpák |
| 04 | Lépcső és galéria | THE RISE | lebegő tölgyfokok, feketített acél tartó, galéria a nagytér fölött |
| 05 | Hálószoba | UPPER CALM | galériaszinti háló a tetősík alatt, textil falburkolat |
| 06 | Fürdőszoba | STONE BATH | szabadon álló kád, meleg terrazzo és mikrocement, lineáris felülvilágító |
| 07 | Dolgozó | THE QUIET ROOM | az alacsony szárnyban, könyvtárfal, mélyen ülő sarokablak az erdőre |
| 08 | Terasz | THE OUTER ROOM | süllyesztett fedett terasz az oromfal alatt, tűzhely, tükröződő vízfelület |

## Közös prompt-fej

```
Photoreal interior architectural photography, inside the house from
reference gerinc-master — a single-and-a-half storey modern barn with a
steep gable and an oak mezzanine gallery. Consistent material palette
throughout: white-oiled oak floors, dark oiled oak joinery, warm
terrazzo, micro-cement walls in warm grey, blackened steel details,
linen textiles, white plaster walls carrying up into the gable. Where
structure is expressed, it is slim blackened steel — never timber posts.
Warm 2700K concealed lighting plus strong natural daylight from
full-height glazing. Autumn beech forest and layered misty mountain
ridgelines visible outside every window.

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

### ⚠ Klipenként vágunk, nem az összefűzött fájlból

Az összefűzött `sequence.mp4`-ből vágni hibás: a kerekítési csúszás
klipenként halmozódik, és a fázis-horgonyok elcsúsznak. Klipenként vágunk,
pontosan 18 kockát, `-start_number`-rel egy globális sorszámozásba.

Minden klip 4 mp @ `fps=4.5` → **18 kocka**. Az utolsó klip 19-et kap, hogy a
szekvencia pontosan a stage-11 kockáján érjen véget (18 kocka a t=0…3,778 mp
tartományt fedi, a 19. van t=4,0-n).

```bash
mkdir -p public/seq public/seq-sm

# --- desktop, 1920px ---
i=0
for n in 01 02 03 04 05 06 07 08 09 10; do
  next=$(printf "%02d" $((10#$n + 1)))
  frames=18; [ "$n" = "10" ] && frames=19
  ffmpeg -i "assets/build/clip-$n-$next.mp4" \
    -vf "fps=4.5,scale=1920:-2" -fps_mode passthrough -frames:v $frames \
    -q:v 2 -start_number $i "public/seq/frame_%04d.jpg"
  i=$((i + frames))
done

# --- mobil, 960px ---
i=0
for n in 01 02 03 04 05 06 07 08 09 10; do
  next=$(printf "%02d" $((10#$n + 1)))
  frames=18; [ "$n" = "10" ] && frames=19
  ffmpeg -i "assets/build/clip-$n-$next.mp4" \
    -vf "fps=4.5,scale=960:-2" -fps_mode passthrough -frames:v $frames \
    -q:v 3 -start_number $i "public/seq-sm/frame_%04d.jpg"
  i=$((i + frames))
done

for f in public/seq/frame_*.jpg; do
  avifenc --min 24 --max 34 --speed 4 "$f" "${f%.jpg}.avif"
done
rm public/seq/*.jpg

for f in public/seq-sm/frame_*.jpg; do
  avifenc --min 28 --max 38 --speed 4 "$f" "${f%.jpg}.avif"
done
rm public/seq-sm/*.jpg
```

Eredmény: `frame_0000` … `frame_0180`, összesen **181 kocka**.

### Fázis-horgonyok — HARDKÓDOLD

A `stage-N` a `(N-1) * 18` indexű kockán van. Ezt az overlay-szinkron
**konstansként** használja, nem futásidőben számolja:

```js
// A 11 építési fázis kockaindexe. Determinisztikus, a 8a export garantálja.
const STAGE_FRAMES = [0, 18, 36, 54, 72, 90, 108, 126, 144, 162, 180];
const TOTAL_FRAMES = 181;
```

**Célszám:** 181 kocka × ~50 KB ≈ 9 MB desktop, ~3 MB mobil. 12 MB fölött
csökkentsd `fps=3`-ra (12 kocka/klip, 121 kocka össz) — a horgonyosztó ekkor
12, nem 18. Ne a kockaszámot vágd le utólag, mert a horgonyok elcsúsznak.

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