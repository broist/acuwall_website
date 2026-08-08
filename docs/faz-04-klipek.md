# FÁZIS 4 — A 10 építési klip

Generálva: 2026-08-08 · **60 kredit** (1096 → 1036)
Modell: `seedance1_5`, 4 mp, **1080p**, `generate_audio: false`, first/last frame interpoláció

Előtte, ugyanebben a körben: 01/02/03 újragenerálása háttér-zárolással (**12 kredit**,
1108 → 1096). A kör összesen **72 kredit**.

## ⚠ Ár-korrekció: 6 kredit/klip, nem 12

120 kreditet mondtam a tíz klipre, a valóság **60** lett — klipenként **6**,
nem 12. A FÁZIS 1 ártáblázatában a `seedance1_5` 1080p sora **következtetett
volt, nem preflighttal mért**: a 720p-t mértem (4,8), és abból skáláztam
felfelé. A mért egyenlegváltozás (1096 → 1036) egyértelmű.

**Következmény a tervre:** a 8 szobaklip is olcsóbb lesz a becsültnél.
A FÁZIS 5 előtt minden tétel `get_cost`-tal preflightolandó, `count`-tal
szorozva.

## A kulcskockák feltöltése

A klipek **nem** a nyers generált képekből készültek, hanem az
`assets/build/aligned/` alatti, **él-igazított** változatokból — különben a
szélső fasor kockáról kockára ugrálna, és a videóban ez „úszó" háttérként
jelenne meg.

Az igazított kockák 1920×1080-ra exportálva, `media_upload` → PUT →
`media_confirm` úton kerültek fel. A 11 `media_id` a `start_image` /
`end_image` szerepekhez.

## A 10 klip

| Klip | job_id | Fájl |
|---|---|---|
| 01→02 | `e4df9b0b-863e-47a4-ae13-bf240c1d0b53` | `assets/build/clip-01-02.mp4` |
| 02→03 | `1e5bd59f-a0e2-4195-9ced-4c0175fd9b68` | `clip-02-03.mp4` |
| 03→04 | `c361c1bb-e614-49c1-9f67-10882fa19d92` | `clip-03-04.mp4` |
| 04→05 | `63da1c2a-c725-4672-84a3-4ef1f30b0515` | `clip-04-05.mp4` |
| 05→06 | `fec7841f-4391-401f-8371-1c4506d7e6da` | `clip-05-06.mp4` |
| 06→07 | `815b5a97-753b-43f8-bf16-fea3e31419a4` | `clip-06-07.mp4` |
| 07→08 | `d7fc6c97-d071-4213-ae7c-17e5ad654753` | `clip-07-08.mp4` |
| 08→09 | `e19a8a84-3e4d-4b27-a4e5-47583bbe5f76` | `clip-08-09.mp4` |
| 09→10 | `4a8dcb0a-b0ac-4e06-ae06-40cd8f20727c` | `clip-09-10.mp4` |
| 10→11 | `e16db60f-c9f4-484d-bbc6-030618a78014` | `clip-10-11.mp4` |

Mind 1920×1080, 97 kocka, 4,04 mp, ~11–12 MB.

## Két elakadás a beküldésnél

**Rate limit.** A 10-es batchből 8 ment át, kettő `429 rate_limit_reached`-et
kapott. A futó jobok foglalják a párhuzamossági keretet — a maradék kettőt
egyesével kellett beküldeni, ahogy felszabadult a hely.

**Preset-ajánlás generálás helyett.** A 10→11 klip (alkonyat) beküldése
`submission_failed`-del tért vissza:
`Preset "IN THE DARK" was recommended instead of submitting a job.`
A háttérrendszer a sötét/kékórás promptra egy karakteres horror-presetet
ajánlott. A `declined_preset_id` paraméterrel kellett visszautasítani, plusz
a prompt átfogalmazva („architectural shot of a completed house at the end of
the day"), hogy ne triggerelje újra.

## Bírálat

A klipek középkockáit megnézve mind a 10 hozza a koreográfiát:

- **01→02** markoló ás, elkenődött mozgással, nő a földkupac
- **02→03** betonszivattyú karja a munkagödör fölött, mixer, raklapok
- **03→04** narancs hi-vis mellényes acélszerelők állítják a falpaneleket
- **04→05** autódaru emel, szerelők fogadják a födémgerendákat
- **05→06** daru a gerincgerendával, szerelők a vázon
- **06→07** rácsostartók sorban, tetőn dolgozók
- **07→08** membránozók húzzák a fóliát, tetőfedők a lemezzel
- **08→09** rakodó, burkoló a tetőn, állványzat, klinker
- **09→10** állványbontás, kertépítés, mozgásban elkenődött alak
- **10→11** **nincsenek emberek** — csak a fény változik ✅

A hi-vis mellény a várt módon működik: 55 méterről is azonnal olvasható, hogy
szakemberek dolgoznak, arc viszont sehol nem látszik, tehát nincs miből
arc-artefakt.

## Kockakivágás — a BRIEF 8a végrehajtva

Klipenként 18 kocka `fps=4.5`-tel, `-start_number`-rel globális
sorszámozásba. Egy eltérés a tervtől: a **181. kockát külön kellett kivágni**.
Az fps szűrő a klip hosszából számol (4,0417 mp × 4,5 = 18,19 → 18 kocka),
ezért a `-frames:v 19` nem hozott 19-et. A `-sseof -0.1 -update 1`
megoldással a clip-10-11 utolsó kockája lett a `frame_0180`.

Eredmény: **181 kocka**, `frame_0000` … `frame_0180`, a `STAGE_FRAMES`
horgonyok érvényesek.

## AVIF avifenc nélkül

Az `avifenc` továbbra sincs telepítve, viszont az ffmpeg 9.0 `libaom-av1`
encodere still-picture módban ugyanezt tudja. Mérve, 1920px-es kockán:

| crf | KB/kocka | 181 kocka |
|---|---|---|
| 36 | 87 | 15,3 MB |
| 40 | 68 | 12,0 MB |
| **44** | **52** | **9,2 MB** ← ez tartja a BRIEF 9 MB-os célját |

Új eszköz: `tools/seq-to-avif.ps1`. Desktop crf 44, mobil crf 46.
A `libsvtav1` nem használható erre — 0 bájtos fájlt ad still-picture módban.

## Következő

- FÁZIS 5: 8 belső tér (8 kép + 8 klip)
- A prototípus frissítése a valódi mozgással
