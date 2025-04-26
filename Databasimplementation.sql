DROP DATABASE a23guero;
CREATE DATABASE a23guero;
USE a23guero;

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

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TRIGGERS
-- trigger 1 (g): 
Delimiter //
CREATE TRIGGER logg_borttagning_ejlev after delete on ejLevererad_onskeListRader 
for each row begin 

insert into leveransLogg (anv_namn, operation, arTal, barnPnr, barnFnamn, barnEnamn, radNr, antal, Lev_datum_Logg)
values (user(), "DELETE", old.arTal, old.barnPnr, old.barnFnamn, old.barnEnamn, old.radNr, old.antal, now());

END //
Delimiter ;

-- trigger 2 (g): 
Delimiter //
CREATE TRIGGER logg_insert_lev before insert on levererade_onskeListRader 
for each row begin 
insert into leveransLogg (anv_namn, operation, arTal, barnPnr, barnFnamn, barnEnamn, radNr, antal, Lev_datum_Logg)
values (user(), "INSERT", New.arTal, new.barnPnr, new.barnFnamn, new.barnEnamn, new.radNr, new.antal, now());
END //
Delimiter ;

-- testkommandon - Trigger 1&2
select * from leveransLogg;

-- trigger 3 (VG): 
DELIMITER //

CREATE TRIGGER logg_borttagning_mindreSnalltBarn
before DELETE ON MindreSnalltBarn
FOR EACH ROW
BEGIN
    -- Logga borttagningen i en loggtabell (exempelvis snalltBarn_logg)
    INSERT INTO Barn_status_logg (
        barnPnr, 
        barnFnamn, 
        barnEnamn, 
        borttagenTid,
        operation,
        anv
    ) 
    VALUES (
        OLD.barnPnr, 
        OLD.barnFnamn, 
        OLD.barnEnamn, 
        NOW(),
        'DELETED FROM snalltBarn', 
        user ()
    );

    -- Uppdatera barnets status i barn-tabellen
    UPDATE barn
    SET status_kommentar = 'Saknar klassificering'
    WHERE Pnr = OLD.barnPnr 
      AND Fnamn = OLD.barnFnamn 
      AND Enamn = OLD.barnEnamn;
END //

DELIMITER ;

-- test kommandon - Trigger 3
select * from MindreSnalltBarn;
select * from Barn_status_logg;
select * from barn;

-- trigger 4 (VG): 
DELIMITER //

CREATE TRIGGER satt_mp4_postfix_och_logga_inspelning
BEFORE INSERT ON inspelning
FOR EACH ROW
BEGIN
    -- Kolla om filnamnet inte slutar på '.mp4'
    if right (new.filNamn, 4) != '.mp4' then
        -- Lägg till '.mp4' till filnamnet
        set new.filNamn = CONCAT(new.filNamn, '.mp4');
    end IF;
    
    -- logga alla insättningar av inspelningar 
    insert into inspelning_insert_logg (
            anv_namn, 
            operation, 
            ins_dat_logg, 
            
            inspelningens_tidsstampel,
            barnPnr, 
            barnFnamn, 
            barnEnamn, 
            barn_om_Pnr, 
            barn_om_Fnamn, 
            barn_om_Enamn,
            
			NisseID,
			beskrivning, -- görs av barnet 	
            kvalitetsVarde,
            filNamn
    ) 
    values (
        USER(), 
            'INSERT', 
            NOW(), 
            new.tidsstampel,
            NEW.barnPnr, 
            NEW.barnFnamn, 
            NEW.barnEnamn, 
            NEW.barn_om_Pnr, 
            NEW.barn_om_Fnamn, 
            NEW.barn_om_Enamn, 
			NEW.NisseID,
			NEW.beskrivning,-- görs av barnet
            NEW.kvalitetsVarde, -- loggas pga uträkning
            NEW.filNamn
    );
    
    -- ifall barnen har samma nyckel kan inte inspelning göras 
    IF NEW.barnPnr = NEW.barn_om_Pnr and NEW.barnFnamn=new.barn_om_Fnamn and NEW.barnEnamn=new.barn_om_Enamn 
    THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Barn kan inte spela in om sig själv';
    END IF;
END //

DELIMITER ;



select * from inspelning_insert_logg;
select * from inspelning; 
-- felatig insättning för test - duplikat av anna som barn och subjekt
INSERT INTO inspelning (tidsstampel, barnPnr, barnFnamn, barnEnamn, barn_om_Pnr, barn_om_Fnamn, barn_om_Enamn, NisseID, beskrivning, kvalitetsVarde, filNamn, beskrivandeText) VALUES
('2023-12-01 10:15:00', '00011234560110', 'Anna', 'Andersson', '00011234560110', 'Anna', 'Andersson' , '202209-0520-1-987654321', 'mdasdisid', '1', 'test', 'ska inte lagras');



-- ------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INSERTS
INSERT INTO barn (Pnr, Fnamn, Enamn, FodelseAR) VALUES 
('00011234560110', 'Anna', 'Andersson', 2010),
('00022345670211', 'Bertil', 'Bergström', 2011),
('00033456780312', 'Cecilia', 'Carlsson', 2012),
('00044567890413', 'David', 'Dahl', 2013),
('00055678900414', 'Eva', 'Eriksson', 2014),
('00066789010515', 'Freja', 'Falk', 2015),

('00077890120516', 'Gustav', 'Gustafsson', 2016),
('00088901230617', 'Hanna', 'Hansson', 2017),
('00099012340718', 'Isak', 'Ivarsson', 2018),
('00100123450819', 'Jasmine', 'Jönsson', 2019);

INSERT INTO tomteNisse (Namn, ID, russin, notter, barackNr, sangNr) VALUES
('Tomtenisse1', '202209-0520-1-987654321', 100, 50, 3, 25),
('Tomtenisse2', '202209-0720-2-123456789', 150, 70, 2, 30), 

('Tomtenisse3', '301107-1886-3-234567890', 120, 60, 1, 15),
('Tomtenisse4', '401208-1882-4-345678901', 130, 55, 4, 10),
('Tomtenisse5', '501309-1883-5-456789012', 110, 65, 2, 20),
('Tomtenisse6', '601410-1884-1-567890123', 140, 75, 3, 5),

('Tomtenisse7', '701511-1885-2-678901234', 160, 80, 1, 35),
('Tomtenisse8', '801612-1886-3-789012345', 90, 45, 4, 40),
('Tomtenisse9', '901713-1887-4-890123456', 170, 85, 2, 8),
('Tomtenisse10', '101814-1888-5-901234567', 180, 90, 3, 12);


INSERT INTO InformatorNisse (NisseID, Funktion, MossFarg) VALUES
('202209-0520-1-987654321', 'Avdelningschef', 'grön'),
('202209-0720-2-123456789', 'Admin', 'blå'), 

('701511-1885-2-678901234', 'Kaffe', 'grön'),
('801612-1886-3-789012345', 'Analytiker', 'blå'),
('901713-1887-4-890123456', 'Backend', 'gul'),
('101814-1888-5-901234567', 'Julstämningskoordinator', 'vit');


INSERT INTO barn_vanskap (Pnr1, Fnamn1, Enamn1, Pnr2, Fnamn2, Enamn2) VALUES
('00011234560110', 'Anna', 'Andersson', '00022345670211', 'Bertil', 'Bergström'),
('00022345670211', 'Bertil', 'Bergström', '00033456780312', 'Cecilia', 'Carlsson'),
('00011234560110', 'Anna', 'Andersson', '00033456780312', 'Cecilia', 'Carlsson'), 
-- lades in nyligen dubbelkolla
('00044567890413', 'David', 'Dahl', '00055678900414', 'Eva', 'Eriksson'),
('00066789010515', 'Freja', 'Falk', '00077890120516', 'Gustav', 'Gustafsson'),
('00088901230617', 'Hanna', 'Hansson', '00099012340718', 'Isak', 'Ivarsson'),
('00100123450819', 'Jasmine', 'Jönsson', '00011234560110', 'Anna', 'Andersson'),
('00033456780312', 'Cecilia', 'Carlsson', '00055678900414', 'Eva', 'Eriksson'),
('00044567890413', 'David', 'Dahl', '00077890120516', 'Gustav', 'Gustafsson'),
('00066789010515', 'Freja', 'Falk', '00099012340718', 'Isak', 'Ivarsson'),
('00088901230617', 'Hanna', 'Hansson', '00022345670211', 'Bertil', 'Bergström'),
('00100123450819', 'Jasmine', 'Jönsson', '00044567890413', 'David', 'Dahl'),
('00055678900414', 'Eva', 'Eriksson', '00077890120516', 'Gustav', 'Gustafsson');


INSERT INTO snalltBarn (barnPnr, barnFnamn, barnEnamn) VALUES
('00011234560110', 'Anna', 'Andersson'),
('00022345670211', 'Bertil', 'Bergström'), 

('00044567890413', 'David', 'Dahl'),
('00055678900414', 'Eva', 'Eriksson'),
('00066789010515', 'Freja', 'Falk');

INSERT INTO olydighetSkala (skala, fargskala) VALUES
(0, 'grön'), (1, 'grön'), (2, 'grön'), (3, 'grön'), (4, 'grön'), (5, 'grön'),
(6, 'grön'), (7, 'grön'), (8, 'grön'), (9, 'grön'), (10, 'grön'), (11, 'grön'),
(12, 'grön'), (13, 'grön'), (14, 'grön'), (15, 'grön'), (16, 'grön'), (17, 'grön'),
(18, 'grön'), (19, 'grön'), (20, 'grön'), (21, 'grön'), (22, 'grön'), (23, 'grön'),
(24, 'grön'), (25, 'grön'), (26, 'grön'), (27, 'grön'), (28, 'grön'), (29, 'grön'),
(30, 'grön'), (31, 'grön'), (32, 'grön'), (33, 'grön'), (34, 'grön'), (35, 'grön'),
(36, 'grön'), (37, 'grön'), (38, 'grön'),

(39, 'gul'), (40, 'gul'), (41, 'gul'), (42, 'gul'), (43, 'gul'), (44, 'gul'),
(45, 'gul'), (46, 'gul'), (47, 'gul'), (48, 'gul'), (49, 'gul'), (50, 'gul'),
(51, 'gul'), (52, 'gul'), (53, 'gul'), (54, 'gul'), (55, 'gul'), (56, 'gul'),
(57, 'gul'), (58, 'gul'), (59, 'gul'), (60, 'gul'), (61, 'gul'), (62, 'gul'),
(63, 'gul'), (64, 'gul'), (65, 'gul'), (66, 'gul'), (67, 'gul'), (68, 'gul'),
(69, 'gul'), (70, 'gul'), (71, 'gul'), (72, 'gul'), (73, 'gul'), (74, 'gul'),
(75, 'gul'), (76, 'gul'),

(77, 'röd'), (78, 'röd'), (79, 'röd'), (80, 'röd'), (81, 'röd'), (82, 'röd'),
(83, 'röd'), (84, 'röd'), (85, 'röd'), (86, 'röd'), (87, 'röd'), (88, 'röd'),
(89, 'röd'), (90, 'röd'), (91, 'röd'), (92, 'röd'), (93, 'röd'), (94, 'röd'),
(95, 'röd'), (96, 'röd'), (97, 'röd'), (98, 'röd'), (99, 'röd'), (100, 'röd'),
(101, 'röd'), (102, 'röd'), (103, 'röd'), (104, 'röd'), (105, 'röd'), (106, 'röd'),
(107, 'röd'), (108, 'röd'), (109, 'röd'), (110, 'röd'), (111, 'röd'), (112, 'röd'),
(113, 'röd'), (114, 'röd');

INSERT INTO MindreSnalltBarn (barnPnr, barnFnamn, barnEnamn, olydigNivA, trackingNr) VALUES 
('00033456780312', 'Cecilia', 'Carlsson', 50, 'TRK1234567890'),

('00077890120516', 'Gustav', 'Gustafsson', 10, 'TRK1234567891'),
('00088901230617', 'Hanna', 'Hansson', 100, 'TRK1234567892'),
('00099012340718', 'Isak', 'Ivarsson', 10, 'TRK1234567893'),
('00100123450819', 'Jasmine', 'Jönsson', 50, 'TRK1234567894');

DELETE FROM MindreSnalltBarn 
WHERE barnPnr = '00100123450819' 
AND barnFnamn = 'Jasmine' 
AND barnEnamn = 'Jönsson';

INSERT INTO sysslorLogg (barnPnr, barnFnamn, barnEnamn, syssla, sysslaTidDatumFardig, genomForande) VALUES
('00011234560110', 'Anna', 'Andersson', 'Städarummet', '2022-12-01 08:15:00', 'Lyckat'),

('00022345670211', 'Bertil', 'Bergström', 'Gå ut med hunden', '2022-12-01 08:15:00', 'Lyckat'),
('00022345670211', 'Bertil', 'Bergström', 'Gå ut med frugan', '2021-12-01 09:15:00', 'Undermåligt'),
('00022345670211', 'Bertil', 'Bergström', 'Gå ut till frugan', '2022-12-01 11:15:00', 'Undermåligt'),
('00022345670211', 'Bertil', 'Bergström', 'Gå ut till fruga2', '2019-12-01 12:15:00', 'Undermåligt'),
('00044567890413', 'David', 'Dahl', 'Bädda sängen', '2017-12-01 10:00:00', 'Lyckat'),
('00044567890413', 'David', 'Dahl', 'Läsa en bok', '2019-12-01 10:15:00', 'Klåparmässigt'),
('00055678900414', 'Eva', 'Eriksson', 'Hjälpa till i köket', '2023-12-01 10:15:00', 'Klantigt'),
('00066789010515', 'Freja', 'Falk', 'Sortera tvätten', '2023-12-01 10:15:00', 'Lyckat'),
('00066789010515', 'Freja', 'Falk', 'Sortera tvätten1', '2023-12-01 10:15:00', 'Lyckat'),
('00066789010515', 'Freja', 'Falk', 'Gå ut med hunden', '2023-12-01 10:15:00', 'Klåparmässigt');

INSERT INTO inspelning (tidsstampel, barnPnr, barnFnamn, barnEnamn, barn_om_Pnr, barn_om_Fnamn, barn_om_Enamn, NisseID, beskrivning, kvalitetsVarde, filNamn, beskrivandeText) VALUES
('2023-12-01 10:15:00', '00011234560110', 'Anna', 'Andersson', '00022345670211', 'Bertil', 'Bergström' , '202209-0520-1-987654321', 'Sånguppträdande', '1', 'upptradande', 'Mycket bra!'),


-- test 
('2023-12-02 14:20:00', '00022345670211', 'Bertil', 'Bergström', '00033456780312', 'Cecilia', 'Carlsson' , '202209-0720-2-123456789', 'Presentpackning', '10', 'packning', 'Bra jobbat.'),
('2010-12-02 14:30:00', '00022345670211', 'Bertil', 'Bergström', '00033456780312', 'Cecilia', 'Carlsson' , '202209-0720-2-123456789', 'Hon sågade mitt träd', '1', 'packning', 'Bra jobbat.'),
('2010-12-02 14:30:12', '00022345670211', 'Bertil', 'Bergström', '00033456780312', 'Cecilia', 'Carlsson' , '202209-0720-2-123456789', 'Hon slog mig', '1', 'packning.m', 'Bra jobbat.'),

('2014-12-01 19:00:00', '00100123450819', 'Jasmine', 'Jönsson', '00044567890413', 'David', 'Dahl'  ,'101814-1888-5-901234567', 'Badadenaken', null , 'dekoration', 'Varför?.'),



('2022-12-01 15:30:00', '00077890120516', 'Gustav', 'Gustafsson', '00066789010515', 'Freja', 'Falk' , '701511-1885-2-678901234', 'Elak syster', '10', 'packning', 'Perfekt'), 

('2022-11-25 09:10:00', '00033456780312', 'Cecilia', 'Carlsson', '00055678900414', 'Eva', 'Eriksson' , '801612-1886-3-789012345', 'Julpyssel', '7', 'julpyssel.mp4', 'Väldigt fint.'),
('2021-10-14 11:25:00', '00044567890413', 'David', 'Dahl', '00077890120516', 'Gustav', 'Gustafsson' , '901713-1887-4-890123456', 'Baka pepparkakor', '8', 'bakning.mp4', 'Väldigt gott.'),
('2020-09-05 13:40:00', '00055678900414', 'Eva', 'Eriksson', '00077890120516', 'Gustav', 'Gustafsson' ,'101814-1888-5-901234567', 'Julsång', '9', 'sång.mp4', 'Fantastisk sång!'),
('2019-08-20 14:50:00', '00066789010515', 'Freja', 'Falk', '00077890120516', 'Gustav', 'Gustafsson' , '202209-0520-1-987654321', 'Pyssel', '6', 'pyssel.mp4', 'Bra insats.'),
('2018-07-11 15:00:00', '00077890120516', 'Gustav', 'Gustafsson', '00055678900414', 'Eva', 'Eriksson' ,'701511-1885-2-678901234', 'Dans', '10', 'dans.mp4', 'Perfekt rörelse.'),
('2017-06-03 16:15:00', '00088901230617', 'Hanna', 'Hansson', '00022345670211', 'Bertil', 'Bergström' , '801612-1886-3-789012345', 'Målning', '8', 'målning.mp4', 'Väldigt kreativt.'),
('2016-05-22 17:30:00', '00099012340718', 'Isak', 'Ivarsson', '00066789010515', 'Freja', 'Falk' , '901713-1887-4-890123456', 'Kakbakning', '7', 'kakbakning.mp4', 'Väldigt välsmakande.'),
('2015-04-11 18:45:00', '00100123450819', 'Jasmine', 'Jönsson', '00044567890413', 'David', 'Dahl'  ,'101814-1888-5-901234567', 'Julgransdekoration', '9', 'korv.mp4', 'Utmärkt utfört.');



INSERT INTO Medalj (NisseID, serieNr, Medaljnamn) VALUES
-- fler inserts kan göras. 
('202209-0520-1-987654321', 'AB12',  'Guldmössan'),
('202209-0720-2-123456789', 'CD34', 'Blå knappen'), 

('202209-0520-1-987654321', 'AB13',  'Blå knappen'),
('202209-0720-2-123456789', 'CD35', 'Guldmössan');


INSERT INTO ejLevererad_onskeListRader (arTal, barnPnr, barnFnamn, barnEnamn, radNr, antal) VALUES
(2023, '00011234560110', 'Anna', 'Andersson', 1, 2),
(2023, '00022345670211', 'Bertil', 'Bergström', 2, 1),

(2021, '00011234560110', 'Anna', 'Andersson', 1, 1),
(2020, '00022345670211', 'Bertil', 'Bergström', 4, 10),
(2020, '00044567890413', 'David', 'Dahl', 39, 10), 
(2018, '00044567890413', 'David', 'Dahl', 39, 12);

INSERT INTO levererade_onskeListRader (arTal, barnPnr, barnFnamn, barnEnamn, radNr, antal) VALUES
(2022, '00033456780312', 'Cecilia', 'Carlsson', 1, 3),
(2022, '00011234560110', 'Anna', 'Andersson', 2, 5),
(2018, '00011234560110', 'Anna', 'Andersson', 1, 3),
(2019, '00022345670211', 'Bertil', 'Bergström', 2, 4),
(2020, '00033456780312', 'Cecilia', 'Carlsson', 3, 5),
(2021, '00044567890413', 'David', 'Dahl', 4, 6),
(2022, '00055678900414', 'Eva', 'Eriksson', 5, 2),
(2023, '00066789010515', 'Freja', 'Falk', 6, 7),
(2019, '00077890120516', 'Gustav', 'Gustafsson', 7, 1),
(2020, '00088901230617', 'Hanna', 'Hansson', 8, 8),
(2021, '00099012340718', 'Isak', 'Ivarsson', 9, 3),
(2022, '00100123450819', 'Jasmine', 'Jönsson', 10, 4);

INSERT INTO listRad_kommentar (arTal, barnPnr, barnFnamn, barnEnamn, radNr, Kommentar, beskrivning) VALUES
(2023, '00011234560110', 'Anna', 'Andersson', 1, 'Test för procedure 1', 'En testrad' ),
(2018, '00011234560110', 'Anna', 'Andersson', 1, 'Mindre färgskiftning i målning', 'Röd bil'),
(2019, '00022345670211', 'Bertil', 'Bergström', 2, 'Otydlig markering', 'Grön boll'),
(2022, '00033456780312', 'Cecilia', 'Carlsson', 1, 'Snabb leverans', 'Mustang');


-- indexering (lägg till en till ifall)

create index inspelningsKvalitet on inspelning(kvalitetsVarde asc) using btree;  
-- jag valde att indexera detta då det kommer användas i en uträkning för att se hur trovärdigt ett barn är. Därmed kommer detta efterfrågas en del.
show index from inspelning; -- kollar indexet som skapades


create index barnAlder on barn ( FodelseAR asc) using btree;  
show index from barn; -- kollar indexet som skapades

-- jag valde att indexera detta då barnen bör vara mellan 0-17 år för att kunna 'delta' i systemet. 


-- --------------------------------------------------------------------------------------------------


-- VYER
-- simplification 1
CREATE VIEW allaOnskelistor AS 
select * from ejLevererad_onskeListRader
union 
select * from levererade_onskeListRader;

select * from allaOnskelistor; 

-- simplification 2 
CREATE VIEW BarnSysslorSammanfattning AS
SELECT
  barnFnamn,
  barnEnamn,
  syssla as Syssla, 
  sysslaTidDatumFardig as Fardig,
  genomForande as Betyg
FROM
  sysslorLogg;
select * from BarnSysslorSammanfattning;

-- simplification 3 
-- visar vänskaper från ett tvåsidigt perspektiv. Därmed kommer man kunna söka på pnr1 och matcha det med person a vilket ger ALLA dess relaterade vänner. 
CREATE VIEW barnVanner AS
SELECT
    Pnr1 as Personnummer, 
    Fnamn1 as Fornamn, 
    Enamn1 as EfterNamn,
    Pnr2 as Kompisens_Personnummer,
    Fnamn2 as Kompisens_Fornamn, 
    Enamn2 as Kompisens_EfterNamn
FROM
    barn_vanskap
UNION
SELECT
    Pnr2 as Personnummer, 
    Fnamn2 as Fornamn, 
    Enamn2 as EfterNamn,
    Pnr1 as Kompisens_Personnummer,
    Fnamn1 as Kompisens_Fornamn, 
    Enamn1 as Kompisens_EfterNamn
FROM
    barn_vanskap;
    
select * from barnVanner;

-- Specialisation 1 
-- Räknar ut snälla barnens hjälpsamhetsvärde 
CREATE VIEW snallBarn_hjalpsamhet AS 
SELECT 
    barnPnr,
    barnFnamn,
    barnEnamn,
    COUNT(*) AS hjalpsamhetsvarde
FROM sysslorLogg
WHERE genomForande IN ('Klantigt', 'Lyckat')
GROUP BY barnPnr, barnFnamn, barnEnamn;
select * from snallBarn_hjalpsamhet; 


-- -------------------------------------------------------------------------------------------
-- STORED PROCEDURES: 
-- "(G) procedur1: enkel procedur, ta fram data när proceduren körs"
DELIMITER //

CREATE PROCEDURE hamta_inspelningar_Kvalitet (
IN Onskad_kvalitet_Inspelning tinyint
)
BEGIN
   select * 
   from inspelning 
   where kvalitetsVarde=Onskad_kvalitet_Inspelning;
END //

DELIMITER ;
call hamta_inspelningar_Kvalitet (10); 


--  procedur2: en procedur som tar emot en parameter och (tar fram data)/(tarbort data)/(förändrar data) med hjälp av parametern, tex alla fakturor äldre än inmatat datum och visar resultatet.

DELIMITER //
CREATE PROCEDURE hittaInspelningar (
IN BarnPersonnummer char(14), 
BarnFornamn varchar (20), 
BarnEternamn varchar (20)
)
BEGIN
	select 
    tidsstampel as Skickades,
    barnPnr as Personnummer, 
    barnFnamn as Fornamn, 
    barnEnamn as Efternamn, 
    -- exkluderar nisseid 
    barn_om_Fnamn as Kompis_Fornamn, 
    barn_om_Enamn as Kompis_Efternamn, 
    beskrivning as Beskrivning, 
    filNamn as Inspelning
    from inspelning 
    where barnPnr = BarnPersonnummer and barnFnamn = BarnFornamn and barnEnamn = BarnEternamn; 
END //

DELIMITER ;

CALL hittaInspelningar('00022345670211', 'Bertil', 'Bergström');


-- (VG) procedur3: samma som procedur2 men att även inkludera användandet av conditions (if/else) och vid fel - ge ett egenskapat felmeddelande
-- (Antas att ett barn registrerar sina egna sysslor.)
DELIMITER //
CREATE PROCEDURE sysslaRegg (
IN BarnPersonnummer char(14), 
BarnFornamn varchar (20), 
BarnEternamn varchar (20), 
sysslaNamn varchar (20), 
datumGjort datetime, 
nivaAv_utForande ENUM('Undermåligt', 'Klåparmässigt', 'Klantigt', 'Lyckat')
)
BEGIN 
Declare finnsSyssla tinyInt;

Select count(*) 
into finnsSyssla
from sysslorLogg 
where 
  barnPnr = BarnPersonnummer 
  AND barnFnamn = BarnFornamn
  AND barnEnamn = BarnEternamn 
  AND syssla = sysslaNamn
  AND sysslaTidDatumFardig = datumGjort
  AND genomForande = nivaAv_utForande;

IF (finnsSyssla = 0)

Then   
   INSERT INTO sysslorLogg (barnPnr, barnFnamn, barnEnamn, syssla, sysslaTidDatumFardig, genomForande)
   VALUES (BarnPersonnummer, BarnFornamn, BarnEternamn, sysslaNamn, datumGjort, nivaAv_utForande);

else 

	SIGNAL SQLSTATE '45000' 
	SET MESSAGE_TEXT = 'Den angivna sysslan existerar redan.';

end if; 

END //

DELIMITER ;

CALL sysslaRegg(
    '00011234560110', -- BarnPersonnummer
    'Anna',           -- BarnFornamn
    'Andersson',      -- BarnEternamn
    'Damma',   -- syssla 
    '2024-09-12 14:30:00', -- datumGjort 
    'Lyckat'          -- nivaAv_utForande
);

select * from sysslorLogg;


-- (VG) procedur4: en procedur som flyttar en tuppel från ena tabellen till den andra tabellen i din vertikala split
-- 
DELIMITER //

CREATE PROCEDURE levereraOnskelistRad(
IN Ej_betal_arTal year, 
IN BarnPersonnummer char(14), 
BarnFornamn varchar (20), 
BarnEternamn varchar (20), 
onskelistansRadNummer tinyint)
BEGIN
INSERT INTO levererade_onskeListRader(arTal, barnPnr, barnFnamn, barnEnamn, radNr, antal)
SELECT 
arTal, 
barnPnr, 
barnFnamn, 
barnEnamn, 
radNr, 
antal
FROM ejLevererad_onskeListRader
WHERE arTal=Ej_betal_arTal and barnPnr=BarnPersonnummer and barnFnamn=BarnFornamn and barnEnamn=BarnEternamn and radNr=onskelistansRadNummer;

DELETE FROM ejLevererad_onskeListRader 
WHERE arTal=Ej_betal_arTal 
and barnPnr=BarnPersonnummer 
and barnFnamn=BarnFornamn 
and barnEnamn=BarnEternamn 
and radNr=onskelistansRadNummer;
END //

DELIMITER ;

CALL levereraOnskelistRad(2023, '00011234560110', 'Anna', 'Andersson', 1);


--  alla önskelistrader som anna andersson har skrivit 2023, ska ha levererats. 
SELECT * 
FROM levererade_onskeListRader
WHERE 
  arTal = 2023
  And barnPnr = '00011234560110' 
  AND barnFnamn = 'Anna' 
  AND barnEnamn = 'Andersson'; 
  
  -- en dubbel check av listorna 
  SELECT * 
FROM ejLevererad_onskeListRader; 

   SELECT * 
FROM levererade_onskeListRader; 








-- -------------------------------------------------------------------------------------------------------------------
-- 
-- Rights 

-- Barn gentemot ej_levererad_önskelistrad
Create user 'test_barn'@'%' identified by 'Testlosenord'; 

-- test_barn får lägga till och modifiera tabellen: ej-levererade önskelistrader, framtills leverans. 
grant select, insert, update on a23guero.ejLevererad_onskeListRader to 'test_barn'@'%'; 

-- Ger test_barn tillgång till att hitta sina specifika inspelningar 
grant execute on procedure a23guero.hittaInspelningar to 'test_barn'@'%';

-- Ger test_barn rättigheter att läsa data från vyn barnVanner, där de kan se alla sina vänner. 
grant select on a23guero.barnVanner to 'test_barn'@'%';

-- barn ska kunna skapa barn i systemet
grant select, insert on a23guero.barn to 'test_barn'@'%';









