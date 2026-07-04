# proc jsme se rozhodli

2026-07-01

Rozhodnutí:

RelationshipJournal nebude používat SharedPreferences.

Důvod:

Musí být synchronizovaný mezi partnery.

----------------------------

2026-07-01

Rozhodnutí:

Deník nebude historie scénářů.

Bude to společná kniha vztahu.

----------------------------

2026-07-01

Rozhodnutí:

Kapitola bude obsahovat pocity obou partnerů.

Nebude obsahovat pouze Reaction.
# 2026-07-02

## Relationship Book

Rozhodnutí:

Relationship Book nebude závislý na lokálním úložišti.

Bude představovat samostatnou cloudovou entitu synchronizovanou mezi oběma partnery.

Scénář bude pouze jednou částí kapitoly.

Kapitola bude postupně doplňována o pocity obou partnerů, fotografie a další společné vzpomínky.
## Návrh k posouzení

Relationship Book by v budoucnu mohl obsahovat obecné RelationshipEvent místo pouze scénářových kapitol.

Důvod:
Umožnilo by to ukládat i významné životní události (dovolené, svatba, výročí, děti...) do jedné časové osy.

Stav:
Pouze návrh, nerozhodnuto.
# 2026-07-02

## Návrh – Connection Module

Během návrhu architektury EROSu vznikla myšlenka vytvořit třetí hlavní modul aplikace.

Pracovní název:

Connection

Účel:

Nejedná se o klasický Messenger ani WhatsApp.

Cílem je vytvořit soukromou síť kontaktů založenou na EROS ID, podobně jako dříve fungovalo ICQ.

Uživatel může přidat pouze člověka, jehož EROS ID zná.

Nebude existovat veřejné vyhledávání uživatelů.

Nebude možné kontaktovat cizí osoby.

Komunikace bude sloužit především pro sdílení funkcí aplikace (scénáře, fotografie, pozvánky, společné zážitky).

Stav:

Pouze návrh.

Nebude implementováno před dokončením Relationship Book.
## Rozhodnutí

Hlavní prioritou projektu zůstává Relationship Book.

Všechny nové moduly musí podporovat hlavní filozofii aplikace:

EROS pomáhá vytvářet a uchovávat společné vzpomínky.

Nové funkce nesmí odvádět pozornost od tohoto cíle.
## 2026-07-03

### RelationshipMemory → RelationshipChapter

Bylo rozhodnuto, že dlouhodobě bude hlavní entita Relationship Book reprezentována jako RelationshipChapter.

Přejmenování modelu bude provedeno při dokončení datového modelu, aby nevznikaly zbytečné úpravy během vývoje.
## 2026-07-04

### Rozhodnutí

Uživatelský název modulu "Relationship Book" bude v české lokalizaci:

❤️ Kniha vztahu

### Důvod

Nejde o klasický deník.

Modul představuje společnou knihu vztahu, která uchovává kapitoly, vzpomínky a významné události obou partnerů.

### Stav

Rozhodnuto.