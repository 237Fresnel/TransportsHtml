-- Schéma de base de données PostgreSQL pour le projet TransportsHtml
-- Basé sur le nouveau modèle conceptuel

-- Suppression des tables existantes si elles existent
DROP TABLE IF EXISTS signalisation_route CASCADE;
DROP TABLE IF EXISTS ville_route CASCADE;
DROP TABLE IF EXISTS accident_gravite CASCADE;
DROP TABLE IF EXISTS accident_blesse_sexe CASCADE;
DROP TABLE IF EXISTS accident_blesse_categorie CASCADE;
DROP TABLE IF EXISTS accident_mort_sexe CASCADE;
DROP TABLE IF EXISTS accident_mort_categorie CASCADE;
DROP TABLE IF EXISTS projet_ville CASCADE;
DROP TABLE IF EXISTS projet_source_financement CASCADE;
DROP TABLE IF EXISTS vehicule_tranche_age CASCADE;
DROP TABLE IF EXISTS vehicule_tranche_poids CASCADE;
DROP TABLE IF EXISTS vehicule_ville CASCADE;
DROP TABLE IF EXISTS vehicule_route CASCADE;
DROP TABLE IF EXISTS heure_pointe_route CASCADE;
DROP TABLE IF EXISTS statistiques_type_infrastructure CASCADE;

DROP TABLE IF EXISTS signalisation CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS type_revetement CASCADE;
DROP TABLE IF EXISTS electrification CASCADE;
DROP TABLE IF EXISTS profil_route CASCADE;
DROP TABLE IF EXISTS type_gare CASCADE;
DROP TABLE IF EXISTS gare CASCADE;
DROP TABLE IF EXISTS type_aire_repos CASCADE;
DROP TABLE IF EXISTS aire_repos CASCADE;
DROP TABLE IF EXISTS centroide CASCADE;
DROP TABLE IF EXISTS heure_pointe CASCADE;
DROP TABLE IF EXISTS type_infrastructure CASCADE;
DROP TABLE IF EXISTS statistiques CASCADE;
DROP TABLE IF EXISTS source_financement CASCADE;
DROP TABLE IF EXISTS projet CASCADE;
DROP TABLE IF EXISTS statut_projet CASCADE;
DROP TABLE IF EXISTS gravite_accident CASCADE;
DROP TABLE IF EXISTS accident CASCADE;
DROP TABLE IF EXISTS sexe_passager CASCADE;
DROP TABLE IF EXISTS categorie_passager CASCADE;
DROP TABLE IF EXISTS tranche_age CASCADE;
DROP TABLE IF EXISTS vehicule CASCADE;
DROP TABLE IF EXISTS ville CASCADE;
DROP TABLE IF EXISTS tranche_poids CASCADE;
DROP TABLE IF EXISTS modele CASCADE;
DROP TABLE IF EXISTS marque CASCADE;
DROP TABLE IF EXISTS propulsion CASCADE;
DROP TABLE IF EXISTS gabarit CASCADE;
DROP TABLE IF EXISTS type_vehicule CASCADE;
DROP TABLE IF EXISTS pont CASCADE;
DROP TABLE IF EXISTS type_pont CASCADE;

-- Création des tables pour les entités

-- Table Signalisation
CREATE TABLE signalisation (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Type_Revetement
CREATE TABLE type_revetement (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Electrification
CREATE TABLE electrification (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Profil_Route
CREATE TABLE profil_route (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Type_Gare
CREATE TABLE type_gare (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Type_Aire_Repos
CREATE TABLE type_aire_repos (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Heure_Pointe
CREATE TABLE heure_pointe (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    debut TIME NOT NULL,
    fin TIME NOT NULL
);

-- Table Type_Infrastructure
CREATE TABLE type_infrastructure (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Source_Financement
CREATE TABLE source_financement (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Statut_Projet
CREATE TABLE statut_projet (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Gravite_Accident
CREATE TABLE gravite_accident (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Sexe_Passager
CREATE TABLE sexe_passager (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

-- Table Categorie_Passager
CREATE TABLE categorie_passager (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Tranche_Age
CREATE TABLE tranche_age (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Tranche_Poids
CREATE TABLE tranche_poids (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    poids_min NUMERIC(10, 2),
    poids_max NUMERIC(10, 2)
);

-- Table Modele
CREATE TABLE modele (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Marque
CREATE TABLE marque (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Propulsion
CREATE TABLE propulsion (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Gabarit
CREATE TABLE gabarit (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Type_Vehicule
CREATE TABLE type_vehicule (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Type_Pont
CREATE TABLE type_pont (
    id SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL
);

-- Table Ville
CREATE TABLE ville (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50),
    nom VARCHAR(100) NOT NULL,
    population INTEGER,
    superficie NUMERIC(10, 2),
    taille_menage NUMERIC(5, 2),
    revenu_menage NUMERIC(15, 2),
    nombre_vehicules INTEGER,
    localisation JSONB,
    observations TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Route
CREATE TABLE route (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    code VARCHAR(50),
    localisation JSONB,
    longueur NUMERIC(10, 2),
    largeur NUMERIC(10, 2),
    nombre_voies INTEGER,
    poids_max NUMERIC(10, 2),
    devers NUMERIC(5, 2),
    pente NUMERIC(5, 2),
    rayon_courbure_bas NUMERIC(10, 2),
    rayon_courbure_haut NUMERIC(10, 2),
    rayon_courbure NUMERIC(10, 2),
    observations TEXT,
    id_type_revetement INTEGER REFERENCES type_revetement(id),
    id_electrification INTEGER REFERENCES electrification(id),
    id_profil_route INTEGER REFERENCES profil_route(id),
    id_ville INTEGER REFERENCES ville(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Gare
CREATE TABLE gare (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    code VARCHAR(50),
    position JSONB,
    capacite INTEGER,
    superficie NUMERIC(10, 2),
    observations TEXT,
    id_type_gare INTEGER REFERENCES type_gare(id),
    id_route INTEGER REFERENCES route(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Aire_Repos
CREATE TABLE aire_repos (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    code VARCHAR(50),
    localisation JSONB,
    capacite INTEGER,
    superficie NUMERIC(10, 2),
    observations TEXT,
    id_type_aire_repos INTEGER REFERENCES type_aire_repos(id),
    id_route INTEGER REFERENCES route(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Centroide
CREATE TABLE centroide (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50),
    nom VARCHAR(100) NOT NULL,
    population INTEGER,
    superficie NUMERIC(10, 2),
    localisation JSONB,
    observations TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Statistiques
CREATE TABLE statistiques (
    id SERIAL PRIMARY KEY,
    annee INTEGER NOT NULL,
    id_route INTEGER REFERENCES route(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Projet
CREATE TABLE projet (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    code VARCHAR(50),
    localisation JSONB,
    date_debut DATE,
    date_fin DATE,
    observations TEXT,
    id_statut_projet INTEGER REFERENCES statut_projet(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Accident
CREATE TABLE accident (
    id SERIAL PRIMARY KEY,
    annee INTEGER,
    localisation JSONB,
    observations TEXT,
    id_centroide INTEGER REFERENCES centroide(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Vehicule
CREATE TABLE vehicule (
    id SERIAL PRIMARY KEY,
    annee INTEGER,
    observations TEXT,
    id_modele INTEGER REFERENCES modele(id),
    id_propulsion INTEGER REFERENCES propulsion(id),
    id_gabarit INTEGER REFERENCES gabarit(id),
    id_type_vehicule INTEGER REFERENCES type_vehicule(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table Pont
CREATE TABLE pont (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    hauteur NUMERIC(10, 2),
    longueur NUMERIC(10, 2),
    largeur NUMERIC(10, 2),
    position JSONB,
    poids_max NUMERIC(10, 2),
    id_type_pont INTEGER REFERENCES type_pont(id),
    id_route INTEGER REFERENCES route(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tables de relations N-N avec attributs

-- Relation Signalisation-Route
CREATE TABLE signalisation_route (
    id_signalisation INTEGER REFERENCES signalisation(id),
    id_route INTEGER REFERENCES route(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_signalisation, id_route)
);

-- Relation Heure_Pointe-Route
CREATE TABLE heure_pointe_route (
    id_heure_pointe INTEGER REFERENCES heure_pointe(id),
    id_route INTEGER REFERENCES route(id),
    PRIMARY KEY (id_heure_pointe, id_route)
);

-- Relation Type_Infrastructure-Statistiques
CREATE TABLE statistiques_type_infrastructure (
    id_type_infrastructure INTEGER REFERENCES type_infrastructure(id),
    id_statistiques INTEGER REFERENCES statistiques(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_type_infrastructure, id_statistiques)
);

-- Relation Accident-Gravite_Accident
CREATE TABLE accident_gravite (
    id_accident INTEGER REFERENCES accident(id),
    id_gravite_accident INTEGER REFERENCES gravite_accident(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_accident, id_gravite_accident)
);

-- Relation Accident-Sexe_Passager (blessés)
CREATE TABLE accident_blesse_sexe (
    id_accident INTEGER REFERENCES accident(id),
    id_sexe_passager INTEGER REFERENCES sexe_passager(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_accident, id_sexe_passager)
);

-- Relation Accident-Categorie_Passager (blessés)
CREATE TABLE accident_blesse_categorie (
    id_accident INTEGER REFERENCES accident(id),
    id_categorie_passager INTEGER REFERENCES categorie_passager(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_accident, id_categorie_passager)
);

-- Relation Accident-Sexe_Passager (morts)
CREATE TABLE accident_mort_sexe (
    id_accident INTEGER REFERENCES accident(id),
    id_sexe_passager INTEGER REFERENCES sexe_passager(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_accident, id_sexe_passager)
);

-- Relation Accident-Categorie_Passager (morts)
CREATE TABLE accident_mort_categorie (
    id_accident INTEGER REFERENCES accident(id),
    id_categorie_passager INTEGER REFERENCES categorie_passager(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_accident, id_categorie_passager)
);

-- Relation Source_Financement-Projet
CREATE TABLE projet_source_financement (
    id_projet INTEGER REFERENCES projet(id),
    id_source_financement INTEGER REFERENCES source_financement(id),
    montant NUMERIC(15, 2),
    observations TEXT,
    PRIMARY KEY (id_projet, id_source_financement)
);

-- Relation Projet-Ville
CREATE TABLE projet_ville (
    id_projet INTEGER REFERENCES projet(id),
    id_ville INTEGER REFERENCES ville(id),
    PRIMARY KEY (id_projet, id_ville)
);

-- Relation Vehicule-Tranche_Age
CREATE TABLE vehicule_tranche_age (
    id_vehicule INTEGER REFERENCES vehicule(id),
    id_tranche_age INTEGER REFERENCES tranche_age(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_vehicule, id_tranche_age)
);

-- Relation Vehicule-Tranche_Poids
CREATE TABLE vehicule_tranche_poids (
    id_vehicule INTEGER REFERENCES vehicule(id),
    id_tranche_poids INTEGER REFERENCES tranche_poids(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_vehicule, id_tranche_poids)
);

-- Relation Vehicule-Ville
CREATE TABLE vehicule_ville (
    id_vehicule INTEGER REFERENCES vehicule(id),
    id_ville INTEGER REFERENCES ville(id),
    PRIMARY KEY (id_vehicule, id_ville)
);

-- Relation Vehicule-Route
CREATE TABLE vehicule_route (
    id_vehicule INTEGER REFERENCES vehicule(id),
    id_route INTEGER REFERENCES route(id),
    PRIMARY KEY (id_vehicule, id_route)
);

-- Relation Marque-Modele
CREATE TABLE marque_modele (
    id_marque INTEGER REFERENCES marque(id),
    id_modele INTEGER REFERENCES modele(id),
    nombre INTEGER,
    observations TEXT,
    PRIMARY KEY (id_marque, id_modele)
);

-- Insertion de données de base pour les tables de référence
INSERT INTO type_revetement (libelle) VALUES ('Asphalte'), ('Béton'), ('Pavé'), ('Terre'), ('Gravier');
INSERT INTO electrification (libelle) VALUES ('Non électrifiée'), ('Électrifiée'), ('Partiellement électrifiée');
INSERT INTO profil_route (libelle) VALUES ('Plat'), ('Montagneux'), ('Vallonné'), ('Mixte');
INSERT INTO type_gare (libelle) VALUES ('Voyageurs'), ('Marchandises'), ('Mixte'), ('Triage');
INSERT INTO type_aire_repos (libelle) VALUES ('Simple'), ('Avec services'), ('Avec restauration'), ('Complète');
INSERT INTO type_infrastructure (libelle) VALUES ('Pont'), ('Tunnel'), ('Échangeur'), ('Passage à niveau');
INSERT INTO source_financement (libelle) VALUES ('Public'), ('Privé'), ('Partenariat Public-Privé'), ('International');
INSERT INTO statut_projet (libelle) VALUES ('Planifié'), ('En cours'), ('Terminé'), ('Suspendu'), ('Annulé');
INSERT INTO gravite_accident (libelle) VALUES ('Léger'), ('Grave'), ('Très grave'), ('Mortel');
INSERT INTO sexe_passager (libelle) VALUES ('Homme'), ('Femme'), ('Non spécifié');
INSERT INTO categorie_passager (libelle) VALUES ('Conducteur'), ('Passager'), ('Piéton'), ('Cycliste');
INSERT INTO tranche_age (libelle) VALUES ('0-14 ans'), ('15-24 ans'), ('25-44 ans'), ('45-64 ans'), ('65+ ans');
INSERT INTO type_vehicule (libelle) VALUES ('Voiture'), ('Camion'), ('Bus'), ('Moto'), ('Vélo');
INSERT INTO propulsion (libelle) VALUES ('Essence'), ('Diesel'), ('Électrique'), ('Hybride'), ('Gaz');
INSERT INTO gabarit (libelle) VALUES ('Petit'), ('Moyen'), ('Grand'), ('Très grand');
INSERT INTO type_pont (libelle) VALUES ('Suspendu'), ('À haubans'), ('À poutres'), ('En arc'), ('Cantilever');
