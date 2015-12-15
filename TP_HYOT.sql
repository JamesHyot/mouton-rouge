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
accessoire accessoire_ntab_type
);
/

CREATE TABLE moto OF moto_type
(
	CONSTRAINT pk_immat PRIMARY KEY(immatriculation)
) NESTED TABLE accessoire STORE AS tab_access
/