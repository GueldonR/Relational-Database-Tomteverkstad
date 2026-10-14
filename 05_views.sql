USE tomteverkstad;

-- VYER
-- simplification 1
CREATE VIEW allaOnskelistor AS 
select * from ejLevererad_onskeListRader
union 
select * from levererade_onskeListRader;


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
