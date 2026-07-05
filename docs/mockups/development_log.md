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

### Výsledek

Relationship Book přešel na novou doménovou architekturu založenou na:

RelationshipBook
└── RelationshipChapter
    ├── RelationshipScenario
    ├── RelationshipParticipant
    └── RelationshipMoment

Tím byly položeny základy pro dlouhodobě rozšiřitelnou digitální kroniku vztahu.