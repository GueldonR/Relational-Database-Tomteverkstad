# DTB Konstruktion - SQL

This project is part of an assignment focused on designing and implementing a relational database. The goal is to create a database implementation based on a described domain, in this case "Santas Workshop". Including data related to children, their activities, and interactions with Santa's helpers (Tomtenisse). The database showcases features such as:

- **Tables**
- **Constraints**
- **Triggers**
- **Relationships**
- **Stored Procedures**
- **Virtual tables**
- **Premission handling**

## Purpose

The assignment demonstrates skills in database design, SQL programming, and data management. It showcases the ability to create a normalized schema, with strategic denormalization for preformance, enforce data integrity, and implement advanced SQL features like triggers and constraints.

## Schema

```mermaid
erDiagram
    barn {
        char Pnr PK
        varchar Fnamn PK
        varchar Enamn PK
        year FodelseAR
        enum status_kommentar
    }
    barn_vanskap {
        char Pnr1 PK, FK
        varchar Fnamn1 PK, FK
        varchar Enamn1 PK, FK
        char Pnr2 PK, FK
        varchar Fnamn2 PK, FK
        varchar Enamn2 PK, FK
    }
    snalltBarn {
        char barnPnr PK, FK
        varchar barnFnamn PK, FK
        varchar barnEnamn PK, FK
    }
    olydighetSkala {
        tinyint skala PK
        varchar fargskala
    }
    MindreSnalltBarn {
        char barnPnr PK, FK
        varchar barnFnamn PK, FK
        varchar barnEnamn PK, FK
        tinyint olydigNivA FK
        varchar trackingNr
    }
    sysslorLogg {
        char barnPnr PK, FK
        varchar barnFnamn PK, FK
        varchar barnEnamn PK, FK
        varchar syssla PK
        datetime sysslaTidDatumFardig PK
        enum genomForande
    }
    tomteNisse {
        char ID PK
        varchar Namn UK
        int russin
        int notter
        tinyint barackNr
        smallint sangNr
    }
    InformatorNisse {
        char NisseID PK, FK
        varchar Funktion
        varchar MossFarg
    }
    inspelning {
        timestamp tidsstampel PK
        char barnPnr PK, FK
        varchar barnFnamn PK, FK
        varchar barnEnamn PK, FK
        char NisseID PK, FK
        char barn_om_Pnr FK
        varchar barn_om_Fnamn FK
        varchar barn_om_Enamn FK
        varchar beskrivning
        tinyint kvalitetsVarde
        varchar filNamn
        varchar beskrivandeText
    }
    Medalj {
        char NisseID PK, FK
        char serieNr PK
        enum Medaljnamn
    }
    ejLevererad_onskeListRader {
        year arTal PK
        char barnPnr PK, FK
        varchar barnFnamn PK, FK
        varchar barnEnamn PK, FK
        tinyint radNr PK
        tinyint antal
    }
    levererade_onskeListRader {
        year arTal PK
        char barnPnr PK, FK
        varchar barnFnamn PK, FK
        varchar barnEnamn PK, FK
        tinyint radNr PK
        tinyint antal
    }
    listRad_kommentar {
        year arTal PK
        char barnPnr PK
        varchar barnFnamn PK
        varchar barnEnamn PK
        tinyint radNr PK
        varchar Kommentar
        varchar beskrivning
    }

    barn ||--o{ barn_vanskap : "barn1"
    barn ||--o{ barn_vanskap : "barn2"
    barn ||--o| snalltBarn : "klassas som"
    barn ||--o| MindreSnalltBarn : "klassas som"
    olydighetSkala ||--o{ MindreSnalltBarn : graderar
    snalltBarn ||--o{ sysslorLogg : loggar
    barn ||--o{ inspelning : "spelas in av"
    barn ||--o{ inspelning : "är subjekt i"
    InformatorNisse ||--o{ inspelning : registrerar
    tomteNisse ||--o| InformatorNisse : specialiserar
    InformatorNisse ||--o{ Medalj : tilldelas
    barn ||--o{ ejLevererad_onskeListRader : önskar
    barn ||--o{ levererade_onskeListRader : önskar
```

`leveransLogg`, `Barn_status_logg` and `inspelning_insert_logg` are audit tables populated by triggers rather than declared foreign keys, so they're left out of the diagram above for readability.

## How to Use

1. Run the SQL script `Databasimplementation.sql` to set up the database.
2. Explore the schema and test the triggers and constraints by performing operations like inserts, updates, and deletes.

Have fun!
