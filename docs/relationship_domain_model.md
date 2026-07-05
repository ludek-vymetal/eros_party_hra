# ❤️ Relationship Domain Model

## Filosofie

Relationship Book představuje digitální kroniku společného života.

Nejde o seznam scénářů.

Nejde o deník.

Nejde o galerii.

Je to živá kniha společných příběhů.

Každý příběh se může celý život rozšiřovat.

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

# RelationshipBook

Představuje celou knihu.

Obsahuje:

- seznam kapitol
- statistiky
- obsah knihy
- časovou osu vztahu

---

# RelationshipChapter

Jedna kapitola knihy.

Vzniká automaticky.

Nikdy nevzniká ručně.

Jedna kapitola představuje jeden společný příběh.

---

# Scenario

Scénář, který kapitolu založil.

---

# Participants

Oba partneři.

---

# Experiences

Každé opakované splnění scénáře vytvoří nový prožitek.

Prožitků může být neomezeně.

---

# Media

Fotografie

Video

Hlasové zprávy

---

# Timeline

Historie celé kapitoly.

---

# Notes

Dodatečné poznámky.

---

# Permissions

Společné vlastnictví kapitoly.

Editace důležitých údajů vyžaduje souhlas obou partnerů.

---

# Security

PIN

Face ID

Otisk prstu