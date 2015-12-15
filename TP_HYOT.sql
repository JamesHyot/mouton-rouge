DROP TABLE moto
/
DROP TYPE moto_type
/
DROP TYPE accessoire_ntab_type
/
DROP TYPE accessoire_type
/

CREATE TYPE accessoire_type AS OBJECT (
  nom VARCHAR2(40),
  marque VARCHAR2(40),
  prix FLOAT
)
/

CREATE OR REPLACE TYPE accessoire_ntab_type AS TABLE OF accessoire_type
/

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

CREATE OR REPLACE TYPE BODY moto_type AS
MEMBER FUNCTION get_transmission RETURN VARCHAR2 IS
	resultat VARCHAR2(45);
BEGIN
	IF self.type = 'SPORTIF' THEN
		resultat := 'transmission finale par chaîne';
	ELSIF self.type = 'CUSTOM' and self.cylindree <= 250 THEN
		resultat := 'transmission finale par chaîne';
	ELSIF self.type = 'CUSTOM' and self.cylindree > 250 THEN
		resultat := 'transmission finale par courroie crantée';
	ELSE
		resultat := 'unknown';
	END IF;
return resultat;
END;
END;
/

CREATE TABLE moto OF moto_type
(
	CONSTRAINT pk_immat PRIMARY KEY(immatriculation)
) NESTED TABLE accessoire STORE AS tab_access
/