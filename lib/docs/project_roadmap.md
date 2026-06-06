# EROS PARTY GAME — ROADMAP

## ✅ HOTOVO

### Projekt

* [x] Flutter projekt vytvořen
* [x] GitHub repository vytvořeno
* [x] Git push funkční
* [x] Windows build funkční
* [x] Flutter analyze bez chyb
* [x] Flutter test funkční

---

## ✅ Lokalizace (l10n)

* [x] Čeština
* [x] Angličtina
* [x] Přepínání jazyků
* [x] app_cs.arb
* [x] app_en.arb
* [x] flutter gen-l10n
* [x] Lokalizace Community Tasks
* [x] Lokalizace Community Scenarios
* [ ] Kompletní kontrola všech starších obrazovek

---

## ✅ Party hra

* [x] Výběr hráčů
* [x] Výběr pohlaví
* [x] Obtížnost hry
* [x] Party consent screen
* [x] Herní engine
* [x] Svlékání oblečení
* [x] Poslední kus oblečení overlay
* [x] Rescue systém
* [x] Rescue hlasování
* [x] Lokální task banka
* [x] QR export tasků
* [x] QR import tasků

---

## ✅ Partner režim

* [x] Partner menu
* [x] Partner propojení
* [x] Partner kódy
* [x] Historie scénářů
* [x] Detail scénáře
* [x] Úprava scénáře
* [x] Mazání scénáře
* [x] Reakce na scénáře
* [x] Emoce
* [x] Lokální ukládání scénářů
* [x] Generování kódu po editaci scénáře
* [x] Kopírování kódu do schránky

---

# ✅ FIREBASE

## Firebase setup

* [x] Nový Firebase projekt
* [x] FlutterFire configure
* [x] Android propojení
* [x] iOS propojení
* [x] macOS propojení
* [x] Windows propojení
* [x] Web propojení
* [x] firebase_options.dart

---

## Firestore

* [x] Firestore databáze vytvořena
* [x] Europe region
* [x] Firestore Rules nastaveny
* [x] Firestore Rules pro Community Tasks
* [x] Firestore Rules pro Community Scenarios
* [x] Firestore Rules pro Reporty

---

## Authentication

* [x] Firebase Authentication
* [x] Anonymous login
* [x] Ověřený funkční login

---

# 🔥 ARCHITEKTURA CLOUDU

## Soukromý obsah

Pouze vlastník vidí:

* moje scénáře
* moje tasky
* partner data
* soukromé reakce

---

## Komunitní obsah

Všichni uživatelé vidí:

* komunitní scénáře
* komunitní tasky

---

# ✅ COMMUNITY TASKS

* [x] community_tasks kolekce
* [x] upload tasků
* [x] download tasků
* [x] sync tasků
* [x] latest tasky
* [x] top tasky
* [x] like systém
* [x] report tasků
* [x] import do TaskBank
* [x] ochrana proti duplicitnímu importu
* [x] l10n
* [x] flutter analyze bez chyb

### Chybí

* [ ] Automatické skrytí nahlášených tasků
* [ ] Moderace tasků

---

# ✅ COMMUNITY SCÉNÁŘE

## Backend

* [x] CommunityScenario model
* [x] CommunityScenarioService
* [x] community_scenarios kolekce
* [x] upload scénářů
* [x] download scénářů
* [x] latest scénáře
* [x] top scénáře
* [x] anonymní sdílení
* [x] Firestore Rules

## UI

* [x] CommunityScenariosScreen
* [x] načítání z Firestore
* [x] přepínání Latest / Top
* [x] otevření detailu scénáře

## Sdílení

* [x] Sdílet s komunitou
* [x] Sdílet anonymně
* [x] Upload při vytvoření scénáře

### Chybí

* [ ] Detail scénáře (kompletní obsah)
* [ ] Import scénáře
* [ ] Like scénáře (UI)
* [ ] Report scénáře (UI)
* [ ] Ochrana proti duplicitnímu importu scénáře
* [ ] Oblíbené scénáře

---

# 🔥 PARTNER SYNC

### Chybí

* [ ] Cloud partner propojení
* [ ] Sync mezi zařízeními
* [ ] Windows ↔ Android sync
* [ ] Windows ↔ iPhone sync
* [ ] Cloud reakce
* [ ] Cloud historie scénářů

---

# 🎨 UI / UX

### Chybí

* [ ] Animace
* [ ] Lepší přechody
* [ ] Modernější design
* [ ] Dark erotic theme polish
* [ ] Vlastní ikonografie

---

# 🍎 iOS RELEASE

### Chybí

* [ ] Apple Developer účet
* [ ] TestFlight
* [ ] App Store build
* [ ] Privacy Policy
* [ ] Age Rating 18+
* [ ] App Store metadata

---

# 🤖 BUDOUCNOST

### AI

* [ ] AI generování scénářů
* [ ] AI doporučení scénářů
* [ ] AI doporučení tasků

### Community

* [ ] Community Feed
* [ ] Trending scénáře
* [ ] Trending tasky
* [ ] Hodnocení scénářů
* [ ] Oblíbené scénáře

### Multiplayer

* [ ] Multiplayer režim
* [ ] Online Party Rooms
* [ ] Cloud Party Session

---

# 🎯 NEJBLIŽŠÍ KROKY

1. Community Scenario Detail
2. Import scénáře
3. Like scénáře
4. Report scénáře
5. Duplicitní ochrana scénářů
6. Kompletní l10n kontrola
7. Cloud Partner Sync

✅ flutter analyze čisté
✅ Community Tasks hotové
✅ Community Scenarios hotové
✅ CloudPartnerService vytvořen
✅ Firebase Authentication funkční
✅ Firestore funkční

✅ Cloud partner propojení
✅ Vyhledání partnera podle kódu
✅ Uložení partner UID
✅ partner_scenarios Firestore Rules

✅ Cloud partner scénáře - odesílání
🚧 Cloud partner scénáře - příjem
🚧 Cloud inbox
🚧 Live synchronizace

✅ Firebase Authentication
✅ Propojení partnerů kódem
✅ Ukládání partner UID
✅ Firestore pravidla
✅ Odesílání scénářů
✅ Přijímání scénářů
✅ Test mezi PC a mobilem

✅ Cloud scénáře
✅ Odesílání scénářů
✅ Doručené scénáře
✅ Detail scénáře
✅ Reakce
✅ Splněno / Nesplněno
✅ Doručené reakce
✅ Detail reakce
✅ Firestore ukládá completed
✅ Firestore ukládá proofAccepted

📋 Budoucí úkoly EROS
✅ Krátkodobé (další verze)
1. Stav v detailu scénáře

Zobrazovat:

📥 Doručeno
⏳ Odloženo
✅ Splněno
❌ Odmítnuto
2. Počítadla u záložek

Například:

📥 Doručené (2)
⏳ Odložené (5)
✅ Splněné (12)
❌ Odmítnuté (1)
3. Skrýt tlačítko „Reagovat“

Pouze pro:

📥 Doručené
⏳ Odložené
⭐ Střednědobé
4. Chci odmítnutý scénář znovu zvážit

U odmítnutého scénáře:

❌ Tento scénář byl odmítnut.

Chceš ho znovu zvážit?

ANO / NE

ANO:

❌ Odmítnuté
↓
⏳ Odložené
5. Bohatší historie scénářů

Zobrazovat:

aktuální stav;
reakci partnera;
datum;
📷 důkaz odeslán;
❤️ důkaz potvrzen;
případně hodnocení.
❤️ Dlouhodobé (moje oblíbená část)
🔄 Chcete tento scénář zkusit znovu?

V historii scénáře:

🔄 Chcete tento scénář zkusit znovu?

ANO / NE

Po kliknutí na ANO:

vytvoří se nový scénář se stejným obsahem;
odešle se partnerovi;
celý proces začne od začátku.
🕰 Historie opakování

Například:

Romantická večeře

1. pokus
14.2.2026
✅ Splněno

2. pokus
7.5.2028
✅ Splněno

3. pokus
20.10.2031
❌ Odmítnuto

4. pokus
14.2.2034
✅ Splněno
⭐ Hodnocení scénáře

Po dokončení:

😍 Předčilo očekávání
😊 Skvělé
😐 Průměrné
😕 Nic moc
❌ Už nikdy
❤️ Kronika vztahu

Za několik let:

2026 ❤️ Začátek používání EROS

2027
34 scénářů
28 splněno

2029
💍 Svatba

2031
👶 První dítě

2034
❤️ 200 společných scénářů