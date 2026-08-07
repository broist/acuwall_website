# FÁZIS 2 — Jóváhagyott terv és kapuzott végrehajtás

Jóváhagyva: 2026-08-07. A bake-off 4 variáns, 10 kredit.

## Állapot: BLOKKOLVA

A Higgsfield MCP szerver lecsatlakozott a session-ből — a `generate_image`,
`generate_video`, `models_explore`, `balance` toolok nem elérhetők.
Generálás nem indítható, amíg a kapcsolat vissza nem áll.

Az újracsatlakozás után a lenti sorrend fut, változtatás nélkül.

## Végrehajtási kapuk

A jóváhagyás **kapuzott**: minden kapu után megállás és bírálat.

```
KAPU 0   bake-off, 4 variáns ................................ 10 kredit
         2x nano_banana_pro 4k + 2x seedream_v4_5
         -> te választod a nyertest
KAPU 0b  a nyertes master mobil-kivágása ..................... 0 kredit
         tools/mobile-crop.ps1, lokalis, azonnali
         -> CAMERA LOCK dontes, MIELOTT barmelyik stage keszul
KAPU 1   gerinc-master element letrehozasa .................. 0 kredit
         a nyertes image_job UUID-jabol
KAPU 2   CSAK stage-04 (THE STEEL RISES), 2-3 varians ....... 4-12 kredit
         -> fa/acel biralat. Ha bukik, a prompt javul, nem a
            maradek 10 kep generalodik le rossz vazzal.
KAPU 3   a maradek 10 stage ................................ 10-40 kredit
         benne stage-11 -> mobil-kivagas ujra, hero ellenorzes
KAPU 4   02 Nappali szobaklip, KET modon ................... 48 kredit
         start=end  vs.  sima dolly-in
         -> bizonyitek alapjan dol el a maradek 7
KAPU 5   10 epitesi atmenet, 1080p ......................... 120 kredit
KAPU 6   maradek 7 szobaklip ............................... 168 kredit
KAPU 7   6 epulettipus + OG ................................ 7-28 kredit
```

## A négy döntés

### 1. Kapuzott stage-04 validáció — elfogadva

A stage-04 a legnagyobb ugrás a mastertől (kész ház → csupasz váz), és ott a
legnagyobb a fa/acél tévesztés kockázata. 2-3 varianssal megy, mert egy
variáns 1-4 kredit, olcsóbb mint egy újragenerálási kör.

### 2. Szobaklipek: mérés, nem vita — elfogadva

Jogos az ellenvetés: azonos kezdő- és végkockánál a modell triviálisan
teljesítheti a feladatot azzal, hogy alig mozdul. 24 kreditért kaphatnánk egy
klipet, amin nem történik semmi.

A 02 Nappali mindkét módon lemegy (2 × 24 = 48 kredit):
- **A:** `start_image` = `end_image` = a tér hero képe
- **B:** csak `start_image`, egyirányú lassú bedolly

Bírálati szempont nem az esztétika, hanem: **van-e A-ban valódi elmozdulás.**
Ha A statikus, B nyer és jön az ffmpeg-keresztúsztatás a loophoz.

### 3. Építési klipek 1080p — elfogadva, a 720p javaslat visszavonva

Az érv helytálló és az enyém nem volt az. A 720p forrás 1280px széles, az
AVIF-kockákat 1920px-en exportáljuk → 1,5× felskálázás, lágy hero szekvencia.
És ami fontosabb: **a próbafutam nem csökkenti a kockázatot, megduplázza a
bírálást** — az 1080p-s újragenerálás új kockadobás, más mozgással és más
artefaktokkal, tehát az egészet újra kell bírálni.

`seedance1_5`, 4 mp, **1080p**, `generate_audio: false` → 12 kr × 10 = **120 kredit**.
Az 1920×1080 pontosan 1:1 a desktop exporttal és 2:1 a 960px mobilverzióval —
tiszta downsampling, nulla felskálázás.

A FÁZIS 1-ben javasolt 2 `veo3_1_lite` kontrollklip (8 kredit) opcionális
marad; szólj, ha kell.

### 4. Per-klip fps-vágás — elfogadva, a BRIEF 8a frissítve

Egy javítással: **az utolsó klip 19 kockát kap, nem 18-at.**

18 kocka @ 4.5 fps a t=0…3,778 mp tartományt fedi — a 18. kocka *nem* a
stage-N+1. Ez klipek között helyes, mert a következő klip 0. kockája **az**
a stage. De a sor végén a stage-11 sosem jelenne meg egzakt kockaként.
A clip-10-11-ből 19 kockát vágva a 19. pont t=4,0-n van → az a stage-11.

Így a `stage-N = (N-1)*18` horgony **mind a 11 fázisra** igaz, nem csak
1-10-re. Összesen 181 kocka, `frame_0000` … `frame_0180`.

## ⚠ Mobil: a CAMERA LOCK nem ment meg — számolva, nem feltételezve

A `tools/mobile-crop.ps1` megvan és tesztelve van. De a döntéshez nem kell
megvárni a képet, az arány már most kiadja:

```
viewport      380 x 800          aspect 0.475
forras        16:9               aspect 1.778
object-fit: cover  ->  lathato savszelesseg = 0.475 / 1.778 = 26.7%
```

A CAMERA LOCK szerint az épület a képszélesség **központi 60%-át** foglalja el.
Mobilon a központi **26,7%** látszik. Vagyis az épületnek a
`26,7 / 60 = 44,5%`-a látható — **több mint a fele levágódik.**

A „central 60% of frame" szabály tehát nem elég. És ezen semmilyen
kameraállás-módosítás nem segít érdemben: bármilyen fekvő forrás
cover-croppolva egy 0,475-ös portré viewportba elveszti a szélesség nagy
részét. 3:2-nél 31,7%, 4:3-nál 35,6% — mind kevés.

### Javaslat: ne a CAMERA LOCK változzon, hanem a mobil megjelenítés

A canvas rajzolókódja a miénk. A BRIEF 9. fejezetének 5. pontja
(„object-fit: cover logika kézzel a drawImage-ben") az, amit módosítunk:

- **Széles viewporton:** cover, ahogy eddig.
- **Keskeny viewporton (< ~700px):** szélességre illesztés (contain
  vízszintesen). A canvas nem 100vh magas, hanem a kép arányának megfelelő —
  az épület teljes egészében látszik, a maradék függőleges hely pedig a mono
  overlay szövegblokké lesz, aminek mobilon úgyis kell a hely.

Ez nulla extra generálást igényel, megtartja a CAMERA LOCK-ot változatlanul
(tehát a FÁZIS 1 óta érvényes minden prompt marad), és mobilon többet mutat
az épületből, nem kevesebbet.

**Alternatíva, ha külön mobil-hero kell:** a stage-11-ből egy dedikált 9:16
render, saját CAMERA LOCK-kal. Néhány kredit, de attól kezdve két
kamera-igazodási pont van, és a scroll-szekvenciára nem alkalmazható —
oda 181 külön portré kocka kellene.

Ettől függetlenül a kivágás mindkét ponton lefut és megnézed:
a nyertes masteren (KAPU 0b) és a stage-11-en (KAPU 3).

## Kredit-terv

| Kapu | kredit |
|---|---|
| 0 bake-off | 10 |
| 2 stage-04 validáció | 4–12 |
| 3 maradék 10 stage + tartalék | 16–64 |
| 4 Nappali A/B | 48 |
| 5 10 építési átmenet 1080p | 120 |
| 5 tartalék (~30%) | 36 |
| 6 maradék 7 szobaklip | 168 |
| 6 tartalék (~25%) | 48 |
| 3/5 8 szoba hero kép | 8–32 |
| 7 6 épülettípus + OG | 7–28 |
| upscale | 14 |
| **Összesen** | **~480–580** |

Egyenleg 1210 → **a keret ~40–48%-a.** Marad 630–730 kredit tartaléknak.
