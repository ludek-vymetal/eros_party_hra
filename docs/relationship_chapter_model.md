# ❤️ RelationshipChapter Model

## Filosofie

RelationshipChapter představuje jednu kapitolu společného života dvou partnerů.

Nevzniká ručně.

Nevzniká kliknutím na tlačítko.

Vzniká automaticky jako výsledek společného prožitku.

Každá kapitola představuje jeden příběh.

Příběh se může celý život rozšiřovat.

---

# Hierarchie

Relationship Book

└── RelationshipChapter

    ├── Scenario
    ├── Participants
    ├── Experiences
    ├── Timeline
    ├── Media
    ├── Notes
    ├── Permissions

---

# RelationshipChapter

Obsahuje:

- id
- title
- status
- favorite
- createdAt
- updatedAt

- scenario
- participants
- experiences
- timeline
- notes
- permissions

---

# Scenario

Scénář, ze kterého kapitola vznikla.

Obsahuje:

- název
- text scénáře
- autorovy pocity
- datum vytvoření

---

# Participants

Oba partneři.

Každý účastník obsahuje:

- uid
- přezdívku
- vlastní pocity
- historii příspěvků

---

# Experiences

Nejdůležitější část kapitoly.

Každé splnění scénáře vytvoří nový prožitek.

Jeden RelationshipChapter může obsahovat neomezený počet prožitků.

Každý prožitek obsahuje:

- datum
- fotografie
- videa
- hlasové zprávy
- pocity autora
- pocity partnera
- poznámky

---

# Timeline

Kompletní historie kapitoly.

Například:

- scénář vytvořen
- partner reagoval
- kapitola vznikla
- scénář splněn
- přidána fotografie
- přidána poznámka
- další společný prožitek

Timeline se nikdy nemaže.

---

# Notes

Dodatečné poznámky obou partnerů.

Mohou být přidávány kdykoliv.

---

# Permissions

Kapitola patří oběma partnerům.

Důležité změny musí potvrdit oba.

Editace probíhá přes schvalovací proces.

---

# Security

Aplikace bude podporovat:

- PIN
- Face ID
- Otisk prstu

---

# Základní pravidla

RelationshipChapter nikdy nekončí.

Kapitola se může kdykoliv znovu otevřít.

Partner může:

- znovu splnit scénář
- přidat nové fotografie
- přidat nové video
- přidat nové poznámky
- přidat nové pocity

Každé nové splnění vytvoří nový Experience.

Relationship Book tak přirozeně roste společně se vztahem.

---

# Motto

Neprožíváme proto, abychom zapisovali.

Zapisujeme proto, abychom mohli znovu prožívat.