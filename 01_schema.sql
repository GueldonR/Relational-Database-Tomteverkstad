USE tomteverkstad;

CREATE TABLE barn (
    Pnr char(14), 
    Fnamn VARCHAR(20),
    Enamn VARCHAR(20),
    
    FodelseAR year NOT NULL, -- anges i beskrivningen att det krävs för registrering. Namnet är inte alltid unikt ensamt. kommer sökas på för att avgöra att det är under 17 och över 1. 
    
    status_kommentar enum ('Aktiv', 'Saknar klassificering') default 'Aktiv', -- Aktiv indikerar att de har en underklass och motsatsen indikerar ingen underklass.
    
    PRIMARY KEY (Pnr, Fnamn, Enamn), 
	CHECK (Pnr RLIKE '^[0-9]{4}[0-9]{6}[0-9]{4}$') -- kollar format på barnPnr enl uppgiftsbeskrivningen

) ENGINE=InnoDB;

-- tabell för barnens relationer till andra barn. 
CREATE TABLE barn_vanskap (
    Pnr1 CHAR(14),
    Fnamn1 VARCHAR(20),
    Enamn1 VARCHAR(20),
    Pnr2 CHAR(14),
    Fnamn2 VARCHAR(20),
    Enamn2 VARCHAR(20),
    
    PRIMARY KEY (Pnr1, Fnamn1, Enamn1, Pnr2, Fnamn2, Enamn2),
    
    FOREIGN KEY (Pnr1, Fnamn1, Enamn1) REFERENCES barn (Pnr, Fnamn, Enamn),
    FOREIGN KEY (Pnr2, Fnamn2, Enamn2) REFERENCES barn (Pnr, Fnamn, Enamn)
) ENGINE=InnoDB;


CREATE TABLE snalltBarn (
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
        
    PRIMARY KEY (barnPnr, barnFnamn, barnEnamn),
    FOREIGN KEY (barnPnr, barnFnamn, barnEnamn) REFERENCES barn (Pnr, Fnamn, Enamn)
) ENGINE=InnoDB;


-- kodeifierad tabell för mindre snälla barn nedan. 
CREATE TABLE olydighetSkala (
    skala tinyint 
    CHECK (skala BETWEEN 0 AND 114), -- antagande kommer göras att rött är olydigt och därmed är 114 max olydighet. 
    fargskala varchar (14),
    PRIMARY KEY (skala)
) ENGINE=InnoDB;


CREATE TABLE MindreSnalltBarn (
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
    
    olydigNivA tinyint , --  kodifieras ovan. 
    trackingNr VARCHAR(20), -- trackingnr antas ha formatet av alfanr. Fickvarchar 20 då mängden julklappar ökar och då måste trackingnummrena vara flexibla och kunna öka. 
    
    PRIMARY KEY (barnPnr, barnFnamn, barnEnamn),
    FOREIGN KEY (barnPnr, barnFnamn, barnEnamn) REFERENCES barn (Pnr, Fnamn, Enamn), 
    FOREIGN KEY (olydigNivA) REFERENCES olydighetSkala (skala)
) ENGINE=InnoDB;

-- tabell för loggning av utförda sysslor av snälla barn. 
CREATE TABLE sysslorLogg (
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
    
    syssla VARCHAR(20), -- vilken syssla utfördes
    sysslaTidDatumFardig datetime, -- när utfördes sysslan
    
	genomForande ENUM('Undermåligt', 'Klåparmässigt', 'Klantigt', 'Lyckat'), -- lades till enligt beskrivning 

    PRIMARY KEY (barnPnr, barnFnamn, barnEnamn, syssla, sysslaTidDatumFardig),  
    FOREIGN KEY (barnPnr, barnFnamn, barnEnamn) REFERENCES snalltBarn (barnPnr, barnFnamn, barnEnamn)
) ENGINE=InnoDB;


CREATE TABLE tomteNisse  (
    Namn VARCHAR(20) NOT NULL UNIQUE, -- Constraint: så att namnet är unikt enligt uppg beskrivningen.  
    ID CHAR(23), 
    
    russin int, 
    notter int, 
    
    barackNr tinyint, -- valdes för prestanda och för att det rimligtvis är max 255st baracker 
    sangNr smallint, -- vet ej hur mycket en barrack rymmer, men för att akkomodera arbetare för hela världens juklappar kommer small int väljas.  
    PRIMARY KEY (ID), 
    
    CHECK (ID REGEXP '^[0-9]{6}[-/][0-9]{4}[-/][0-9]{1}[-/][0-9]{9}$') -- kollarformat enl uppgiftsbeskrivningen
    
) ENGINE=InnoDB;

CREATE TABLE InformatorNisse (
    NisseID CHAR(23),
    Funktion VARCHAR(30), -- Datatyp för att beskriva rollen 
    MossFarg VARCHAR(15), -- Datatyp för att beskriva färgen på mössan, lägg constraint för färgen röd. 

    PRIMARY KEY (NisseID), -- Nisse ID antas vara primärnyckel 
	FOREIGN KEY (NisseID) REFERENCES tomteNisse (ID), 
    CHECK (MossFarg NOT RLIKE 'röd|crimson|merlot')
    
) ENGINE=InnoDB;

 
CREATE TABLE inspelning (
    tidsstampel TIMESTAMP,
    
	barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
    NisseID CHAR(23),
    
    barn_om_Pnr CHAR(14), -- barnet som inspelningen handlar om / subjektet
    barn_om_Fnamn VARCHAR(20),
    barn_om_Enamn VARCHAR(20),
    
    beskrivning VARCHAR(20), -- görs av barnet 
    kvalitetsVarde tinyint, -- ska ingå i en uträkning
    filNamn VARCHAR (50), -- kanske uttöka pga av meningsstorlek, kan vara längre. 
    beskrivandeText VARCHAR(50), -- görs av informatören      
    
    PRIMARY KEY (tidsstampel, barnPnr, barnFnamn, barnEnamn, NisseID),
    
    FOREIGN KEY (barnPnr, barnFnamn, barnEnamn) REFERENCES barn (Pnr, Fnamn, Enamn), -- koppling till barn
	FOREIGN KEY (barn_om_Pnr, barn_om_Fnamn, barn_om_Enamn) REFERENCES barn (Pnr, Fnamn, Enamn), -- koppling till barnet som är subjektet i inspelningen
	FOREIGN KEY (NisseID) REFERENCES InformatorNisse (NisseID), -- direkt koppling till informator
    
	CHECK (kvalitetsVarde BETWEEN 1 AND 10) -- kollar så att kvalitetsvärdet är i spannet av 1-10, viktigt för indexeringen. 

) ENGINE=InnoDB;

-- tabell för loggning av korrekta inserts i inspelningtabellen. 
CREATE TABLE inspelning_insert_logg (
    anv_namn varchar (40),
    operation varchar (20), 
    ins_dat_logg datetime, 
    
	inspelningens_tidsstampel TIMESTAMP,
	barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
	NisseID CHAR(23),

	beskrivning VARCHAR(20), -- görs av barnet 
    barn_om_Pnr CHAR(14), -- barnet som inspelningen handlar om
    barn_om_Fnamn VARCHAR(20),
    barn_om_Enamn VARCHAR(20),
    
    kvalitetsVarde tinyint, -- ska ingå i en uträkning
    
    
    filNamn VARCHAR (50) 
) ENGINE=InnoDB;

-- medalj för informatörnissen 
CREATE TABLE Medalj (
    NisseID CHAR(23),
    serieNr char(4), -- implementerade alfanumeriskt nummer för att kunna ha flera unika loggar av medaljer
    Medaljnamn ENUM('Guldmössan', 'Blå knappen', 'Det Gyldene Russinet'),
    PRIMARY KEY (NisseID, serieNr),
	FOREIGN KEY (NisseID) REFERENCES InformatorNisse (NisseID)   
) ENGINE=InnoDB;

-- Vertikal split, av leverans status, på merge av önskelista och listrad. 
-- //
CREATE TABLE ejLevererad_onskeListRader (
    arTal year, 
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
    -- medGivande = irrelevant då handläggare avgränsas
    radNr tinyint, 
    antal tinyint,
    
	PRIMARY KEY (arTal, barnPnr, barnFnamn, barnEnamn , radNr),
	FOREIGN KEY ( barnPnr, barnFnamn, barnEnamn) REFERENCES barn (Pnr, Fnamn, Enamn)

) ENGINE=InnoDB;

CREATE TABLE levererade_onskeListRader (
    arTal year, 
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
    radNr tinyint, 
    antal tinyint,
    
	PRIMARY KEY (arTal, barnPnr, barnFnamn, barnEnamn , radNr),
	FOREIGN KEY ( barnPnr, barnFnamn, barnEnamn) REFERENCES barn (Pnr, Fnamn, Enamn)

) ENGINE=InnoDB;

-- horisontell split // undviker att kommentarer lagras för varje kolumn. 
-- enligt uppgiftsbeskrivningen lagras en kommentar 'då och då' för varje önskelistrad
CREATE TABLE listRad_kommentar (
    arTal year, 
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
    radNr tinyint, 
    
    Kommentar varchar (50), 
    -- "Mindre färgskiftning i målning, Otydlig markering."
	beskrivning varchar (50),     
    -- barnens beskrivning! 

	PRIMARY KEY (arTal, barnPnr, barnFnamn, barnEnamn, radNr)
) ENGINE=InnoDB;

-- loggar när önskelistor flyttas från levererade till ej levererade. 
CREATE TABLE leveransLogg (
	anv_namn varchar (40),
    operation char (6), 
    arTal year, 
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20),
    radNr tinyint, 
    antal tinyint, 
    
    Lev_datum_Logg datetime
) ENGINE=InnoDB;

-- loggar ev förändringar i barnets 'Underklass'/'arv'
CREATE TABLE Barn_status_logg (
    barnPnr CHAR(14),
    barnFnamn VARCHAR(20),
    barnEnamn VARCHAR(20), -- barnens identifierare 
    
    borttagenTid datetime, 
    operation char (25), 
    anv varchar (40) -- loggvärden 
) ENGINE=InnoDB;