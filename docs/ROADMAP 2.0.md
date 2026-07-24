# ❤️ EROS ROADMAP

---

# 1. Vize projektu

## Filosofie vývoje

Vývoj probíhá po malých stabilních sprintech.

Každý sprint je ukončen pouze pokud:

- ✅ Funkce dokončena
- ✅ flutter analyze
- ✅ Otestováno
- ✅ Git commit
- ✅ Git push
- ✅ development_log.md
- ✅ roadmap.md
- ✅ next_session.md

Teprve potom začíná další sprint.

---

# Filosofie EROSu

EROS není jen hra.

EROS není jen aplikace pro páry.

EROS je digitální kronika vztahu.

Scénáře vytvářejí zážitky.

Relationship Book je uchovává.

Každá fotografie.
Každá společná výzva.
Každý pocit.

To všechno vytváří společný příběh partnerů.

---

# 2. Architektura projektu

Projekt je postaven na čisté architektuře.

UI

↓

Service

↓

Repository

↓

Cloud / Local Storage

---

## Centrální služby

### PartnerService

- currentUid
- partnerUid
- initialize()
- clear()
- isMine()
- isPartner()

### PermissionService

- canEditReflection()
- canEditPhoto()
- canDeletePhoto()

### ChapterEngine

- createChapter()
- addEvent()
- updateIntroduction()
- updateMotto()

---

# 3. Aktuální stav projektu

## Hotovo

- ✅ Flutter
- ✅ Firebase
- ✅ Git
- ✅ Android
- ✅ Windows
- ✅ Lokalizace
- ✅ Firebase Login
- ✅ Party Game
- ✅ Community scénáře
- ✅ Partner Mode
- ✅ Cloud scénáře
- ✅ Cloud reakce
- ✅ Relationship Book
- ✅ Reflection Cloud Sync
- ✅ Local Photo Storage
- ✅ Partner Identity System

---

# 4. Aktuální sprint

## Relationship Book

Probíhá

- migrace autorství na Firebase UID
- dokončení oprávnění fotografií
- příprava cloudových fotografií
- synchronizace partnerů

---

# 5. Roadmapa verzí

## Verze 1.0

- Party Game
- Partner Mode
- Community
- Cloud scénáře
- Cloud reakce
- Firebase Login
- Relationship Book
- Reflection
- Lokální fotografie

---

## Verze 1.1

- Cloud fotografie
- Firebase Storage
- Synchronizace fotografií
- Sdílená galerie partnerů

---

## Verze 1.2

- Hlasové zprávy
- Video vzpomínky
- Emoji reakce
- Oblíbené kapitoly

---

## Verze 2.0

Relationship Book

- kompletní časová osa
- statistiky vztahu
- výroční kapitoly
- Relationship Moments
- export PDF

---

## Verze 3.0

Digitální kronika vztahu

- svatba
- děti
- dovolené
- výročí
- významné události
- časová kapsle

---

# 6. Budoucí moduly

## Connection

Soukromá síť kontaktů založená na EROS ID.

Stav:

💡 Idea

---

## AI

- doporučení scénářů
- Relationship Coach
- automatické shrnutí kapitol
- AI Eros Voice

---

# 7. Relationship Book Sprinty

## Dokončeno

✅ RB-001 Architektura

✅ RB-002 Doménové modely

✅ RB-003 Firestore Service

✅ RB-004 Firestore READ

✅ RB-005 Serializace

✅ RB-006 Repository

✅ RB-007 Relationship Book Screen

✅ RB-008 Integrace do aplikace

✅ RB-009 Automatické vytvoření první kapitoly

✅ RB-010 Detail kapitoly

✅ RB-011 Engine Architecture

✅ RB-012 Moment System

✅ RB-013 Stabilizace architektury

✅ RB-014 Chapter Creation Engine

✅ RB-015 Relationship Book Domain Architecture

✅ RB-016 Automatic Chapter History

✅ RB-017 Automatic Relationship Events

✅ RB-018 Skutečná Timeline

✅ RB-019 Chapter Story Layout

✅ RB-020 Timeline UI

✅ RB-021 Local Photo Gallery

✅ RB-022 Reflection Editor

✅ RB-023 Story Page Redesign

✅ RB-024 Reflection Domain

✅ RB-025 Dual Reflection System

✅ RB-026 Cloud Reflection Persistence

✅ RB-027 Partner Identity & Local Photo Persistence

---

## Následující sprinty

✅ RB-028 Firebase Storage Photos

✅ RB-029 RB-029 Relationship Photo Gallery

🔜 RB-030 Shared Memories

🔜 RB-031 Relationship Moments

🔜 RB-032 Voice Memories

🔜 RB-033 Video Memories

🔜 RB-034 PDF Export

🔜 RB-035 Printed Relationship Book
novy navrh
RB-030 Shared Memories
RB-031 Relationship Identity
RB-032 Relationship Archive
RB-033 Multiple Relationship History
RB-034 Book Export
RB-035 Voice Memories
RB-036 Video Memories
RB-037 AI Story Writer

---

# 8. Dlouhodobá vize

EROS nebude jen aplikace.

Bude to osobní digitální kronika vztahu.

Partnerům pomůže:

- vytvářet nové zážitky,
- uchovávat společné vzpomínky,
- vracet se k nim i po mnoha letech.

Každá kapitola bude představovat skutečný příběh jejich vztahu.

Až jednou otevřou Relationship Book po deseti letech, nebudou číst databázi.

Budou číst svůj vlastní společný život.
co nam jeste chybi  Relationship Book

✅ Kapitoly

✅ Motto

✅ Timeline

✅ Reflexe

✅ Fotografie

✅ Viewer

✅ Soukromé fotky

✅ Shared fotky

🟡 Koš

⬜ Obnova

⬜ Smazat navždy

⬜ Cloud Sync

⬜ Partner Sync

⬜ Export PDF

⬜ AI příběh

⬜ Statistiky

⬜ Vyhledávání

⬜ Oblíbené

⬜ Archiv