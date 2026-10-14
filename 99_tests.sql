-- Testkommandon för Tomteverkstaden
-- Körs efter 00–07

USE tomteverkstad;

-- ------------------------------------------------------------
-- Trigger 3: borttagning ur MindreSnalltBarn ska loggas och sätta barnets status
DELETE FROM MindreSnalltBarn 
WHERE barnPnr = '00100123450819' 
AND barnFnamn = 'Jasmine' 
AND barnEnamn = 'Jönsson';

-- test kommandon - Trigger 3
select * from MindreSnalltBarn;
select * from Barn_status_logg;
select * from barn;

-- ------------------------------------------------------------
-- Trigger 4: .mp4-suffix och loggning av inspelningar
select * from inspelning_insert_logg;
select * from inspelning; 
-- FÖRVÄNTAT FEL: barn kan inte spela in om sig själv (duplikat av Anna som barn och subjekt)
INSERT INTO inspelning (tidsstampel, barnPnr, barnFnamn, barnEnamn, barn_om_Pnr, barn_om_Fnamn, barn_om_Enamn, NisseID, beskrivning, kvalitetsVarde, filNamn, beskrivandeText) VALUES
('2023-12-01 10:15:00', '00011234560110', 'Anna', 'Andersson', '00011234560110', 'Anna', 'Andersson' , '202209-0520-1-987654321', 'mdasdisid', '1', 'test', 'ska inte lagras');

-- ------------------------------------------------------------
-- Index
show index from inspelning;
show index from barn;

-- ------------------------------------------------------------
-- Vyer
select * from allaOnskelistor;
select * from BarnSysslorSammanfattning;
select * from barnVanner;
select * from snallBarn_hjalpsamhet;

-- ------------------------------------------------------------
-- Procedur 1
call hamta_inspelningar_Kvalitet (10);

-- ------------------------------------------------------------
-- Procedur 2
CALL hittaInspelningar('00022345670211', 'Bertil', 'Bergström');

-- ------------------------------------------------------------
-- Procedur 3
CALL sysslaRegg(
    '00011234560110', -- BarnPersonnummer
    'Anna',           -- BarnFornamn
    'Andersson',      -- BarnEternamn
    'Damma',   -- syssla 
    '2024-09-12 14:30:00', -- datumGjort 
    'Lyckat'          -- nivaAv_utForande
);

select * from sysslorLogg;

-- ------------------------------------------------------------
-- Procedur 4 (+ trigger 1 & 2: leveransen ska loggas i leveransLogg)
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

select * from leveransLogg;

