# FÁZIS 1 — Felmérés

Dátum: 2026-08-07 · Higgsfield MCP · workspace: alapértelmezett

## 1. Kredit

| | |
|---|---|
| Egyenleg | **1210 kredit** |
| Csomag | `plus` |
| Tranzakciók | egyetlen tétel: +1200 „Subscription Credits", 2026-08-07 |
| Unlim (ingyenes trial-generálás) | `available: false` — nincs, minden generálás kreditből megy |

Nincs korábbi költés, tehát a historikus adatból nem lehet árat visszafejteni.
Helyette a `generate_image` / `generate_video` **`get_cost: true`** preflightját
használtam: ez pontos árat ad **kreditköltés nélkül**. Az alábbi árak mind
mértek, nem becsültek.

## 2. Mért egységárak

### Kép

| Modell | Beállítás | Kredit |
|---|---|---|
| `seedream_v4_5` | 16:9, basic (4K-ig) | **1** |
| `nano_banana_2` | 16:9, 2k | 2 |
| `nano_banana_pro` | 16:9, 2k | 2 |
| `nano_banana_pro` | 16:9, **4k** | **4** |
| `gpt_image_2` | 16:9, 2k, high | 7 |
| `bytedance_image_upscale` | 4k | 2 |

### Videó

| Modell | Beállítás | Kredit | start+end? |
|---|---|---|---|
| `veo3_1_lite` | 4 mp, néma | **4** | ✅ |
| `seedance1_5` | 4 mp, 720p, néma | **4.8** | ✅ |
| `kling2_6` | 5 mp, néma | 5 | ❌ csak start |
| `kling3_0` | 5 mp, std, néma | 7.5 | ✅ |
| `kling2_6` | 10 mp, néma | 10 | ❌ csak start |
| `minimax_hailuo` | 6 mp, 1080 | 10 | ✅ |
| `seedance_2_0_mini` | 4 mp, 720p, néma | 10 | ✅ |
| `seedance1_5` | 4 mp, **1080p**, néma | 12 | ✅ |
| `seedance1_5` | 8 mp, 1080p, néma | 24 | ✅ |
| `seedance_2_0` | 4 mp, 1080p, std, néma | 36 | ✅ |

## 3. First-frame + last-frame interpoláció — VAN

A BRIEF 6. fejezetének preferált útja járható. Ezek a modellek deklarálnak
`start_image` **és** `end_image` szerepet is:

`seedance1_5` · `seedance_2_0` · `seedance_2_0_mini` · `veo3_1_lite` ·
`kling3_0` · `minimax_hailuo` · `minimax_h3` · `wan2_7` · `flux_3_video` ·
`cinematic_studio_3_0`

Nem kell az ffmpeg-keresztúsztatásos B-terv.

## 4. Presetek — NEM használjuk

A `presets_show` 60+ presetet ad vissza (EARTH ZOOM, ORBIT 360, ZOMBIE DANCE,
RED CARPET, FLOAT SPIN…). Kivétel nélkül **karakter/szelfi alapú virális
sablonok**. Építészeti fix kamerához egy sem alkalmas, és többségük *aktívan
kameramozgást kényszerít* — pont azt, amit a CAMERA LOCK tilt.

Verdikt: nincs `higgsfield_preset` modell a projektben, nincs `preset_id`.

## 5. Elements — üres

`show_reference_elements` → `items: []`. A workspace-en nincs referencia-elem.
A `gerinc-master` a FÁZIS 2 után jön létre, a nyertes kép `image_job` UUID-jából.

### ⚠ Katalógus-ellentmondás, ellenőrizendő

A `show_reference_elements` leírása az Elements-kompatibilis képmodelleket így
sorolja: `nano_banana_2` („Nano Banana Pro"), `nano_banana_flash`
(„Nano Banana 2"), `gpt_image_2`, `seedream_v4_5`, `seedream_v5_lite`,
`cinematic_studio_2_5`.

A `models_explore` viszont ezt mondja: `nano_banana_pro` = „Nano Banana Pro",
`nano_banana_2` = „Nano Banana 2", és `nano_banana_flash` **nem is létezik**.

A két katalógus nem egyezik. Következmény: az Elements-kompatibilitást a
11-es batch előtt egyetlen 1 kredites hívással empirikusan ellenőrizzük.
Ha nem megy, a tartalék út a `medias[{role:'image'|'image_references',
value:<job_id>}]` közvetlen referencia — ezt minden szóba jövő modell
deklarálja.

## 6. Modellválasztás

### FÁZIS 2 — master-render → **bake-off**

A BRIEF 4 variánst kér. 2-2 megoszlásban két modell között:

| db | Modell | Beállítás | Kredit |
|---|---|---|---|
| 2 | `nano_banana_pro` | 16:9, 4k | 8 |
| 2 | `seedream_v4_5` | 16:9, basic | 2 |
| | | **összesen** | **10** |

**Miért ez a kettő:**

- `nano_banana_pro` — a katalógus „ultimate quality" fotoreál 4K modellje.
  A master-prompt ~200 szó, öt címkézett blokkal (FORM / LOCATION /
  CAMERA LOCK / LIGHT LOCK / negatívok). Itt a **prompt-adherencia az egész
  játék** — ha a modell elengedi a „camera height 6 metres, 40 metres from the
  building face, 4 degrees downward tilt" sort, az egész projekt fixpontja
  vész el.
- `seedream_v4_5` — „precise control, transformations", 4K, és rajta van az
  Elements-listán. Ha ez nyer, a 11 fázis konzisztencia-lánca natívvá válik,
  és 1 kredit/kép áron megy.

**Amit kizártam:** `gpt_image_2` (7 kredit, tipográfiára/szövegre hangolt, nem
építészetre) · `soul_2` / `soul_cinematic` / `soul_cast` (karakter- és
portrémodellek) · `cinematic_studio_2_5` (filmes színvilág — a brief viszont
kifejezetten „natural colour, no colour grading"-et kér, a modell szembemenne
vele) · `flux_2` (csak 1k/2k, nincs 4K).

### FÁZIS 3 — 11 építési fázis

**A nyertes master-modell**, `gerinc-master` referenciával. Ugyanaz a modell,
mint a masteré — ez nem opcionális: modellváltásnál a lencse-karakter, a
szemcse és a színkezelés elúszik, és pont a „nem mozdult a kamera" illúzió
törik el.

Mivel a kép 1–4 kredit, a **04–07 fázist (ahol az acélváz látszik) eleve
2-3 variánssal** generálom. Egy variáns olcsóbb, mint egy újragenerálási kör,
és pont ez az a négy kocka, ahol a favázas hiba előjöhet.

### FÁZIS 4 — 10 építési átmenet

**Elsődleges: `seedance1_5` (Seedance 1.5 Pro), 4 mp, 720p, `generate_audio: false`**
→ 4.8 × 10 = **48 kredit**

Miért:
- deklarál `start_image`-et **és** `end_image`-et → valódi interpoláció
- tag-jei: „reliable, motion, quality" — fix kameránál a feladat a
  **visszafogottság**, nem a kreativitás
- duration 4/8/12 → a 4 mp illeszkedik a brief 3–4 mp-éhez
- hang kikapcsolva: a klipek úgyis kockákra esnek szét, a hang kidobott kredit

720p és nem 1080p, mert a klipek végül AVIF-kockákká darabolódnak. Ha a
kockák 1920px-en lágynak bizonyulnak, két út van: újrafuttatás 1080p-n
(12 kr/klip, +72) vagy `bytedance_video_upscale`. Olcsón kezdeni a helyes
sorrend, amikor bármi újragenerálandó lehet.

**Kontroll a batchben:** 2 átmenetet `veo3_1_lite`-tal is legenerálok
(4 kr/klip, +8 kredit). Ez a legolcsóbb start+end modell, kifejezetten
„budget batch clips" — 8 kreditért megtudjuk, melyik tartja stabilabban a
hátteret. Ez a projekt egyetlen valódi kockázata (a „úszó" háttér).

**Kizárva:** `seedance_2_0` (36 kredit — 7.5× ár olyan
referencia-identitás funkciókért, amiket nem használunk: nálunk az identitást
már a két kulcskocka rögzíti) · `kling3_0` (7.5 kr, jó modell, de multi-shot
és audio köré épül — a multi-shot pont az ellenkezője a kívántnak) ·
`minimax_hailuo` (min. 6 mp, drágább és hosszabb a kelleténél).

### FÁZIS 5 — 8 belső tér

**Kép:** a nyertes master-modell, közös prompt-fej + `gerinc-master`
anyagpaletta-referencia. 8 × 1–4 = 8–32 kredit.

**Videó — javaslat: `seedance1_5`, 8 mp, 1080p, néma,
`start_image` = `end_image` = a tér hero képe** → 24 × 8 = **192 kredit**

Az azonos start- és végkocka miatt a klip **ugyanazon a képkockán kezdődik és
végződik → tökéletes loop, keresztúsztatás nélkül.** Pont ez kell a
`loop` + IntersectionObserver hátterekhez, és a brief „seamlessly loopable"
kérését szó szerint teljesíti. A mozgás így nem egyirányú bedolly, hanem egy
lassú „belélegzés és vissza".

**Ez eltérés a brief szó szerinti „dolly-in" megfogalmazásától — ezért kérem rá
külön a jóváhagyásodat.** Ha egyirányú bedollyt akarsz, a klip vége nem
egyezik az elejével, és a loop-hoz ffmpeg-keresztúsztatás kell.

Itt 1080p, nem 720p — ellentétben az építési klipekkel. Ezeket ugyanis
**közvetlenül nézi a látogató** teljes képernyőn, 1600px-en; nem darabolódnak
kockákra. A minőség itt látszik.

**Olcsóbb alternatíva:** `kling2_6`, 10 mp, néma = 10 kr × 8 = 80 kredit.
„Cinematic motion, advanced physics", hosszabb klip feleannyiért — de **csak
`start_image`-et deklarál**, nincs end_image, tehát nincs seamless loop trükk,
kell az ffmpeg-crossfade.

### FÁZIS 8 — 6 épülettípus + OG-kép

A nyertes master-modell, `gerinc-master` anyagpaletta-referenciával
(antracit + horganyzott acél + fa). 7 × 1–4 = 7–28 kredit.

### Upscale

`bytedance_image_upscale` 4k = 2 kredit/kép. A masterre és ~6 kulcsképre: 14.
Az építési klipeknél az upscale valószínűleg elhagyható (lásd FÁZIS 4).

## 7. Kredit-becslés az egész projektre

| Tétel | db | egység | kredit |
|---|---|---|---|
| F2 master bake-off | 4 | 4 / 1 | 10 |
| F3 11 fázis, a 04–07 duplán-triplán | ~15 | 1–4 | 15–60 |
| F3 újragenerálási tartalék (acél/kamera) | ~6 | 1–4 | 6–24 |
| F4 10 átmenet, Seedance 720p | 10 | 4.8 | 48 |
| F4 Veo kontroll 2 klip | 2 | 4 | 8 |
| F4 újragenerálási tartalék (~40%) | 4 | 4.8 | 19 |
| F5 8 tér hero kép | 8 | 1–4 | 8–32 |
| F5 8 tér klip, 8 mp 1080p | 8 | 24 | 192 |
| F5 klip újragenerálás (~25%) | 2 | 24 | 48 |
| F8 6 épülettípus + OG | 7 | 1–4 | 7–28 |
| Upscale (master + kulcsképek) | 7 | 2 | 14 |
| **Összesen** | | | **375–483** |

**Egyenleg 1210 → a projekt a keret ~31–40%-a. Marad ~730–835 kredit.**

Még a drága ág is (építési klipek 1080p-n +72, szobaklipek `seedance_2_0`-val)
bőven belefér. **A projekt nem kredit-korlátos.** A szűk keresztmetszet az
iterációs fegyelem, nem a pénz — a legdrágább tétel a 8 szobaklip (192), és
ezekből minden felesleges kör 24 kreditbe kerül.

## 8. Blokkolók a későbbi fázisokhoz

| Mi | Állapot | Melyik fázist blokkolja |
|---|---|---|
| `ffmpeg` | **NINCS telepítve** | FÁZIS 6–7 |
| `avifenc` (libavif) | **NINCS telepítve** | FÁZIS 6–7 |
| `git` 2.55.0 | ✅ | — |
| `node` v24.18.0 | ✅ | FÁZIS 8 |
| `gh` CLI | nincs — nem is kell, a HTTPS push működik | — |

A git identitás repo-lokálisan beállítva: `broist` /
`mailforistvanbiro@gmail.com` (globálisan nem volt beállítva, enélkül a
commit elszállt).

## 9. Hiba a BRIEF ffmpeg-lépésében (8a) — később javítandó

10 klip × 4 mp = **40 mp** összefűzött szekvencia. A briefben szereplő
`-vf "fps=30,scale=1920:-2"` ebből **1200 kockát** vág ki, nem 180-at.
1200 × ~50 KB ≈ **60 MB** desktop + ~20 MB mobil — hatszoros túllépés a
brief saját 9 MB / 3 MB célszámához képest, és a repo-méret irányelvét is
szétfeszíti.

Javítás: `fps=4.5` (40 mp → 180 kocka). Alternatíva: hosszabb klipek és
arányosan alacsonyabb fps. A generálást nem érinti, FÁZIS 6-ban kezeljük.
