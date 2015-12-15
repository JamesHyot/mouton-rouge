DROP TABLE TT1_personnage_type
/

CREATE TYPE TT1_personnage_type AS OBJECT(
id INTEGER,
nom VARCHAR2(20),
prenom VARCHAR2(20),
profession VARCHAR2(20),
sexe CHAR,
nature VARCHAR2(7),
nom_etranger TT2_nom_etranger_ntab_type
);
/

CREATE TABLE TT1_personnage OF TT1_personnage_type
(
	CONSTRAINT pk_id PRIMARY KEY(id),
	CONSTRAINT nature_in CHECK(nature = 'GENTIL' OR nature = 'MECHANT'),
	CONSTRAINT sexe_in CHECK(sexe = 'M' OR sexe = 'F')
) NESTED TABLE nom_etranger STORE AS tab_perso_etran
/