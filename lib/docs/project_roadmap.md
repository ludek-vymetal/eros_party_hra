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

Souhlasím. ❤️ Tohle je podle mě nejlepší směr pro EROS, protože historie pak nebude jen seznam názvů, ale opravdu příběh toho, co se mezi partnery odehrálo.

Já bych kartu v historii udělal například takto:

🏷️ testovani opacny

📤 Odesláno partnerovi

✅ Splněno

📅 17.6.2026 8:45

✔ Důkaz potvrzen

💬 Ok

A pro jiné stavy:

Přijatý, ještě bez reakce

🏷️ Romantická večeře

📥 Přijato od partnera

📥 Doručeno

📅 20.6.2026

Odloženo

🏷️ Výlet do hor

📤 Odesláno partnerovi

⏳ Odloženo

📅 5.7.2026

💬 Teď na to ještě nejsem připravená

Odmítnuto

🏷️ Skok padákem

📥 Přijato od partnera

❌ Odmítnuto

📅 10.8.2026

💬 Mám z toho strach

Splněno, ale důkaz ještě nebyl potvrzen

🏷️ testovani opacny

📤 Odesláno partnerovi

✅ Splněno

📅 17.6.2026 8:45

📷 Důkaz odeslán

💬 Ok

Splněno a důkaz potvrzen

🏷️ testovani opacny

📤 Odesláno partnerovi

✅ Splněno

📅 17.6.2026 8:45

✔ Důkaz potvrzen

💬 Ok