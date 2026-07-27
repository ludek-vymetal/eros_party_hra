# ❤️ Relationship Book

## Účel

Relationship Book je nejdůležitější část aplikace EROS.

Nejde o historii scénářů.

Jde o společnou knihu vztahu.

Každá kapitola představuje skutečný společný zážitek dvou partnerů.

Scénáře vytvářejí zážitky.

Relationship Book je uchovává.

Smyslem není archivovat úkoly.

Smyslem je uchovat emoce.

## Filozofie
Každá kapitola má vyprávět jeden příběh.

Každý partner má svůj vlastní pohled.

Oba pohledy jsou stejně důležité.

Kapitola není dokončená, dokud oba partneři nenapíšou své pocity.

Fotografie nejsou povinné.

Vzpomínky jsou důležitější než důkazy.

Po letech se lze ke kapitole vrátit a přidat společnou poznámku.
## Životní cyklus kapitoly

Autor vytvoří scénář
        │
        ▼
Napíše své pocity

        │
        ▼
Partner scénář splní

        │
        ▼
Napíše své pocity

        │
        ▼
Vznikne společná kapitola

        │
        ▼
Přidání fotografií

        │
        ▼
Oblíbené

        │Autor vytvoří scénář
        │
        ▼
Napíše své pocity

        │
        ▼
Partner scénář splní

        │
        ▼
Napíše své pocity

        │
        ▼
Vznikne společná kapitola

        │
        ▼
Přidání fotografií

        │
        ▼
Oblíbené

        │
        ▼
Výročí

        │
        ▼
Po letech lze přidat další společnou poznámku
        ▼
# RB-011 – RelationshipBook Engine

## Cíl

Oddělit obchodní logiku Relationship Book od Repository a Firestore.

---

## Dokončeno

- vytvořen RelationshipBookEngine
- vytvořen ChapterEngine
- oddělena doménová logika od Repository
- připravena architektura pro další enginy
- zachována čistá architektura vrstev

---

## Architektura

Screen

↓

RelationshipBookEngine

↓

ChapterEngine

↓

Repository

↓

CloudRelationshipBookService

↓

Firestore

---

## Stav

✅ flutter analyze

✅ Otestováno

✅ Připraveno pro RB-012

## Shared Memories

Fotografie nejsou automaticky sdíleny.

Po přidání fotografie si autor zvolí:

- 🔒 Jen pro mě
- ❤️ Sdílet s partnerem

Výchozí volba bude poslední použitá.

Fotografie označené jako "Jen pro mě":

- zůstávají pouze na zařízení autora
- nikdy se nesynchronizují

Fotografie označené jako "Sdílet s partnerem":

- budou synchronizovány mezi partnery
- budou dostupné v obou knihách

Výběr fotografií pro tištěnou knihu probíhá až při exportu.
## Relationship Book – fotografie

Rozhodnutí:

Fotografie nejsou sdíleny automaticky.

Důvody:

- respektování soukromí
- možnost ukládat intimní fotografie pouze pro sebe
- možnost připravovat překvapení
- uživatel má plnou kontrolu nad tím, co sdílí

Synchronizovány budou pouze fotografie, které autor označí jako sdílené.
## Design Principles