# Development Rules
#  Pravidla vyvoje
## Pravidlo 1 – Čistá analýza

Po každé větší změně:

- flutter analyze

Musí být bez chyb.

---

## Pravidlo 2 – Git

Po každém dokončeném sprintu:

- git add .
- git commit
- git push

---

## Pravidlo 3 – Malé kroky

Každou velkou funkci rozdělit na malé sprinty.

Po každém sprintu:

- analyza
- test
- commit

---

## Pravidlo 4 – Datový model

Nikdy neměnit datový model bez opravdu dobrého důvodu.

---

## Pravidlo 5 – Kompatibilita

Nové funkce musí být kompatibilní se starými daty.

---

## Pravidlo 6 – Architektura

Architekturu navrhovat minimálně na 10 let dopředu.

---

## Pravidlo 7 – Dokumentace

Každé důležité rozhodnutí musí být zapsáno.

Nikdy nespoléhat na paměť.

---

## Pravidlo 8 – Nový chat

Každý nový chat musí být schopen pokračovat pouze podle dokumentace projektu.

---

## Pravidlo 9 – Nové funkce

Nejdříve návrh.

Potom implementace.

---

## Pravidlo 10 – Oddělení modulů

Veškerý nový vývoj Relationship Book probíhá pouze ve složce:

lib/relationship_book

---

## Pravidlo 11 – Stabilita

Po každém dokončeném sprintu musí být projekt:

- funkční
- analyza čistá
- připravený na Git commit

flutter analyze

Git

ulozit i s cislem a nazvem 

malé sprinty

architektura

kompatibilita

projekt nesmí záviset na paměti

l10n

dokumentace

10 let dopředu

RB-006 – Repository Implementation

Dokončit:

getMemory()
getAllMemories()
updateMemory()
deleteMemory()

v FirestoreRelationshipBookRepository.

Na konci sprintu bude Repository plně funkční.