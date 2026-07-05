# EROS PARTY GAME — AKTUÁLNÍ ROADMAP

# ✅ PROJEKT

* [x] Flutter projekt vytvořen
* [x] GitHub repository
* [x] Git push funkční
* [x] Windows build
* [x] Android build
* [x] flutter analyze bez chyb

---

# ✅ LOKALIZACE (l10n)

* [x] Čeština
* [x] Angličtina
* [x] Přepínání jazyků
* [x] app_cs.arb
* [x] app_en.arb
* [x] flutter gen-l10n
* [x] Lokalizace Community Tasks
* [x] Lokalizace Community Scenarios

### Chybí

* [ ] Kompletní kontrola starších obrazovek

---

# ✅ PARTY HRA

* [x] Výběr hráčů
* [x] Pohlaví
* [x] Obtížnost
* [x] Consent screen
* [x] Herní engine
* [x] Svlékání oblečení
* [x] Poslední kus oblečení overlay
* [x] Rescue systém
* [x] Rescue hlasování
* [x] Lokální TaskBank
* [x] QR export
* [x] QR import

---

# ✅ FIREBASE

## Authentication

* [x] Anonymous login

## Firestore

* [x] Firestore databáze
* [x] Europe region
* [x] Rules nastaveny

---

# ✅ COMMUNITY TASKS

* [x] Upload
* [x] Download
* [x] Latest
* [x] Top
* [x] Like systém
* [x] Report
* [x] Import
* [x] Ochrana proti duplicitám
* [x] l10n

### Chybí

* [ ] Automatické skrytí nahlášených tasků
* [ ] Moderace

---

# ✅ COMMUNITY SCÉNÁŘE

* [x] Upload
* [x] Download
* [x] Latest
* [x] Top
* [x] Sdílení anonymně
* [x] Detail scénáře
* [x] Import scénáře
* [x] Like scénáře
* [x] Report scénáře
* [x] Ochrana proti duplicitám

### Chybí

* [ ] Oblíbené scénáře

---

# ✅ PARTNER PROPOJENÍ

* [x] Generování kódu
* [x] Vyhledání partnera podle kódu
* [x] Uložení partner UID
* [x] Propojení partnerů

---

# ✅ CLOUD PARTNER SCÉNÁŘE

* [x] Odesílání scénářů
* [x] Přijímání scénářů
* [x] Live synchronizace
* [x] Test PC ↔ Android
* [x] Test Android ↔ PC

---

# ✅ REAKCE

* [x] Odeslání reakce
* [x] Detail reakce
* [x] Splněno
* [x] Nesplněno
* [x] proofSent
* [x] proofAccepted
* [x] Povinná zpráva

---

# ✅ STAVY SCÉNÁŘŮ

* [x] 📥 received
* [x] ⏳ postponed
* [x] ✅ completed
* [x] ❌ rejected

---

# ✅ ZÁLOŽKY

* [x] 📥 Doručené
* [x] ⏳ Odložené
* [x] ✅ Splněné
* [x] ❌ Odmítnuté

---

# 🚧 AKTUÁLNĚ DĚLÁME

## 1. Stav scénáře v detailu

Zobrazovat:

📥 Doručeno

⏳ Odloženo

✅ Splněno

❌ Odmítnuto

---

## 2. Skrýt tlačítko "💬 Reagovat"

Pouze:

* received
* postponed

---

## 3. Počítadla u záložek

Například:

📥 Doručené (2)

⏳ Odložené (5)

✅ Splněné (12)

❌ Odmítnuté (1)

---

# 🔜 DALŠÍ VERZE

## Bohatší historie scénářů

Zobrazovat:

* datum
* stav
* reakci partnera
* důkaz odeslán
* důkaz přijat

---

## Znovu zvážit odmítnutý scénář

❌ Odmítnuté

↓

⏳ Odložené

---

# ❤️ BUDOUCNOST EROSU

## Zkusit scénář znovu

Po letech:

🔄 Chcete tento scénář zkusit znovu?

ANO / NE

ANO:

* vytvoří nový scénář
* odešle partnerovi
* celý proces začne znovu

---

## Historie opakování

Romantická večeře

2026 ✅

2028 ✅

2031 ❌

2034 ✅

---

## Hodnocení scénáře

😍 Předčilo očekávání

😊 Skvělé

😐 Průměrné

😕 Nic moc

❌ Už nikdy

---

## Kronika vztahu

2026 ❤️ začátek

2029 💍 svatba

2031 👶 dítě

2034 ❤️ 200 společných scénářů

---

# FILOZOFIE PROJEKTU

EROS není jen seznam úkolů.

EROS je digitální kronika vztahu a společných vzpomínek. ❤️

Tohle bych do roadmapy určitě přidal. A souhlasím s tebou – odmítnutý scénář nesmí znamenat „navždy smazanou možnost“. U lidí se mění:

věk,
zkušenosti,
důvěra,
hranice,
životní situace.

Co bylo v roce 2026 nepřijatelné, může být v roce 2034 úplně v pořádku.

Já bych to dokonce považoval za jednu z hlavních filozofií EROSU:

Nic nemusí být navždy. ❤️

🚧 AKTUÁLNĚ DĚLÁME
Bohatší historie scénářů

Zobrazovat:

 datum
 stav
 reakci partnera
 📷 důkaz odeslán
 ❤️ důkaz přijat
Znovu zvážit odmítnutý scénář

❌ Odmítnuté

↓

⏳ Odložené

 funkce existuje
 vylepšit UX
🔜 DALŠÍ VERZE
🔄 Zopakovat scénář

Po otevření historie:

🔄 Chcete si tento scénář zopakovat?

ANO / NE

ANO:

vytvoří nový scénář
otevře editor
umožní úpravy
odešle partnerovi
celý proces začne znovu
❤️ Návrat k odloženým scénářům

Po letech:

⏳ Tento scénář byl kdysi odložen.

Chceš se k němu vrátit?

ANO / NE

ANO:

postponed
↓
received
❤️ Návrat k odmítnutým scénářům

Po letech:

❌ Tento scénář byl kdysi odmítnut.

Možná dnes už situaci vidíš jinak.

Chceš mu dát druhou šanci?

ANO / NE

ANO:

rejected
↓
received

Tím se znovu aktivuje a partner na něj může znovu reagovat.

Historie opakování

Romantická večeře

2026 ✅
2028 ✅
2031 ❌
2034 ✅
2040 ✅
Hodnocení scénáře

😍 Předčilo očekávání

😊 Skvělé

😐 Průměrné

😕 Nic moc

❌ Už nikdy

Strom scénářů

Původní scénář:

Romantická večeře

opakování:

2026 ✅
2032 ✅
2035 ❌
2038 ✅
2042 ❤️
❤️ DIGITÁLNÍ KRONIKA VZTAHU
Významné události
2026 ❤️ první scénář
2028 🌅 první společná dovolená
2029 💍 svatba
2031 👶 narození dítěte
2034 ❤️ 200 společných scénářů
2040 ❤️ zopakovali jsme romantickou večeři po 14 letech
FILOZOFIE PROJEKTU

EROS není seznam úkolů.

EROS není jen hra.

EROS je digitální kronika vztahu a společných vzpomínek. ❤️

Scénáře nejsou jednorázové.

Lidé se mění.

Důvěra se vyvíjí.

Co bylo kdysi odmítnuté, může být za několik let krásnou společnou vzpomínkou. ❤️
✅ odstranění Anonymous Auth
✅ stabilní Firebase UID
✅ LoginScreen
✅ AuthWrapper
✅ Email/Password registrace
✅ odhlášení uživatele
✅ SettingsScreen
✅ l10n pro Settings
✅ čistý flutter analyze
📒 EROS – Vývojový deník (hlavní plán)
✅ STAV PROJEKTU
Hotovo
Firebase přihlášení
Propojení partnerů
Cloud scénáře
Cloud reakce
Potvrzení důkazu
WhatsApp důkaz
Lokální historie
Opakování scénářů
Lokalizace CZ/EN
Windows i Android fungují
Git je stabilní
🔴 PRIORITA 1 – HISTORIE (aktuální práce)
Cíl

Vytvořit historii vztahu, ne jen seznam scénářů.

Každý scénář bude mít:
Scénář

Pokus 1
    reakce
    datum
    důkaz

Pokus 2
    reakce
    datum
    důkaz

Pokus 3
    ...
parentScenarioId

Bude představovat celou rodinu scénáře.

Nikdy se nebude měnit.

Detail historie

Každý pokus zobrazí

✅ datum

✅ text scénáře

✅ cíl

✅ hranice

✅ emoce

✅ reakce partnera

✅ stav

✅ důkaz

Seznam historie

Jedna karta = jedna rodina scénáře

například

První masáž

4 pokusy

8 reakcí

26.6.2026 → 18.8.2031
🔴 PRIORITA 2 – DŮKAZY

Každý pokus bude mít vlastní důkaz.

Později:

📷 více fotek

🎥 video

🎤 hlasová zpráva

🔴 PRIORITA 3 – STATISTIKY

Historie bude umět spočítat

Scénář

7 pokusů

5 splněno

2 odloženo

1 odmítnuto
🔴 PRIORITA 4 – ČASOVÁ OSA

Partner bude moci listovat historií

2026

Scénáře

Reakce

Důkazy

↓

2027

↓

2028

↓

2034

To podle mě bude jedna z nejhezčích funkcí aplikace.

🔴 PRIORITA 5 – DENÍK VZTAHU

Každý scénář se stane vzpomínkou.

Například

První masáž

26.6.2026

❤️ reakce

📷 důkaz

--------------------------------

15.8.2027

❤️ reakce

📷 důkaz

--------------------------------

12.2.2032

❤️ reakce

📷 důkaz

To bude podle mě obrovská hodnota aplikace.

🔴 PRIORITA 6 – ARCHIV

Po několika letech budou stovky scénářů.

Přidáme

filtr
hledání
oblíbené
archiv
🔴 PRIORITA 7 – EXPORT

Možnost vytvořit

PDF

Historie vztahu

2026–2036

včetně reakcí a fotografií.

🔴 PRIORITA 8 – BUDOUCNOST

Architekturu navrhovat tak, aby šlo snadno přidat:

AI analýzu vztahu
doporučení dalších scénářů
výroční statistiky
připomenutí starých scénářů
společnou časovou osu partnerů
📌 Pravidla vývoje
Nikdy neměnit datový model bez opravdu dobrého důvodu. Současný návrh je dostatečně flexibilní.
Každou novou funkci navrhovat tak, aby byla kompatibilní se starými daty.
Po každé větší funkci udělat Git commit.
Po každé změně musí projít flutter analyze bez chyb.
Velké funkce rozdělit na malé kroky a po každém kroku otestovat.
Neřešit jen aktuální problém, ale myslet na to, jak bude aplikace fungovat za 5–10 let.
EROS je digitální kronika vztahu a společných vzpomínek. ❤️

Tohle bych dal úplně nahoru jako hlavní myšlenku projektu. Všechno ostatní – scénáře, reakce, důkazy – jsou prostředky, jak tu kroniku vytvářet.

Co bych v roadmapě změnil

Dnes máš Priority 1–8. Já bych je přeskupil.

🔴 PRIORITA 1 – Společná kniha vztahu

To bych udělal jako hlavní cíl.

Do ní patří:

📖 společné kapitoly
❤️ pocity autora
❤️ pocity partnera
📷 fotografie
⭐ oblíbené
✏️ název a úvod
📅 datum
💬 společná poznámka po letech

Teprve z této knihy by vycházely všechny ostatní funkce.

🔴 PRIORITA 2 – Historie scénářů

Scénář není cíl.

Scénář je jen způsob, jak vytvořit další kapitolu knihy.

To je podle mě obrovská změna filozofie.

A při čtení roadmapy mě napadly tři funkce, které bych určitě přidal.
❤️ 1. Kapitola není hotová, dokud oba nenapíšou své pocity

Například:

Autor
✔ napsal

Partner
⏳ čeká na své pocity

Kapitola se dokončí až tehdy, když oba přidají svůj pohled.

❤️ 2. "Přečteno partnerem"

Autor dostane oznámení:

❤️ Partner si přečetl tvoje pocity.

Je to drobnost, ale dává jistotu, že druhý člověk ten text opravdu viděl.

❤️ 3. Časová kapsle

Tohle je nápad, který bych si určitě zapsal.

Při psaní pocitů by šlo zaškrtnout:

🔒 Otevřít až za 1 rok

🔒 Otevřít až na výročí

🔒 Otevřít až za 5 let

Pak by se po roce oběma zobrazilo:

❤️ Před rokem jste si napsali toto...

To podle mě dokonale zapadá do myšlenky digitální kroniky.
🔮 Budoucí moduly

□ Connection (EROS ID)

Soukromá síť kontaktů založená na EROS ID.

Nejde o klasický chat.

Primárním účelem je bezpečné propojení lidí a sdílení funkcí EROSu.