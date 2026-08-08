# KAPU 0 (v2) — Master bake-off az új csűr-koncepcióra

Generálva: 2026-08-08 · **16 kredit** (egyenleg 1200 → 1184)
Modell: `nano_banana_pro` (a backend `nano_banana_2`-ként futtatja), 4k, 16:9, count 4

| # | job_id | Fájl |
|---|---|---|
| V1 | `90d00c29-c9f6-44cd-bb32-24a64822cde5` | `assets/master/bakeoff-v2/V1.png` |
| V2 | `8dd94175-04b2-4fb5-b6cb-2e08a15526f9` | `assets/master/bakeoff-v2/V2.png` |
| V3 | `7fa9ee4a-ef01-4f72-9063-e8d7aed1ea2c` | `assets/master/bakeoff-v2/V3.png` |
| V4 | `832ab940-3c6a-49e3-a899-d680712cec4a` | `assets/master/bakeoff-v2/V4.png` |

Mind 5504×3072.

## ⚠ Költség-korrekció: 16 kredit, nem 10

10-et mondtam, 16 lett. Nem áremelés — az én számolási hibám: a régi
bake-off 2× Nano Banana Pro (4 kr) + 2× Seedream (1 kr) = 10 volt, és ezt
vittem tovább akkor is, amikor mind a négy variáns a 4k-s modellre került.
4 × 4 = 16.

**Tanulság a `get_cost`-ról:** a preflight `count: 4` mellett is `credits: 4`-et
adott vissza — tehát **egységárat ad, nem batch-összeget.** A jövőben a
preflight értékét meg kell szorozni a `count`-tal. Ez a FÁZIS 1 becsléseit
nem érinti (azok darabáron számoltak), de a jövőbeli idézeteket igen.

A FÁZIS 1 ártáblázatában a `nano_banana_pro` és `seedream_v4_5` sorok
egyébként **következtetettek voltak, nem mértek** — a mért összeg
(2×NBP + 2×SD = 10 kr) utólag igazolta őket, de a dokumentum „mind mértek"
állítása ezekre pontatlan volt.

## Prompt-adherencia — mind a négyen teljesül

| Előírás | V1 | V2 | V3 | V4 |
|---|---|---|---|---|
| Meredek szimmetrikus nyeregtető | ✅ | ✅ | ✅ | ✅ |
| **Ereszkinyúlás nélkül, éles tetőél** | ✅ | ✅ | ✅ | ✅ |
| Korcolt lemez lefordul a hosszoldalra | ✅ | ✅ | ✅ | ✅ |
| Homokszínű klinker az oromfalon | ✅ | ✅ | ✅ | ✅ |
| Oromfal-üvegezés a csúcsig | ✅ | ✅ | ✅ | ✅ |
| Süllyesztett fedett terasz, tölgy béléssel | ✅ | ✅ | ✅ | ✅ |
| Hosszú alacsony szárny, mély négyzetablakok | ✅ | ✅ | ✅ | ⚠ árnyékba vész |
| Galéria látszik az üvegen át | ✅ | ✅ | ✅ | ⚠ |
| Tükröződő vízfelület | ✅ | ✅ | ✅ | ✅ |
| Díszfüvek, bazalt kibúvások, gömblámpák | ✅ | ✅ | ✅ | ✅ |
| Rétegzett hegyvonulatok ködben | ✅ | ✅ | ✅ | ✅ |
| Nap balról, árnyék jobbra | ✅ | ✅ | ✅ | ✅ |

A prompt lényegében hibátlanul ment át. Az „ereszkinyúlás nélkül" —
ami az előző körben a fő panasz volt — mind a négyen tökéletes.

## CAMERA LOCK-hűség — itt válnak szét

Előírás: kameramagasság 4 m, 1,5° letekintés, horizont az **52%**-on,
épület a központi **70%**-on.

| | V1 | V2 | V3 | V4 |
|---|---|---|---|---|
| Horizont | ~56% | ~47% | **~37%** ❌ | ~50% |
| Épület szélessége | ~64% | ~63% | ~67% | ~57% |
| Kameramagasság érzet | jó | magas | **túl magas** | jó, legalacsonyabb |

**V3 kiesik:** a kamera láthatóan 8-10 méterről néz le, a horizont a 37%-on
van. Szép kép, de a 11 fázis ezt a kameraállást örökölné.

## Verdikt: **V1 az ajánlott**

Nem azért, mert a legszebb — V4 drámaibb —, hanem mert **a 11 építési
fázisnak ez a legjobb alapja**:

1. **Mindkét tömeg olvasható és elkülönül.** A 01–03 fázisban a *nyomvonal*
   maga a téma, a 04–07-ben a váz. Ha a szárny árnyékba vész (V4), a
   szekvencia jobb oldala hat kockán át zavaros lesz.
2. **Legközelebb a CAMERA LOCK-hoz** magasságban és horizontban.
3. **A klinker „portál" az üvegezés körül** erős, karakteres építészeti
   gesztus, ami 11-szer újrarajzolva is megmarad.
4. **A sötét bőr és a klinker elválása a legtisztább** — ez a 08→09
   átmenetnél számít, ahol a membránból klinker lesz.

**Második: V4**, ha a hero drámája fontosabb a szekvencia olvashatóságánál.

## Megjegyzés a klinkerhez

Mind a négy képen a tégla **tömör falazatnak látszik** — ez így helyes és
várt: a kész lapburkolat pontosan úgy néz ki, mint a falazat, ez a lényege.
A becsületesség a **09-es fázisban** dől el, ahol a félig felrakott
klinker vágott élénél látszania kell a lécváznak. Ott fog eldőlni, nem itt.

## KAPU 0b — mobil

```
forras 5504x3072 (1.792) · viewport 380x800 (0.475)
cover -> lathato sav 26.5% -> kivagas 1459x3072 @ x=2022
```

Változatlanul igazolja a jóváhagyott döntést: keskeny viewporton
szélességre illesztünk, nem cover-elünk. A CAMERA LOCK marad.
