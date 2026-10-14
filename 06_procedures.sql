USE tomteverkstad;

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