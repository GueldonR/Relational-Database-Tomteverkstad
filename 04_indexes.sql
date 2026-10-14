USE tomteverkstad;


create index inspelningsKvalitet on inspelning(kvalitetsVarde asc) using btree;  
-- jag valde att indexera detta då det kommer användas i en uträkning för att se hur trovärdigt ett barn är. Därmed kommer detta efterfrågas en del.


create index barnAlder on barn ( FodelseAR asc) using btree;  
-- jag valde att indexera detta då barnen bör vara mellan 0-17 år för att kunna 'delta' i systemet. 