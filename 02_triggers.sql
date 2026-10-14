USE tomteverkstad;

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