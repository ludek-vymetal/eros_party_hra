# Pravidla

Po každé větší změně:

flutter analyze

musí být bez chyb.

Po každé dokončené funkci:

Git commit.

Nikdy neměnit datový model bez důvodu.

Každou velkou funkci rozdělit na malé kroky.

Po každém kroku testovat.

Nové funkce musí být kompatibilní se starými daty.

Architekturu navrhovat minimálně na 10 let dopředu.
# Pravidlo 11 – Projekt nesmí záviset na paměti

Každé důležité rozhodnutí musí být zapsáno.

Nikdy nespoléhat na to, že si ho bude pamatovat vývojář ani ChatGPT.

Před začátkem nové větší funkce:

- zkontrolovat dokumentaci
- aktualizovat dokumentaci
- teprve potom psát kód

Každý nový chat musí být schopen pokračovat pouze podle dokumentace projektu.
MemoryScenario

↓

Jen scénář
MemoryParticipant

↓

Jen partner
MemoryMedia

↓

Jen média
2026-07-02

Dnes jsme změnili způsob vývoje.

Přestali jsme navrhovat obrazovky.

Začali jsme navrhovat architekturu.

Relationship Book bude samostatný modul.

Vývoj bude probíhat po malých stabilních krocích.
📍 Kde jsme

Máme:

✅ Dokumentace

✅ Architektura

✅ Roadmap

✅ Firestore návrh

✅ RelationshipMemory

✅ MemoryParticipant

✅ MemoryScenario

✅ Repository

✅ CloudService

✅ Firestore kolekc
## 2026-07-02

### Architektura Relationship Book

- Dokončeny základní modely:
  - MemoryParticipant
  - MemoryScenario
  - ChapterStatus

- Bylo rozhodnuto, že:
  - jedna kapitola = jeden Firestore dokument
  - kapitola má vlastní životní cyklus nezávislý na scénáři
  - nový vývoj probíhá pouze ve složce lib/relationship_book

- Bylo rozhodnuto odložit implementaci RelationshipMemory,
  dokud nebude definitivně schválen datový model Firestore.