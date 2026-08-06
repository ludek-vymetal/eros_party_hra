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