DROP TABLE moto
/
DROP TYPE moto_type
/
DROP TYPE accessoire_ntab_type
/
DROP TYPE accessoire_type
/

--On crée un type pour les accessoires possédant 3 attributs 
CREATE TYPE accessoire_type AS OBJECT (
  nom VARCHAR2(40),
  marque VARCHAR2(40),
  prix FLOAT
)
/

--Création de la table imbriquée d'accessoires
CREATE OR REPLACE TYPE accessoire_ntab_type AS TABLE OF accessoire_type
/

--Création d'un type pour les motos dont avec tous les attributs (y compris les accessoires)
--On ajoute également la méthode get_transmission qui pourra être appelée pour calculer la
--transmission d'une moto
CREATE TYPE moto_type AS OBJECT(
immatriculation VARCHAR2(20),
numSerie INTEGER,
modele VARCHAR2(40),
marque VARCHAR2(40),
cylindree INTEGER,
prixCat FLOAT,
type VARCHAR2(20),
pourcentageCr FLOAT,
accessoire accessoire_ntab_type,
MEMBER FUNCTION get_transmission RETURN VARCHAR2
);
/

--On crée une méthode qui renvoie un VARCHAR2 en faisant de simple tests grâce à un IF
CREATE OR REPLACE TYPE BODY moto_type AS
MEMBER FUNCTION get_transmission RETURN VARCHAR2 IS
	resultat VARCHAR2(45);
BEGIN
	IF UPPER(self.type) = 'SPORTIF' THEN
		resultat := 'transmission finale par chaîne';
	ELSIF UPPER(self.type) = 'CUSTOM' and self.cylindree <= 250 THEN
		resultat := 'transmission finale par chaîne';
	ELSIF UPPER(self.type) = 'CUSTOM' and self.cylindree > 250 THEN
		resultat := 'transmission finale par courroie crantée';
	ELSE
		resultat := 'unknown';
	END IF;
return resultat;
END;
END;
/

--Enfin création de la table Moto, avec le numéro de série comme clé primaire,
--et les accessoires comme table imbriquée
CREATE TABLE moto OF moto_type
(
	CONSTRAINT pk_num_serie PRIMARY KEY(numSerie)
) NESTED TABLE accessoire STORE AS tab_access
/


CREATE OR REPLACE PROCEDURE set_accessoire (p_immat VARCHAR2, p_nom VARCHAR2, p_marque VARCHAR2 , p_prix FLOAT)
 IS
BEGIN
INSERT INTO TABLE (SELECT m.accessoire FROM moto m WHERE m.immatriculation = p_immat)
  VALUES (p_nom,p_marque,p_prix);
  COMMIT;  
END ;
/


INSERT INTO moto VALUES('777 ADA 95',1007,'EBR 1190 RX','EBR',1191,16998,'sportif',NULL, 
						NEW accessoire_ntab_type());
INSERT INTO moto VALUES('123 JDK 14',1008,'899 PANIGALE','DUCATI',898,15890,'sportif',NULL, 
						NEW accessoire_ntab_type());
INSERT INTO moto VALUES('145 UML 59',1009,'Electra Glide Ultra Classic','HARLEY DAVIDSON',1449,26195,'custom',15.5, 
						NEW accessoire_ntab_type());
INSERT INTO moto VALUES('689 PHP 59',1010,'VT Shadow 125','HONDA',124,7000,'custom',0, 
						NEW accessoire_ntab_type());


Begin
set_accessoire('777 ADA 95','amortisseur de direction','EBR', NULL);
set_accessoire('145 UML 59', 'valises', 'HARLEY DAVIDSON', NULL);
set_accessoire('145 UML 59', 'topcase', 'HARLEY DAVIDSON', NULL);
set_accessoire('145 UML 59', 'poignées chromées', NULL, 900);
set_accessoire('145 UML 59', 'repose-pieds passager à LED', NULL, 856.55);
set_accessoire('123 JDK 14', 'bulle', 'MRA Racing', 99);
set_accessoire('123 JDK 14', 'protège réservoir', 'DUCATI Corse', 26.10);
set_accessoire('123 JDK 14', 'support de plaque', 'EVOTECH DUCATI PANIGALE', 255);
commit;
end;
/


SELECT m.*, m.get_transmission() as TRANSMISSION
FROM moto m;