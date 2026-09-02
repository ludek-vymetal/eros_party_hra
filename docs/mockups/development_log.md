# Development Log

---

# 2026-07-03

## Architektonický sprint

### Dokončeno

- Přesun Repository do vlastní složky `repositories`.
- Vytvořena finální struktura modulu `relationship_book`.
- Přidán model `ChapterTimelineEntry`.
- Ověřena čistá architektura modulu.
- `flutter analyze` bez chyb.
- Git commit.

---

# 2026-07-02

## Relationship Book – Základ architektury

### Dokončeno

- Navržena architektura modulu Relationship Book.
- Vytvořen model `MemoryParticipant`.
- Vytvořen model `MemoryScenario`.
- Vytvořen model `ChapterStatus`.
- Vytvořena základní struktura `relationship_book`.
- `flutter analyze` bez chyb.
- Git commit.

### Výsledek

- Relationship Book je samostatný modul.
- Repository je odděleno od Service.
- Jedna kapitola představuje jeden Firestore dokument.
RelationshipChapter

MemoryParticipant

MemoryScenario
Kde jsme

Máme:

Repository

CloudService

Firestore kolekce
# 2026-07-04

## Relationship Book – Doménový model a Firestore

### Dokončeno

- Dokončen model `RelationshipChapter`.
- Přidán `ChapterStatus` do datového modelu.
- Přidána serializace `toJson()` pro `RelationshipChapter`.
- Ověřena serializace modelů:
  - `MemoryParticipant`
  - `MemoryScenario`
- Vyčištěna architektura Repository.
- Repository přesunuta do vlastní složky `repositories`.
- Propojeno `RelationshipBookRepository` s `CloudRelationshipBookService`.
- Implementována metoda `saveMemory()`.
- `flutter analyze` bez chyb pro nově vytvořený kód.

### Stav projektu

Hotovo:

- ✅ Doménové modely
- ✅ Serializace (`toJson`)
- ✅ Repository Pattern
- ✅ První zápis do Firestore

### Další sprint

- Implementace `getMemory()`
- Implementace `getAllMemories()`
- Implementace `updateMemory()`
- Implementace `deleteMemory()`
- Přidání `fromJson()` do `RelationshipChapter`
- První načtení dat z Firestore
# Historie vývoje

---

## Sprint RB-001
**Datum:** 2026-07-02

### Cíl
Vytvořit architekturu Relationship Book.

### Dokončeno
- vytvořena struktura modulu
- Repository Pattern
- základní modely

### Test
- flutter analyze ✅

### Git
2dea99a

---

## Sprint RB-002
**Datum:** 2026-07-03

### Cíl
Dokončit doménové modely.

### Dokončeno
- MemoryParticipant
- MemoryScenario
- ChapterStatus
- RelationshipChapter
- toJson()

### Test
- flutter analyze ✅

### Git
ec96a96

---

## Sprint RB-003
**Datum:** 2026-07-04

### Cíl
Začít Firestore vrstvu.

### Dokončeno
- CloudRelationshipBookService
- saveMemory()
- getMemory()

### Test
- flutter analyze ✅

### Git
(commit doplníme po dokončení sprintu)
## Sprint RB-004
Datum: 2026-07-04

### Cíl

Rozšířit CloudRelationshipBookService o čtecí operace.

### Dokončeno

- implementována metoda saveMemory()
- implementována metoda getMemory()
- implementována metoda getAllMemories()
- připravena Service vrstva pro Repository

### Test

✅ flutter analyze

### Stav projektu

🟢 Stabilní

### Git

(doplníme po commitu)
factory RelationshipChapter.fromJson(
  Map<String, dynamic> json,
) {
  return RelationshipChapter(
    id: json['id'] as String,
    participants: (json['participants'] as List<dynamic>)
        .map(
          (participant) => MemoryParticipant.fromJson(
            participant as Map<String, dynamic>,
          ),
        )
        .toList(),
    scenario: MemoryScenario.fromJson(
      json['scenario'] as Map<String, dynamic>,
    ),
    chapterTitle: json['chapterTitle'] as String,
    introduction: json['introduction'] as String,
    favorite: json['favorite'] as bool,
    createdAt: DateTime.parse(
      json['createdAt'] as String,
    ),
    updatedAt: DateTime.parse(
      json['updatedAt'] as String,
    ),
    status: ChapterStatus.values.firstWhere(
      (value) => value.name == json['status'],
    ),
  );
}## Sprint RB-005
Datum: 2026-07-04

# Přehled sprintů

| Sprint | Stav | Git |
|---------|------|------|
| RB-001 | ✅ | 2dea99a |
| RB-002 | ✅ | ec96a96 |
| RB-003 | ✅ | ... |
| RB-004 | ✅ | ... |
| RB-005 | ✅ | 5e98cc7 |
| RB-006 | 🔄 | |

### Cíl

Dokončit serializaci RelationshipChapter a připravit Relationship Book pro Firestore.

### Dokončeno

- přidán ChapterStatus do RelationshipChapter
- implementováno toJson()
- implementováno fromJson()
- dokončen MemoryParticipant
- dokončen MemoryScenario
- rozšířen CloudRelationshipBookService
- připravena serializace pro Firestore

### Test

✅ flutter analyze

### Stav projektu

🟢 Stabilní

### Git
RB-005 Complete Relationship Book serialization layer
5e98cc7

## Sprint RB-006
Datum: 2026-07-04

### Cíl

Dokončit Repository vrstvu Relationship Book.

### Dokončeno

- implementována metoda saveMemory()
- implementována metoda getMemory()
- implementována metoda getAllMemories()
- implementována metoda updateMemory()
- implementována metoda deleteMemory()
- Repository plně propojeno s CloudRelationshipBookService

### Test

✅ flutter analyze

### Stav projektu

🟢 Stabilní

### Git

cb644a2  "RB-006 Complete Relationship Book repository"
## Sprint RB-008
Datum: 2026-07-04

### Cíl

Integrovat Relationship Book do aplikace a ověřit kompletní komunikaci s Firestore.

### Dokončeno

- přejmenováno tlačítko "Deník vztahu" na "Kniha vztahu"
- vytvořena první obrazovka RelationshipBookScreen
- obrazovka napojena na RelationshipBookRepository
- Repository napojeno na CloudRelationshipBookService
- přidána kolekce relationship_book do Firestore Rules
- ověřena komunikace s Firestore
- úspěšně zobrazen prázdný stav "Zatím nemáte žádné kapitoly."

### Test

✅ flutter analyze

✅ otevření obrazovky z hlavního menu

✅ komunikace s Firestore

### Stav projektu

🟢 Stabilní

### Git

76d449c "RB-008 Integrate Relationship Book into application"
## Architektonické rozhodnutí

Během návrhu Relationship Book byla změněna filozofie vytváření kapitol.

Původní návrh:

- uživatel vytváří kapitolu ručně.

Nový návrh:

- kapitola vzniká automaticky jako důsledek společné aktivity partnerů.

Díky tomu Kniha vztahu představuje skutečnou kroniku vztahu místo ručně vytvářených poznámek.
## Architektonická změna

Byla změněna filozofie modulu Relationship Book.

Původní návrh:

- ruční vytváření kapitol.

Nový návrh:

- automatické vytváření kapitol na základě společných událostí partnerů.

Vývoj RB-009 byl upraven podle tohoto rozhodnutí.
## Základní pravidlo

Kapitola nikdy není uzavřená.

Partner může kdykoliv:

- znovu splnit scénář,
- přidat nové fotografie,
- přidat nové video,
- přidat další poznámku,
- přidat nové pocity,
- přidat vzpomínku po letech.

Každá kapitola se během života vztahu přirozeně rozrůstá.
## RB-010 – Doménový refaktoring Relationship Book

### Dokončeno

- RelationshipMemory → RelationshipChapter
- MemoryParticipant → RelationshipParticipant
- MemoryScenario → RelationshipScenario
- Přidán nový model RelationshipMoment
- Aktualizovány importy a serializace
- flutter analyze bez chyb
git 9e00bb7  "RB-010 Domain refactor: RelationshipChapter architecture"

### Výsledek

Relationship Book přešel na novou doménovou architekturu založenou na:

RelationshipBook
└── RelationshipChapter
    ├── RelationshipScenario
    ├── RelationshipParticipant
    └── RelationshipMoment

Tím byly položeny základy pro dlouhodobě rozšiřitelnou digitální kroniku vztahu.

 
git  f0eb35c commit -m "RB-011 Relationship Book engine architecture"
# RB-013 – Stabilizace architektury

## Dokončeno

- odstraněny konflikty mezi starým Relationship Journal a novým Relationship Book
- opraveny modely RelationshipChapter
- opraven RelationshipJournalStorage
- obnovena čistá flutter analyze
- potvrzena architektura Relationship Book

## Stav

✅ Analyze
✅ Build
✅ Připraveno na další vývoj
git ee1d149  "RB-013 Stabilize Relationship Book architecture"
# RB-015 – Relationship Book Domain Architecture

## Dokončeno

- vytvořen ChapterEngine
- vytvořen RelationshipEvent
- dokončen RelationshipChapter
- dokončen ChapterStatus
- připravena doménová architektura
- opraveny konflikty mezi starým a novým modulem
- obnovena čistá flutter analyze

## Stav

✅ Analyze
✅ Build
✅ Git  42ee249  "RB-015 Relationship Book domain architecture"
📖 RB-016 – Relationship Book Event Engine

Datum: 08.07.2026

Cíl

Rozšířit Relationship Book o plnohodnotnou správu událostí (Relationship Events) a připravit základ pro automatickou časovou osu společných vzpomínek.

Dokončeno
Architektura
dokončen ChapterEngine
přidána metoda findChapterByScenario()
přidána metoda createChapterFromScenario()
přidána metoda addEvent()
připravena aktualizace kapitoly přes Repository
Modely
dokončen RelationshipEvent
rozšířen RelationshipEventType
připravena kolekce events v RelationshipChapter
UI
vytvořen nový RelationshipBookScreen
vytvořen nový RelationshipChapterScreen
vytvořen widget EventTile
připravena vizualizace timeline událostí
oddělen nový Relationship Book od původního modulu
Refaktoring
sjednocena struktura nového modulu relationship_book
odstraněna závislost na starém RelationshipChapterScreen
připravena migrace ze starého Relationship Journal
Stav projektu
Relationship Book

✔ Repository
✔ Engine
✔ Models
✔ Event System
✔ Timeline UI
✔ Chapter Screen
✔ Book Screen
Připraveno pro RB-017

Následující sprint bude zaměřen na automatické zapisování skutečných událostí:

přijetí scénáře
odmítnutí scénáře
splnění scénáře
přidání fotografie
přidání hlasové zprávy
přidání poznámky

Tyto akce se budou automaticky zapisovat do časové osy Relationship Book.

Stav
✅ flutter analyze
✅ Build
✅ Git
✅ Připraveno na další vývojgit add .

git b0fd9a6 "RB-016 Relationship Book timeline foundation"
RB-017 – Automatic Relationship Events

Datum: 09.07.2026

Cíl

Napojit Relationship Book na skutečné akce v aplikaci tak, aby se kapitoly začaly automaticky aktualizovat bez použití původního RelationshipJournalStorage.

Dokončeno
přidána metoda updateIntroduction()
odstraněna první závislost na RelationshipJournalStorage
ukládání názvu kapitoly a úvodu přes ChapterEngine
přidána první automatická událost (noteAdded)
propojení CloudPartnerScenarioDetailScreen s novým Event Engine
import RelationshipEvent
zachována čistá architektura Repository → Engine → UI
Stav
✅ flutter analyze
✅ Build
✅ Automatické zapisování událostí funguje
✅ Další krok připraven
git 20ecc65 "RB-017 Relationship Book automatic events"
📖 RB-023 – Relationship Book Story UI
Dokončeno
vytvořen widget StorySection
vytvořen widget ReflectionCard
Relationship Chapter přestavěna do podoby stránky knihy
přidána sekce Náš příběh
přidána sekce Výzva, která to všechno začala
přidána sekce Naše pohledy
přidána sekce O této kapitole
zachována Timeline jako základ budoucí kroniky
sjednocen vizuální styl všech sekcí
odstraněny duplicitní widgety a chyby analyzátoru
připravena architektura pro budoucí Reflection model
Stav projektu

✅ Relationship Book UI stabilní

✅ flutter analyze bez chyb

✅ Build OK

✅ Připraveno pro RB-024 (Reflection Domain)

git a0966dd "RB-023 Relationship Book story page redesign"
# RB-023.1 – Relationship Chapter Screen Polish

Datum: 10. 7. 2026

## Dokončeno

- kompletně přepracována obrazovka RelationshipChapterScreen
- odstraněny duplicitní sekce a nadpisy
- sjednocen vzhled pomocí StorySection
- přidána sekce „Náš příběh“
- přidána sekce „Naše pohledy“
- přidána sekce „Výzva, která to všechno začala“
- přidána sekce „O této kapitole“
- Timeline převedena do StorySection
- přidán prázdný stav Timeline (noEventsYet)
- kompletní převod všech textů na AppLocalizations (l10n)
- přidány pomocné metody _statusText() a _formatDate()
- odstraněny hardcoded texty

## Výsledek

Relationship Book už nepůsobí jako seznam dat, ale jako stránka knihy se samostatnými kapitolami.

## Další krok

RB-024 – Reflection Domain
- model vzpomínek partnerů
- ukládání Reflection
- načítání Reflection
- propojení ReflectionCard s reálnými daty

git 86a239d    "RB-023.1 Polish Relationship Chapter Screen"

RB-024.6 – Reflection Editor Navigation

- ReflectionCard je nyní klikací.
- Přidán EditRelationshipReflectionScreen.
- Editor vrací RelationshipReflection přes Navigator.pop().
- RelationshipChapterScreen přijímá výsledek.
- Přidán RelationshipReflectionService.
- Přidán LocalRelationshipReflectionRepository.
- Připraven základ pro ukládání Reflection.

git  792c131   "RB-024.6 Reflection editor navigation and service integration"

RB-024.7 – Reflection persistence

- RelationshipChapterScreen převeden na StatefulWidget.
- Přidáno načítání Reflection přes RelationshipReflectionService.
- ReflectionCard zobrazuje uložený text.
- EditRelationshipReflectionScreen přijímá chapterId.
- Reflection se ukládá a ihned načítá zpět.
- Dokončen první kompletní CRUD tok Reflection.

git 3433099  "RB-024.7 Complete reflection persistence"

RB-025 – Dual Reflection System

- Přidán authorId do Reflection editoru.
- Reflection jsou nyní rozděleny na "me" a "partner".
- RelationshipChapterScreen načítá obě Reflection.
- Obě ReflectionCard jsou editovatelné.
- Každá Reflection se ukládá samostatně.
- Připraveno pro budoucí synchronizaci přes Firebase.
git 8d02d63  "RB-025 Dual reflection system"
📖 Vývojový deník EROS
Datum

11. 7. 2026

Relationship Book – Kapitola
Dokončeno

Kompletně přepracována obrazovka detailu kapitoly v Relationship Book.

Změny UI
Hero sekce
zvětšen horní hero blok
odstraněn duplicitní název scénáře
přidán prostor pro budoucí dynamické "Eros Voice"
vytvořen widget ChapterWhisper
přidána souhrnná informační lišta
počet pohledů
počet fotografií
počet výzev
Nové pořadí sekcí

Původní:

Příběh
Fotografie
Pohledy
Výzva

Nové:

Jak to začalo

Jak jsme to prožili

Naše výzva

Zachycené okamžiky

O této kapitole

Náš příběh v čase

Cílem bylo vytvořit dojem skutečné knihy vzpomínek namísto technického seznamu.

Fotografie

Kompletně přepracován prázdný stav.

Původní text:

Nejsou žádné fotografie.

Nový koncept:

Každá fotografie uchovává okamžik, ke kterému se jednou rádi vrátíte.

Tato kapitola zatím čeká na svou první vzpomínku.

Tlačítko změněno na:

Zachytit první okamžik

(později zvážit změnu na „Zachytit první vzpomínku“)

Terminologie

Přejmenovány sekce:

Příběh → Jak to začalo
Pohledy → Jak jsme to prožili
Výzva → Naše výzva
Fotografie → Zachycené okamžiky
Timeline → Náš příběh v čase

Cílem bylo odstranit technické názvy a vytvořit jazyk odpovídající deníku vztahu.

Hero statistiky

Přidána informační řádka:

❤️ Pohledy
📷 Fotografie
🏆 Výzvy

Vytvořena pomocná metoda pro správné české skloňování.

Filozofie projektu

Během návrhu byla definována nová hlavní myšlenka EROSu.

EROS není erotická hra.

EROS je vztahový deník, který pomocí překvapení, společných výzev a intimních zážitků pomáhá partnerům vytvářet nové společné vzpomínky.

Erotické scénáře nejsou cílem aplikace.

Jsou jedním z prostředků, jak podporovat blízkost partnerů.

Nový koncept

Vznikla myšlenka:

Eros Voice

Aplikace nebude používat obyčejné motivační citáty.

Místo nich bude mít vlastní hlas.

Krátké věty mají:

vyvolávat zvědavost,
očekávání,
odvahu,
chuť partnera překvapit.

Nikdy nesmí působit jako motivační klišé.

Příklady:

Tak co... čím ho nebo ji překvapíš příště?

Největší dobrodružství začínají jediným odvážným nápadem.

Nechte dnešek rozhodnout, na co budete jednou vzpomínat.

Architektura (schválená)

Budou vytvořeny nové soubory:

relationship_book/
data/
    eros_voice_cs.dart
    eros_voice_en.dart

services/
    eros_voice_service.dart

widgets/
    chapter_whisper.dart

Citáty nebudou součástí ARB.

ARB bude obsahovat pouze texty uživatelského rozhraní.

Stav projektu

✅ Nové UI dokončeno

✅ Terminologie sjednocena

✅ Směr projektu potvrzen

⏳ Další etapa:

Implementace systému Eros Voice a dynamického zobrazování vět podle kontextu kapitoly.
git dca1428 "Refactor Relationship Book chapter UI and improve emotional storytelling"


git 07d3185  "Add Eros Voice architecture"

# Development Log

## Date
2026-07-13

## Sprint
RB-026 – Relationship Chapter Persistence

## Completed

- Created CloudRelationshipReflectionRepository
- Connected Relationship Reflections to Cloud Firestore
- Implemented saveReflection()
- Implemented getReflections()
- Replaced Local Repository with Cloud Repository
- Connected Reflection editor with Firestore persistence
- Fixed Firestore security rules for Relationship Book subcollections
- Unified architecture to use existing relationship_book collection
- Successfully tested reading and writing Reflection data
- Reflection is now persisted in Cloud Firestore

## Result

Relationship Reflections are now fully stored in Firebase.

Database structure:

relationship_book
 └── chapterId
      └── reflections
           ├── me
           └── partner

Relationship Book now has persistent cloud storage for reflections.

## Status

RB-026 completed.

git daa6f53  "RB-026 Complete Firestore persistence for Relationship Reflections"

Návrh zápisu do deníku
📅 Datum
2026
📖 Kniha vztahu
✅ Přidána galerie fotografií kapitol
možnost přidat fotografii ke kapitole
lokální ukládání fotografií
fotografie se po restartu aplikace zachovají
ukládání do složky aplikace
metadata ukládána pomocí SharedPreferences
fotografie jsou organizovány po jednotlivých kapitolách
✅ Architektura
vytvořen LocalRelationshipPhotoRepository
oddělena repository a service vrstva
připraven základ pro budoucí cloudovou synchronizaci
✅ PartnerService
vytvořen PartnerService
odstraněna závislost na natvrdo zadaných identifikátorech uživatelů
připravena architektura pro budoucí propojení partnerů přes Firebase Auth
💡 Rozhodnutí
aplikace bude fungovat plnohodnotně offline
cloud bude sloužit pouze pro synchronizaci
fotografie patří ke konkrétní kapitole
každé datum bude mít svého autora
📌 Další úkol
zavést PartnerService do celého projektu
opravit autorství (já × partner)
zabránit úpravě cizích reflexí a fotografií
git 8a4cf11 "feat(relationship-book): local photo storage and PartnerService architecture"


📖 Vývojový deník – EROS PARTY GAME

Datum: 21. 7. 2026

Kniha vztahu – Partner Identity System
✅ Novinky
Přidán PartnerService jako centrální služba pro identitu partnerů.
PartnerService je nově inicializován po přihlášení uživatele (AuthWrapper).
PartnerService načítá:
aktuální Firebase UID uživatele,
UID propojeného partnera z PartnerLinkService.
Přidán clear() při odhlášení uživatele.
Zachována zpětná kompatibilita pomocí myId / partnerId pro postupnou migraci.
Opravy Knihy vztahu
Reflexe
Autorství již využívá PartnerService.isMine().
Partnerova reflexe je otevřena pouze pro čtení.
Uživatel již nemůže vytvářet ani upravovat partnerovu reflexi.
PermissionService sjednocuje kontrolu oprávnění.
Fotografie
Lokální ukládání fotografií je plně funkční.
Fotografie zůstávají zachované po restartu aplikace.
Připravena architektura pro řízení oprávnění podle autora fotografie.
Architektura

Nově existuje jednotný systém identity:

Firebase Auth
      │
      ▼
PartnerService
      │
      ├── currentUid
      ├── partnerUid
      ├── isMine()
      └── isPartner()

Veškeré nové funkce Knihy vztahu budou používat tento systém.

Stav projektu

✅ flutter analyze bez chyb

Projekt je stabilní.

git  de37be3 feat(relationship-book): introduce PartnerService identity system

- initialize PartnerService after login
- load currentUid and partnerUid
- add centralized permission handling
- lock partner reflections as read-only
- prepare migration from me/partner to Firebase UID
- stabilize relationship book architecture
- keep local photos persistent after restart

1. 📝 Zápis do Development Diary

Zapíšeme:

proč jsme přešli z hard delete na soft delete,
proč vznikl Koš,
jak funguje obnova,
že cloud fotky jsme odložili až na pozdější fázi,
jaká je nová roadmapa.
git  bbff26f  RB-033: Introduced Relationship Book Trash system
- Added soft delete architecture
- Added restore support
- Added trash screen
- Added trash service
- Hidden deleted chapters
- Added deleted chapter repository
- Fixed l10n 

git  2d01530 feat: dokončen Relationship Book Trash System

- soft delete (isDeleted, deletedAt)
- obnova vzpomínek
- trvalé odstranění
- mazání fotografií
- aktualizace repository a services
- vyčištěn kód
- analyzer: 0 errors, 0 warnings
✅ Relationship Book
✔ vytváření kapitol
✔ editace kapitol
✔ archivace do koše
✔ obnova z koše
✔ trvalé smazání kapitoly
✔ přidávání fotografií
✔ prohlížení fotografií
✔ mazání jednotlivých fotografií
✔ opravené authorId
✔ oprávnění přes PermissionService
✔ nové kapitoly fungují správně
✔ nové fotografie fungují správně

git 2c49416  mazani fotografii

======================================================================
ARCHITEKTURA VÍCE PARTNERŮ – FINÁLNÍ NÁVRH
Datum: 31.7.2026
======================================================================

Po rozsáhlé analýze jsme se rozhodli nepřesouvat celý partnerský systém
pod Relationship.

Původní úvaha byla:

relationships/
    relationshipId/
        partner_scenarios/
        partner_reactions/
        relationship_book/

Po hlubším zamyšlení jsme zjistili, že by to architektonicky nebylo správně.

Rozdělili jsme celý systém EROS na dvě samostatné části.

======================================================================
1. KOMUNIKACE PARTNERŮ
======================================================================

Tyto kolekce zůstávají samostatné:

partner_scenarios
partner_reactions

Důvod:

Scénář není ještě společná vzpomínka.

Je to pouze návrh nebo pozvánka pro partnera.

Stejně tak reakce představují komunikaci mezi partnery,
nikoliv historii vztahu.

Tyto kolekce proto zůstávají mimo Relationship.

======================================================================
2. RELATIONSHIP (SPOLEČNÁ HISTORIE)
======================================================================

Do Relationship patří pouze skutečně společná data.

Finální struktura:

relationships
    relationshipId
        relationship_book
        photos
        reflections
        memories
        settings

Sem budou ukládána pouze data,
která vzniknou po přijetí scénáře nebo při společném používání aplikace.

======================================================================
FILOZOFIE
======================================================================

Scénář = pozvánka.

Přijatý a splněný scénář = společná vzpomínka.

Teprve v okamžiku přijetí se vytvoří kapitola
v Relationship Book.

======================================================================
PODPORA VÍCE PARTNERŮ
======================================================================

Každý Relationship představuje jeden konkrétní vztah.

Příklad:

Luděk ↔ Martina
Relationship A

Luděk ↔ Katka
Relationship B

Luděk ↔ Eva
Relationship C

Přepnutí partnera znamená pouze změnu activeRelationshipId.

Po opětovném propojení se stejným partnerem se automaticky načte:

• společná Kniha vztahu
• fotografie
• reflexe
• společné vzpomínky
• statistiky vztahu

Příběh pokračuje přesně tam,
kde před rozchodem skončil.

======================================================================
NOVÁ ARCHITEKTURA
======================================================================

RelationshipService se stává jediným místem,
které zná strukturu Firestore.

Ostatní služby již nebudou pracovat přímo s Firestore,
ale pouze přes RelationshipService.

======================================================================
DALŠÍ POSTUP
======================================================================

✔ Relationship model
✔ RelationshipService
✔ ActiveRelationship
✔ PartnerLink využívá RelationshipService

Následuje migrace:

1. CloudRelationshipBookService
2. RelationshipPhotoService
3. RelationshipReflectionService

Partner scénáře ani partner reakce se migrovat nebudou,
protože představují komunikační vrstvu aplikace.
======================================================================
git add .
git b8179f8   commit -m "refactor: Relationship Book uses RelationshipService"

# 3. 8. 2026

## Cloud Partner

### Opraveno
- opraveno propojení partnerů (Partner UID)
- opraveno doručování scénářů mezi PC ↔ Android
- opraveno ukládání reakcí
- opraveno vytváření Relationship Book po dokončení scénáře
- opraveny Firestore Rules pro subkolekci relationship_book
- znovu zprovozněn dialog "Naše myšlenky"

### Otestováno
- PC → Android scénář
- Android → PC scénář
- reakce
- vytvoření kapitoly
- zobrazení kapitoly
- ukládání úvodní vzpomínky

### Zbývá
- doplnit partnerovu vzpomínku do kapitoly
- kompletní synchronizace Relationship Book
- dlouhodobé testování

git 3166431  git commit -m "Oprava synchronizace partnerů a vytvoření Relationship Book"

📅 Vývojový deník – Relationship Book

Datum: 3. 8. 2026

✅ Dokončena stabilizace Relationship systému

Po několika dnech ladění byla dokončena synchronizace mezi:

Partner Scenarios
Partner Reactions
Relationship Book

Byly odstraněny chyby způsobené starými párovacími kódy a neplatným propojením partnerů.

Ověřeno:

✅ scénáře se doručují správnému partnerovi
✅ reakce se zobrazují oběma partnerům
✅ historie funguje správně
✅ nevzniká zobrazení cizích scénářů
📖 Relationship Book propojen s reakcemi

Po dokončení scénáře se nyní automaticky vytváří kapitola v Relationship Book.

Po odeslání reakce může autor scénáře přidat úvodní vzpomínku ("Jak to začalo").

Tato vzpomínka se okamžitě uloží do společné knihy.

Bylo opraveno:

automatické vytvoření kapitoly
ukládání úvodního textu
synchronizace přes Cloud Firestore
Firestore Rules pro relationship_book
☁️ Firestore

Byla opravena pravidla.

Relationship Book již není samostatná kolekce.

Správná struktura:

relationships
 └── relationshipId
      └── relationship_book
            └── chapter

Po úpravě pravidel byly odstraněny chyby:

PERMISSION_DENIED
🎯 Zásadní rozhodnutí projektu

Dnes bylo definitivně potvrzeno, že Relationship Book nebude klasická mobilní aplikace.

Nebude používat vzhled:

Material Design
seznamů
karet
formulářů
administrace
📖 Filozofie Relationship Book

Relationship Book musí působit jako skutečná luxusní kronika vztahu.

Uživatel nesmí mít pocit:

"Vyplňuji aplikaci."

Musí mít pocit:

"Listuji naším společným příběhem."

To je jeden z hlavních pilířů projektu EROS.

📚 Struktura knihy

Každý scénář představuje jednu kapitolu.

Jedna kapitola = jedna dvojstrana otevřené knihy.

Levá stránka obsahuje:

číslo kapitoly
název
datum
Eros Voice
krátký příběh
úvodní vzpomínku
jemnou ilustraci

Pravá stránka obsahuje:

hlavní fotografii
vzpomínku partnera A
vzpomínku partnera B
drobné informace o kapitole
🎨 Vizuální styl

Definitivně schválen styl:

pergamen
luxusní papír
jemné stíny
knižní typografie
ozdobné prvky
fotografie nalepené do kroniky
žádné Material Card
žádné ostré rámečky
žádný administrativní vzhled

Inspirace:

svatební kroniky
luxusní fotoknihy
rodinné kroniky
historické knihy
📖 Navigace

Bylo rozhodnuto, že Relationship Book nebude využívat běžné přepínání obrazovek ani klasické scrollování mezi kapitolami.

Cílový způsob ovládání:

realistické listování knihou
animace otočení stránky (Page Curl / Book Flip)
pocit práce se skutečnou knihou
🖼️ Budoucnost projektu

Celý Relationship Book bude navržen tak, aby používal jeden společný layout pro:

aplikaci
HTML
PDF
profesionální tisk

Nebude existovat zvláštní tisková šablona.

Stejná kniha, kterou budou partneři několik let používat v aplikaci, bude moci být jedním kliknutím vytištěna jako luxusní fotokniha.

❤️ Hlavní myšlenka projektu

Bylo potvrzeno, že největší hodnotou projektu EROS nebude samotná erotická hra.

Největší hodnotou bude možnost vytvořit během let společnou digitální kroniku vztahu, kterou si partneři budou moci nechat vytisknout jako skutečnou knihu vzpomínek.

Tato filozofie se stává jedním z hlavních pilířů celého projektu EROS.

>> git commit -m "Relationship Book architecture split"
📖 PŘEDÁVACÍ PROTOKOL – RELATIONSHIP BOOK (aktuální stav)
✅ Hotové
Partner mód
✅ scénáře se doručují správnému partnerovi
✅ reakce se zobrazují oběma partnerům
✅ historie funguje správně
✅ nevzniká zobrazení cizích scénářů
📖 Relationship Book

Po dokončení scénáře se automaticky vytváří nová kapitola.

Autor scénáře může po reakci partnera přidat:

úvodní vzpomínku
motto
fotografie
vlastní komentář

Kniha se synchronizuje přes Firestore.

☁️ Firestore

Struktura:

relationships
 └── relationshipId
      └── relationship_book
            └── chapter
                 └── reflections

Fotografie se zatím NEUKLÁDAJÍ do cloudu.

Používá se:

LocalRelationshipPhotoRepository

Je to záměr.

Firebase Storage se bude řešit až po dokončení celé knihy.

🏗 Architektura (nová)

Bylo rozhodnuto, že existuje pouze jedna kniha.

Partner Menu
        │
        ▼
RelationshipBookScreen
        │
        ▼
RelationshipBookViewerScreen
        │
        ▼
BookBuilder
        │
        ▼
OpenBook
      │      │
      ▼      ▼
BookLeftPage
BookRightPage

Toto je jediná podporovaná cesta.

❌ Stará architektura

RelationshipChapterScreen

už nebude používaný jako prohlížeč knihy.

Obsahuje velké množství starého kódu.

Například:

_buildOriginalContent()
_buildLeftBookPage()
_buildRightBookPage()

Tyto metody jsou dnes mrtvý kód.

📚 Struktura kapitoly

Jedna kapitola = jedna otevřená dvojstrana.

Levá stránka

Obsahuje:

číslo kapitoly
název
datum
ozdobnou linku
motto
hlavní text
Eros Voice
číslo stránky
Pravá stránka

Obsahuje:

hlavní fotografii
vzpomínku autora
vzpomínku partnera
číslo stránky
🎨 Styl knihy

Definitivně schváleno:

pergamen
luxusní papír
měkké stíny
stará knižní typografie
fotokniha
rodinná kronika
svatební kronika

Zakázáno:

Material Card
administrativní vzhled
ostré rámečky
klasické seznamy
formulářový vzhled
📷 Fotografie

Fotografie mají připomínat:

nalepenou fotografii
polaroid
lehké natočení
jemný stín

Fotografie se zatím ukládají lokálně.

❤️ Memory Block

MemoryBlock nemá připomínat kartu.

Má působit jako zápis do kroniky.

Obsahuje:

autora
oddělovací linku
text
jemný papír
měkký stín
✨ Motto

Motto není administrativní pole.

Má působit jako citát.

Velké uvozovky.

Kurzíva.

Vycentrovaný text.

📜 Eros Voice

Eros Voice nebude placeholder.

Každá kapitola bude mít vlastní krátký text.

Například:

„Některé okamžiky netrvají dlouho. Vzpomínky ano.“

Do budoucna může být:

generovaný AI,
náhodně vybraný,
vytvořený editorem.
📖 Navigace

Nebude se scrollovat.

Bude se listovat.

Cílový stav:

realistické otočení stránky
animace Book Flip
Page Curl
pocit skutečné knihy
🖨 Budoucnost

Stejný layout bude použit pro:

aplikaci
PDF
HTML
profesionální tisk

Nebude existovat zvláštní tisková šablona.

Jedna kniha = všechny platformy.

⚠ Aktuální technický dluh

V současné chvíli existuje jeden známý architektonický problém.

BookBuilder dostává:

photos
myReflection
partnerReflection

jen pro jednu kapitolu.

Správný stav bude:

Každá BookRightPage si sama načte data podle svého chapter.id.

Tím bude mít každá kapitola vlastní:

fotografie
vzpomínky
motto
Eros Voice
❤️ Hlavní myšlenka projektu

Největší hodnotou EROS nebude erotická hra.

Největší hodnotou bude možnost vytvářet během let společnou kroniku vztahu.

Kroniku, kterou si partneři po letech otevřou, budou jí listovat jako skutečnou knihou a jedním kliknutím ji nechají vytisknout jako luxusní fotoknihu.

git commit -m "Aktualni Relationship Book a auth system"

napojeni gpt na git


HLAVNÍ PRINCIP EROSU:
Žádný uživatel nikdy nesmí vidět ani ovlivnit data jiného Relationship.
Firebase UID → Relationship → scénáře → reakce → Relationship Book musí tvořit jeden bezpečný datový řetězec.
Lokální cache nesmí nikdy rozhodovat o tom, komu data patří.


📓 EROS – KOMPLETNÍ SEZNAM PROBLÉMŮ A ÚKOLŮ
🔴 A. KRITICKÉ – MUSÍME OPRAVIT
1. Izolace účtů / starý Relationship ID

Problém: active_relationship_id je uložený v SharedPreferences a při logoutu se nemaže přes RelationshipService. Nový účet tak může zdědit Relationship předchozího účtu. getActiveRelationship() navíc zatím nekontroluje, zda aktuální Firebase UID skutečně patří do načteného Relationship.

Opravit:

při logoutu vyčistit aktivní Relationship,
getActiveRelationship() ověřovat proti currentUser.uid,
pokud UID není user1Uid ani user2Uid, Relationship odmítnout,
nikdy nepoužít cizí relationshipId.

Priorita: 🔴 KRITICKÁ

2. Partner scénáře nejsou dostatečně chráněné proti cizím datům

incomingScenarios() filtruje pouze:

relationshipId

Opravit:

ověřovat aktivní Relationship,
ověřovat aktuální UID,
případně filtrování podle receiverUid,
zkontrolovat Firestore Security Rules.

Priorita: 🔴 KRITICKÁ

3. Partner reakce – stejný problém s izolací dat

Reakce používají relationshipId, ale stejně jako scénáře musíme zajistit, že uživatel nemůže přes starý lokální stav získat reakce jiného vztahu.

Priorita: 🔴 KRITICKÁ

4. Logout maže vlastní Partner Code

V SettingsScreen se při logoutu volá:

PartnerLinkService.resetMyCode();

To smaže vlastní partnerCode z Firestore.

Přitom nový PartnerLinkService správně počítá s tím, že vlastní kód je trvalý kód účtu a při logoutu se nemá mazat.

Opravit:

logout ≠ reset Partner Code,
resetMyCode() pouze pro skutečný požadavek „změnit můj kód“.

Priorita: 🔴

5. Odpojení partnera vs. smazání Relationship

Momentálně unlink() maže lokální:

partnerCode
partnerUid
relationshipId

ale neřeší skutečný Relationship ve Firestore.

Musíme přesně definovat:

ODPOJIT PARTNERA
≠
SMAZAT VZTAH
≠
SMAZAT HISTORII
≠
SMAZAT ACCOUNT

Priorita: 🔴

🟠 B. RELATIONSHIP BOOK – PROBLÉMY K DOTAŽENÍ
6. RelationshipChapter má problém s motto

Model má:

String? customMotto

a zároveň:

String? get motto => customMotto;

To znamená, že motto není skutečně samostatná hodnota.

Musíme rozhodnout:

erosVoiceId
customMotto
motto

co je skutečný zdroj hodnoty.

7. Relationship Book používá hard-coded texty

Například:

KAPITOLA
EROS VOICE
Místo pro Eros Voice.
Partner
Autor přidal úvod kapitoly.

jsou přímo v UI/modelové logice.

Opravit:

vše do app_cs.arb,
vše do app_en.arb,
žádné české texty natvrdo v kódu.
8. CloudPartnerScenarioDetailScreen má příliš mnoho odpovědnosti

Jedna obrazovka nyní řeší:

reakci
Cloud scénář
lokální ScenarioRecord
Relationship Chapter
Reflection
Relationship Journal
Chapter title
Introduction
Events

To je architektonicky příliš mnoho.

Později rozdělit:

Screen
 ↓
Controller / Engine
 ↓
Services
 ↓
Repositories
9. Vytvoření kapitoly a reakce jsou příliš propojené

Aktuálně:

reakce
 ↓
ScenarioRecord
 ↓
RelationshipChapter
 ↓
Reflection
 ↓
Journal

To je křehké.

Musíme jasně definovat:

SCÉNÁŘ
↓
REAKCE

a nezávisle

SCÉNÁŘ
↓
KAPITOLA
10. ChapterEngine používá hard-coded text

Například:

Kapitola byla vytvořena.

a:

authorUid: ''

Opravit:

skutečný authorUid,
lokalizovaný event description,
případně event generovat až v UI/service vrstvě.
🟡 C. AUTORSTVÍ A OPRÁVNĚNÍ

Roadmapa výslovně počítá s migrací autorství na Firebase UID a s PermissionService.

11. Dokončit autorství

Musíme všude používat:

Firebase UID

a ne:

''

nebo pouze "Partner" / "Autor".

12. Dokončit PermissionService

Máme definované:

canEditReflection()
canEditPhoto()
canDeletePhoto()

ale musí být skutečně zapojené do aplikace.

13. Ověřit oprávnění k fotografiím

Musí platit:

moje fotka → můžu upravit/smazat podle pravidel
partnerova fotka → pouze pokud to pravidla dovolují
🟡 D. FOTOGRAFIE

Roadmapa uvádí fotografie jako částečně hotové, ale zároveň má ještě nedodělky kolem synchronizace.

14. Cloud Sync fotografií
15. Partner Sync fotografií
16. Koš fotografií
17. Obnova fotografie
18. Trvalé smazání
19. Správná synchronizace Firebase Storage ↔ Firestore
20. Ověřit mazání fyzického souboru ze Storage
🟡 E. BOOK VIEWER

BookBuilder aktuálně vytváří dvě stránky pro každou kapitolu:

LEFT
RIGHT

a správně předává fotky a reflexe.

Ale musíme ještě ověřit:

21. Číslování stran
22. Přechod mezi kapitolami
23. Přechod kliknutím na číslo stránky
24. Prázdné kapitoly
25. Kapitoly bez fotek
26. Kapitoly bez reflexe
27. Více fotografií
28. Více reflexí
29. Dlouhý text – přetečení stránky
🔴 F. „AUTO → SUPER TANEC“ – LOGIKA KNIHY

Tohle je jedna z věcí, kterou bychom měli opravit velmi pečlivě.

Aktuálně se při vytvoření Relationship Chapter předává:

title: scenario.nazev

A zároveň se při reakci ukládá:

scenarioName: scenario.nazev

Takže musíme jasně oddělit:

SCÉNÁŘ
AUTO

NÁZEV KAPITOLY
uživatelův název kapitoly

REAKCE
SUPER TANEC
30. Oddělit název scénáře od názvu kapitoly
31. Zabránit přepsání chapterTitle názvem reakce
32. Správně uložit reakci partnera jako Reflection
33. Správně zobrazit reakci partnera v knize
34. Ověřit, že opakovaná reakce nevytvoří další kapitolu

ChapterEngine už má kontrolu findByScenarioId(), takže základ je správně.

🟠 G. RELATIONSHIP DATA MODEL
35. Sjednotit starý Partner systém a nový Relationship systém

Momentálně stále existují paralelně:

PartnerLinkService
PartnerService
RelationshipService

a dokonce jsou stále ukládány staré hodnoty:

partnerUid
relationshipId

kvůli migraci.

Musíme dokončit migraci a potom starý systém odstranit.

36. Odstranit migrační kompatibilitu

Až bude nový systém stabilní, odstranit:

_keyRelationshipId
saveRelationshipId()
getRelationshipId()

pokud už nebude potřeba.

37. Jeden zdroj pravdy pro Relationship

Ideální stav:

Firebase Auth
      ↓
currentUser.uid
      ↓
RelationshipService
      ↓
active Relationship

a ne několik různých lokálních kopií.

🟠 H. FIRESTORE
38. Zkontrolovat Firestore Security Rules

Musíme ověřit, že uživatel může číst pouze:

svůj Relationship
své scénáře
své reakce
svůj Relationship Book
své/partnerovy fotografie podle pravidel
39. Zabránit čtení cizího Relationship přes ID
40. Zabránit zápisu do cizího Relationship
41. Zabránit manipulaci s senderUid / receiverUid
42. Zabránit manipulaci s relationshipId

Tohle je velmi důležité, protože ochrana nesmí být pouze v Dart kódu.

🟡 I. CLOUD SCÉNÁŘE
43. Ověřit status lifecycle

Máme:

received
postponed
completed
rejected

Musíme definovat přesně:

received
 ↓
completed
 ↓
Relationship Book

received
 ↓
postponed
 ↓
received / reakce

received
 ↓
rejected
 ↓
reconsider
44. Zabránit neplatným přechodům statusů
45. Ověřit opakované reakce
46. Ověřit parentScenarioId

Musí skutečně spojovat všechna opakování jednoho scénáře.

🟡 J. CLOUD REAKCE

Service už obsahuje:

sendReaction
markProofSent
acceptProof
deleteReaction

Musíme ale ověřit:

47. Kdo může reakci mazat
48. Kdo může přijmout proof
49. Kdo může označit proof jako odeslaný
50. Jestli correlationId správně spojuje související reakce
🟠 K. LOCAL STORAGE
51. Přestat mít duplicitní stav

Momentálně existuje:

SharedPreferences
+
Firebase
+
ScenarioRecordStorage
+
Relationship Book

Musíme určit, co je:

source of truth
cache
offline data
legacy data
🟡 L. LOGIN / LOGOUT
52. Logout musí vyčistit session

Ale nesmí vymazat:

Firebase účet
partnerCode
Relationship data
historii
53. Login musí správně obnovit Relationship
54. Login na druhém zařízení musí fungovat stejně
55. Android ↔ Windows musí používat stejný cloudový stav

To je přímo uvedené v next_session.md jako testovací úkol.

🟡 M. LOKALIZACE
56. Najít všechny hard-coded texty
57. Přidat chybějící CZ překlady
58. Přidat chybějící EN překlady
59. Zkontrolovat Relationship Book
60. Zkontrolovat dialogy
61. Zkontrolovat statusy
62. Zkontrolovat eventy
🟡 N. FLUTTER CLEANUP

Roadmapa už uvádí minimálně:

RadioGroup migration

Takže:

63. Dokončit RadioGroup migration
64. Opravit všechny warningy
65. Odstranit print() z produkčního kódu
66. Sjednotit debugPrint / developer.log
67. Zkontrolovat BuildContext po async operacích
68. Zkontrolovat deprecated Flutter API
🔴 O. GIT / PROJEKT
69. Odstranit functions/node_modules z Git repozitáře

V aktuální branch je obrovské množství functions/node_modules souborů. To tam nemá být.

70. Aktualizovat .gitignore
71. Zkontrolovat Firebase konfiguraci
72. Zkontrolovat, že debug/testovací data nejsou v produkční databázi
73. Udělat čistý commit po stabilizaci
🟢 P. TESTY, KTERÉ MUSÍME PROJET

Nejen opravit kód — musíme to potom opravdu otestovat.

Test 1
Účet A
→ vytvoří Relationship
→ vytvoří scénář
Test 2
odhlásit A
→ přihlásit B
→ B NESMÍ vidět data A
Test 3
A Android
↔
B Windows
Test 4
A vytvoří scénář
→ B dostane scénář
→ B odpoví
→ A dostane reakci
Test 5
scénář
→ reakce
→ kapitola
→ reflection
→ fotografie
Test 6
logout
→ login
→ Relationship se obnoví správně
Test 7
odpojení partnera
→ žádná ztráta historie
Test 8
nový účet
→ nový Partner Code
→ žádná data starého účtu
🔵 Q. FUNKCE, KTERÉ JEŠTĚ CHYBÍ – NE JSOU TO CHYBY

Podle aktuální roadmapy ještě Relationship Book čeká hlavně:

⬜ Shared Memories
⬜ Relationship Moments
⬜ Voice Memories
⬜ Video Memories
⬜ PDF Export
⬜ Printed Relationship Book
⬜ AI Story Writer
⬜ statistiky
⬜ vyhledávání
⬜ oblíbené
⬜ archiv
⬜ koš / obnova / trvalé smazání
⬜ kompletní Cloud Sync
⬜ Partner Sync

A podle next_session.md je další plánovaný krok Relationship Photos / Firebase Storage / galerie / mazání / synchronizace.

🎯 Kdybych to měl seřadit podle priority
🔴 FÁZE 1 – BEZPEČNOST DAT
Aktivní Relationship + UID
Logout cleanup
Cizí scénáře
Cizí reakce
Firestore Security Rules
Partner Code při logoutu
Odpojení partnera
🟠 FÁZE 2 – LOGIKA RELATIONSHIP BOOK
Auto ≠ název kapitoly
Super tanec = reakce/reflexe
Chapter creation
Reflection
Autorství
Permissions
Motto
Events
🟡 FÁZE 3 – STABILIZACE
Lokalizace
Flutter warnings
RadioGroup
async/context
LocalStorage vs Cloud
Android ↔ Windows test
🟢 FÁZE 4 – FOTOGRAFIE
Cloud Storage
Galerie
Partner Sync
Koš
Obnova
Trvalé mazání
🔵 FÁZE 5 – ROZŠÍŘENÍ KNIHY
Shared Memories
Moments
Voice
Video
PDF
Tisk
AI příběh
Statistiky
Vyhledávání
Oblíbené
Archiv

pretaceni stranek git  42f3a88 commit -m "oprava relationship book pager"

git po uklidu 3366edc "Fix Cloud Partner Scenario model"