USE tomteverkstad;

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