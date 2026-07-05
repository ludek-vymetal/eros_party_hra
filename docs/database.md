# firestore + DB


partner_scenarios

partner_reactions

relationship_book

community_tasks

community_scenarios

# Relationship Book

## Collection

relationship_book

Jedna kapitola představuje jednu společnou vzpomínku dvou partnerů.

Každá kapitola je sdílená mezi oběma partnery.

Scénář je pouze začátek kapitoly.

Později může obsahovat fotografie, poznámky, výročí a další společné vzpomínky.
id

ownerUid

partnerUid

parentScenarioId

chapterTitle

introduction

scenarioTitle

scenarioText

senderFeeling

receiverFeeling

senderEmotion

receiverEmotion

photos

favorite

createdAt

updatedAt
## Model

RelationshipChapter

├── MemoryScenario
├── MemoryParticipant (author)
├── MemoryParticipant (partner)
├── MemoryMedia
### MemoryScenario

- id
- parentScenarioId
- title
- text
- createdAt
### MemoryParticipant

- uid
- feeling
- emotion
- createdAt
- updatedAt
### MemoryMedia

- photos[]
- videos[]
- voiceMessages[]
