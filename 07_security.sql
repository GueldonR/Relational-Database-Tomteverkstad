USE tomteverkstad;

-- Barn gentemot ej_levererad_önskelistrad
Create user 'test_barn'@'%' identified by 'Testlosenord'; 

-- test_barn får lägga till och modifiera tabellen: ej-levererade önskelistrader, framtills leverans. 
grant select, insert, update on tomteverkstad.ejLevererad_onskeListRader to 'test_barn'@'%'; 

-- Ger test_barn tillgång till att hitta sina specifika inspelningar 
grant execute on procedure tomteverkstad.hittaInspelningar to 'test_barn'@'%';

-- Ger test_barn rättigheter att läsa data från vyn barnVanner, där de kan se alla sina vänner. 
grant select on tomteverkstad.barnVanner to 'test_barn'@'%';

-- barn ska kunna skapa barn i systemet
grant select, insert on tomteverkstad.barn to 'test_barn'@'%';
