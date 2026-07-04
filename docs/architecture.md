# Architektura

Projekt je rozdělen do několika samostatných částí.

## Party Game

Lokální hra.

## Community

Sdílení scénářů.

## Partner Cloud

Komunikace partnerů.

## Relationship Book

Nejdůležitější část projektu.

Obsahuje společné kapitoly vztahu.

Každá kapitola představuje jednu skutečnou společnou vzpomínku.

Nebude závislá na ScenarioRecord.

Nebude závislá na Reaction.

Bude samostatnou cloudovou entitou.
EROS
EROS

├── Party Game
├── Community
├── Partner Cloud
├── Relationship Book
└── Connection (budoucnost)

RelationshipBookRepository
        ▲
        │
 ┌──────┴─────────┐
 │                │
Firestore     LocalStorage
Repository    Repository
Screen

↓

Controller

↓

Repository

↓

CloudService

↓

Firestore
EROS

├── Party Game
├── Community
├── Partner Cloud
├── Relationship Book
└── Connection (budoucnost)

lib/

party/
relationship_book/
community/
...
Screen

↓

Controller

↓

Repository

↓

Cloud Service

↓

Firestore