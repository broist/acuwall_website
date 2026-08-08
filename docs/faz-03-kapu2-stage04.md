# KAPU 2 — stage-04 validáció

Generálva: 2026-08-08 · **12 kredit** (1184 → 1172) · 3 variáns, `nano_banana_pro` 4k
`gerinc-master` element: `6692bfeb-0c78-407d-9402-e20aabb17f6a` (a V2-ből)

| # | job_id | Fájl |
|---|---|---|
| a | `67cff915-b2ab-43ae-a26c-3d97f1334dd1` | `assets/build/stage-04-candidates/S04-a.png` |
| b | `6cd77be7-ac90-4d90-8ac7-6cc744206c21` | `assets/build/stage-04-candidates/S04-b.png` |
| c | `644f537c-1829-4717-a8b7-b6f39b75f3e5` | `assets/build/stage-04-candidates/S04-c.png` |

## ✅ A LEGFONTOSABB TESZT ÁTMENT: ez acél

Mind a három variánson **egyértelműen horganyzott acél**, nulla favázas
kockázat:

- fényes cink/ezüst felület, nem sárgás fa
- C-szelvények látható peremmel
- **átlyukasztott szerelőnyílások a gerinclemezekben** — ez a legárulkodóbb
  acél-jegy, és mind a háromon ott van
- csavarozott csomópontok, keresztmerevítő szalagok
- címkézett acélprofil-kötegek raklapon

Sehol egy szál fenyő stud, OSB vagy ragasztott fa gerenda. A BRIEF
legfontosabb szabálya teljesül, és látványosabban, mint reméltem.

## ✅ Az Elements-referencia működik

A terep folytonossága a masterrel kiváló: ugyanaz a rétegzett ködös
hegyvonulat, ugyanaz a bükk balra, ugyanazok a fenyők jobbra, ugyanaz a
bazalt kibúvás jobb alul, ugyanaz a kavicsút-vezetés és lépőkő-ritmus.
A horizont 47–48% (master: 47%). A `<<<element_id>>>` placeholder
gond nélkül ment át a `nano_banana_pro`-n.

## ❌ DE: egyik sem érvényes stage-04

A 04 a **földszinti** váz. A tető a 07-ben jön, a galéria az 05-ben, az
oromfal a 06-ban.

| | Amit mutat | Valójában melyik fázis |
|---|---|---|
| **a** | teljes tetőszerkezet szaruzattal és szelemenekkel | ~**07** |
| **b** | két oromfal-váz + födémgerendák, tető nélkül | ~**05–06** között |
| **c** | teljes tetőszerkezet | ~**07** |

Egyik sem földszinti falváz. A modell a „steel frame erected"-et egészben
értelmezte, és a referenciakép teljes tömege felé húzott.

**A kapu pontosan ezt a célt szolgálta.** 12 kredit derítette ki, nem 44.

## ❌ És: kész kert egy építkezésen

Mind a három képen a **tükröződő medence tele van, a díszfüvek beállva, a
kavicsút és a lépőkövek lerakva, a gömblámpák a helyükön** — egy kész kert,
benne egy csupasz acélváz.

Az ok nem hiba, hanem a szabály következménye: a `LOCATION` blokkot szó
szerint másoljuk minden építési promptba, és abban benne van, hogy
*„A still dark reflecting pool with a basalt slab edge lies in front of the
gable, mirroring the roofline"* meg a beállt növényzet. A modell ezt
teljesíti — helyesen.

## A javaslat: SITE STATE blokk, a LOCATION érintése nélkül

A `CAMERA LOCK` / `LIGHT LOCK` / `LOCATION` **változatlan marad**. A
`STAGE CONTENT` a prompt kifejezetten fázisonként változó része, oda
kerül két új alblokk. Ez a 01–09 fázisra közös, a 10–11-nél elmarad:

```
CRITICAL — WHAT DOES NOT EXIST YET IN THIS FRAME:
No roof structure whatsoever. No trusses, no rafters, no purlins, no
ridge beam. No gable triangle. No mezzanine and no upper floor joists.
Nothing above the top track of the ground floor walls — open sky across
the entire footprint. The wall frames stop at a single flat horizontal
line roughly 3 metres above the slab.

SITE STATE — an active building site, not a finished garden:
The reflecting pool is an empty unlined excavation with raw earth sides.
No planting established, no ornamental grasses, no sphere lights, no
raked gravel and no stepping stones yet — only bare churned earth,
compacted site tracks and stacked materials where the landscape will
later go.
```

A „WHAT DOES NOT EXIST YET" rész fázisonként változik (a 05-nél a tető még
nincs, a galéria már igen, stb.). A „SITE STATE" a 01–09-en végig azonos,
és a 09-nél enyhül (kavics részben lerakva).

## Melléktermék: valószínűleg megvan a stage-07

Az **a** és a **c** variáns pontosan az, amit a 07-hez leírtunk: meredek
acél rácsostartók ezüst bordázata, szelemenekkel, ereszkinyúlás nélkül, a
ködös őszi hegyek előtt. A 12 kredit nem veszett el.

Viszont **nem tartjuk meg őket** véglegesnek: rajtuk is a kész kert van.
Ha a 11-ből kettőn kész kert van, kilencen meg építkezés, az rosszabb,
mint bármelyik következetes változat. A 07 újramegy a javított prompttal.

## Döntés

**Ne menjen a maradék 10.** Előbb javított stage-04, 2 variáns (8 kredit).
Ha az földszinti falvázat mutat nyers építési területen, akkor mehet a
teljes batch.
