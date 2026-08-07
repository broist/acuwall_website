# KAPU 0 — Master bake-off, eredmény

Generálva: 2026-08-07 · **10 kredit** (egyenleg 1210 → 1200, pontosan a jóváhagyott összeg)

A prompt szó szerint a BRIEF 4. fejezetéből, a `LOCATION (alpine alternative)`
blokk kihagyva. A CAMERA LOCK, LIGHT LOCK és LOCATION blokkok byte-azonosan
mennek majd tovább a 11 építési promptba.

| # | Modell | job_id | Felbontás | Fájl |
|---|---|---|---|---|
| A1 | `nano_banana_pro` 4k | `1d218ad7-4d38-48f5-b7ff-e0e19cb3b9f9` | 5504×3072 | `assets/master/bakeoff/A1-nanobananapro.png` |
| A2 | `nano_banana_pro` 4k | `4b7bb95e-1ba8-4ce7-8a8c-6d210ec5868b` | 5504×3072 | `assets/master/bakeoff/A2-nanobananapro.png` |
| B1 | `seedream_v4_5` basic | `f689ae1b-254b-499b-88c4-867c88be468f` | 2560×1440 | `assets/master/bakeoff/B1-seedream45.png` |
| B2 | `seedream_v4_5` basic | `4467cbde-b2f4-41b8-8184-f9064614d1b2` | 2560×1440 | `assets/master/bakeoff/B2-seedream45.png` |

## ✅ Megoldódott: a katalógus-ellentmondás

A FÁZIS 1-ben jelzett `nano_banana_pro` / `nano_banana_2` névütközés eldőlt:
a `nano_banana_pro`-val küldött kérésre a szerver `"model":"nano_banana_2"`-t
adott vissza. A backend tehát a `show_reference_elements` névterét használja,
ahol `nano_banana_2` = „Nano Banana Pro".

**Következmény: a nyertes modell rajta van az Elements-listán.** A
`gerinc-master` element natívan használható lesz `<<<element_id>>>`
placeholderrel, nem kell a közvetlen `medias` tartalék út.

## Bírálat a CAMERA LOCK ellen

| Kritérium | A1 | A2 | B1 | B2 |
|---|---|---|---|---|
| Kameramagasság 6 m, 4° letekintés | ✅ | ✅ | ❌ szemmagasság | ❌ alulnézet |
| Horizont a képmagasság 45%-án | ✅ ~46% | ~50% | ❌ ~67% | ❌ ~68% |
| Épület a kép központi 60%-án | ✅ ~62% | ~54% | ~57% | ❌ vágott |
| Háromnegyedes nézet balról elöl | ✅ | ✅ | ✅ | ✅ |
| Nap balról (LIGHT LOCK) | ✅ | ✅ | ⚠ fátyol/flare | ❌ jobbról |
| „no haze" | ✅ | ✅ | ❌ | ❌ |
| Bazalt lábazat | ✅ | ✅ | ✅ | ✅ |
| Függőleges égetett vörösfenyő | ⚠ világos | ✅ | ✅ | ✅ |
| Antracit korcolt lemezfedés | ✅ | ✅ | ✅ | ✅ |
| Konzolos terasz, keret nélküli üvegkorlát | ✅ | ✅ | ✅ | ✅ |
| Artefakt-mentes | ✅ | ✅ | ⚠ ismétlődő textúra | ❌ lebegő elem balra |

**A Seedream mindkét variánsa elbukik ugyanazon: földszintről néz felfelé.**
Ez a legsúlyosabb hiba, mert a kameraállás az egyetlen dolog, amit mind a 11
fázis örököl. Ehhez jön a fele felbontás (2560×1440 vs 5504×3072).

**Verdikt: A ág (`nano_banana_pro`) nyer, azon belül A1 az ajánlott.**

## ⚠ Amiben mind a négy eltér a brieftől: a tetőforma

A BRIEF „crisp rectilinear volumes" + „thin 900mm cantilevered overhang"-et ír
elő. Amit kaptunk:

- **A1** — kontyolt tető, széles ereszkinyúlás (jóval 900 mm fölött)
- **A2** — nyeregtető, csűr-karakter
- **B1** — kontyolt, széles eresz
- **B2** — lapos, hosszú doboz (formailag ez a legközelebbi, de a kameraállása használhatatlan)

Egyik sem a lapos tetős, vékony eresszel záródó kubus. A modell az
„alpine-modern" jelzőt erősebben súlyozta, mint a „rectilinear"-t.

Döntési lehetőség: 2 további `nano_banana_pro` variáns élesített FORM
blokkal (`flat roof, no pitch, no gable, no hip, parapet edge`), 8 kredit.
Ez a master, minden ehhez igazodik — a 8 kredit elhanyagolható a
következményekhez képest. **Jóváhagyás nélkül nem indul.**

## KAPU 0b — mobil-ellenőrzés lefutott

```
forras 5504x3072 (1.792)  ·  viewport 380x800 (0.475)
cover  ->  lathato sav 26.5%  ->  kivagas 1459x3072 @ x=2022
```

A kivágott kép **falrészletet mutat, nem házat**: nincs tetőgerinc-sziluett,
nincs gerincvonal a háttérben, nincs kontextus. A FÁZIS 1-ben számolt 26,7%
gyakorlatban is pontosan ezt adja.

A jóváhagyott megoldás (keskeny viewporton szélességre illesztés cover
helyett) ezzel igazolva. **A CAMERA LOCK változatlan marad.**
