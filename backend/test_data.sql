-- INSERTIONS DE DONNÉES TEST POUR LE SCHÉMA TRANSPORTSHTML

-- IMPORTANT: Exécutez ce script APRÈS avoir créé toutes les tables
-- et inséré les données de base pour les tables de référence (lookup tables)
-- comme type_revetement, statut_projet, etc.

-- Si vous avez déjà exécuté les insertions de base pour les lookups, vous pouvez ignorer ou commenter ces blocs ci-dessous.
-- Insertion de données de base pour les tables de référence (si elles ne sont pas déjà présentes)
INSERT INTO signalisation (libelle) VALUES ('Panneau Stop'), ('Feu Rouge'), ('Cédez le passage'), ('Passage piéton'), ('Zone 30');
INSERT INTO type_revetement (libelle) VALUES ('Asphalte'), ('Béton'), ('Pavé'), ('Terre'), ('Gravier') ON CONFLICT DO NOTHING; -- Use ON CONFLICT DO NOTHING if already inserted
INSERT INTO electrification (libelle) VALUES ('Non électrifiée'), ('Électrifiée'), ('Partiellement électrifiée') ON CONFLICT DO NOTHING;
INSERT INTO profil_route (libelle) VALUES ('Plat'), ('Montagneux'), ('Vallonné'), ('Mixte') ON CONFLICT DO NOTHING;
INSERT INTO type_gare (libelle) VALUES ('Voyageurs'), ('Marchandises'), ('Mixte'), ('Triage') ON CONFLICT DO NOTHING;
INSERT INTO type_aire_repos (libelle) VALUES ('Simple'), ('Avec services'), ('Avec restauration'), ('Complète') ON CONFLICT DO NOTHING;
INSERT INTO type_infrastructure (libelle) VALUES ('Pont'), ('Tunnel'), ('Échangeur'), ('Passage à niveau') ON CONFLICT DO NOTHING;
INSERT INTO source_financement (libelle) VALUES ('Public'), ('Privé'), ('Partenariat Public-Privé'), ('International') ON CONFLICT DO NOTHING;
INSERT INTO statut_projet (libelle) VALUES ('Planifié'), ('En cours'), ('Terminé'), ('Suspendu'), ('Annulé') ON CONFLICT DO NOTHING;
INSERT INTO gravite_accident (libelle) VALUES ('Léger'), ('Grave'), ('Très grave'), ('Mortel') ON CONFLICT DO NOTHING;
INSERT INTO sexe_passager (libelle) VALUES ('Homme'), ('Femme'), ('Non spécifié') ON CONFLICT DO NOTHING;
INSERT INTO categorie_passager (libelle) VALUES ('Conducteur'), ('Passager'), ('Piéton'), ('Cycliste') ON CONFLICT DO NOTHING;
INSERT INTO tranche_age (libelle) VALUES ('0-14 ans'), ('15-24 ans'), ('25-44 ans'), ('45-64 ans'), ('65+ ans') ON CONFLICT DO NOTHING;
INSERT INTO type_vehicule (libelle) VALUES ('Voiture'), ('Camion'), ('Bus'), ('Moto'), ('Vélo') ON CONFLICT DO NOTHING;
INSERT INTO propulsion (libelle) VALUES ('Essence'), ('Diesel'), ('Électrique'), ('Hybride'), ('Gaz') ON CONFLICT DO NOTHING;
INSERT INTO gabarit (libelle) VALUES ('Petit'), ('Moyen'), ('Grand'), ('Très grand') ON CONFLICT DO NOTHING;
INSERT INTO type_pont (libelle) VALUES ('Suspendu'), ('À haubans'), ('À poutres'), ('En arc'), ('Cantilever') ON CONFLICT DO NOTHING;

-- Insérer les tables de référence qui n'étaient pas dans l'exemple précédent
INSERT INTO heure_pointe (nom, debut, fin) VALUES
('Matin', '07:00:00', '09:00:00'),
('Soir', '17:00:00', '19:00:00'),
('Midi', '12:00:00', '14:00:00');

INSERT INTO tranche_poids (nom, poids_min, poids_max) VALUES
('0-1t', 0.00, 1.00),
('1-3.5t', 1.01, 3.50),
('3.5t+', 3.51, 999.99);

INSERT INTO modele (libelle) VALUES
('Corolla'), ('Actros'), ('Hiace'), ('FZ-S'), ('VéloVille'), ('Model 3'), ('Leaf'), ('Kangoo');

INSERT INTO marque (libelle) VALUES
('Toyota'), ('Mercedes'), ('Yamaha'), ('Specialized'), ('Tesla'), ('Nissan'), ('Renault');


-- Insertion des données pour les tables d'entités principales (~10-20 records chacune)

-- Ville (~15 records)
INSERT INTO ville (code, nom, population, superficie, taille_menage, revenu_menage, nombre_vehicules, localisation, observations) VALUES
('CM-DLA', 'Douala', 3500000, 210.50, 5.5, 2500000.00, 850000, '{"lat": 4.05, "lng": 9.70}', 'Capitale économique, portuaire'),
('CM-YAO', 'Yaoundé', 3200000, 185.20, 5.2, 2800000.00, 780000, '{"lat": 3.85, "lng": 11.50}', 'Capitale politique, administrative'),
('CM-BUE', 'Buea', 400000, 87.00, 4.8, 1800000.00, 120000, '{"lat": 4.15, "lng": 9.23}', 'Ville universitaire, flanc du Mont Cameroun'),
('CM-KUM', 'Kumba', 550000, 112.30, 5.0, 1500000.00, 150000, '{"lat": 4.65, "lng": 9.93}', 'Nœud commercial important'),
('CM-GOU', 'Garoua', 450000, 150.00, 5.8, 1200000.00, 90000, '{"lat": 9.33, "lng": 13.40}', 'Capitale régionale du Nord'),
('CM-MAR', 'Maroua', 400000, 105.00, 6.1, 1100000.00, 80000, '{"lat": 10.60, "lng": 14.33}', 'Proche de la frontière tchadienne'),
('CM-BAN', 'Bafoussam', 420000, 95.00, 4.9, 1600000.00, 100000, '{"lat": 5.47, "lng": 10.42}', 'Plateau de l''Ouest'),
('CM-DSG', 'Dschang', 120000, 45.00, 4.5, 1700000.00, 35000, '{"lat": 5.45, "lng": 10.05}', 'Ville universitaire, climat frais'),
('CM-NGA', 'Ngaoundéré', 200000, 130.00, 5.6, 1300000.00, 45000, '{"lat": 7.37, "lng": 13.58}', 'Ville carrefour, début du Nord'),
('CM-EDK', 'Edéa', 150000, 70.00, 5.1, 1900000.00, 40000, '{"lat": 3.80, "lng": 10.15}', 'Ville industrielle, barrage hydroélectrique'),
('CM-KRI', 'Kribi', 100000, 60.00, 4.7, 2000000.00, 30000, '{"lat": 2.95, "lng": 9.90}', 'Ville côtière, port en eau profonde'),
('CM-LIM', 'Limbe', 120000, 55.00, 4.6, 1950000.00, 32000, '{"lat": 4.00, "lng": 9.20}', 'Ville côtière, touristique'),
('CM-BER', 'Bertoua', 250000, 160.00, 5.4, 1400000.00, 60000, '{"lat": 4.58, "lng": 13.68}', 'Capitale régionale de l''Est'),
('CM-EBW', 'Ebolowa', 100000, 80.00, 5.0, 1550000.00, 28000, '{"lat": 2.91, "lng": 11.15}', 'Capitale régionale du Sud'),
('CM-BFO', 'Bamenda', 500000, 100.00, 5.3, 1750000.00, 130000, '{"lat": 5.93, "lng": 10.15}', 'Ville des montagnes du Nord-Ouest');


-- Centroide (~10 records)
INSERT INTO centroide (code, nom, population, superficie, localisation, observations) VALUES
('DLA-CEN', 'Centre Ville Douala', 50000, 5.00, '{"lat": 4.05, "lng": 9.70}', 'Quartier d affaires principal'),
('DLA-AKE', 'Akwa', 30000, 3.50, '{"lat": 4.055, "lng": 9.695}', 'Zone commerciale animée'),
('YAO-CEN', 'Centre Ville Yaoundé', 40000, 4.00, '{"lat": 3.85, "lng": 11.50}', 'Quartier administratif'),
('YAO-ORA', 'Obili', 25000, 2.80, '{"lat": 3.86, "lng": 11.48}', 'Zone résidentielle et étudiante'),
('BUE-CEN', 'Down Beach', 5000, 1.50, '{"lat": 4.14, "lng": 9.21}', 'Zone portuaire et touristique'),
('KUM-MAR', 'Grand Marché Kumba', 8000, 2.00, '{"lat": 4.64, "lng": 9.92}', 'Coeur commercial de Kumba'),
('GOU-AER', 'Aéroport Garoua', 1000, 0.80, '{"lat": 9.33, "lng": 13.45}', 'Zone aéroportuaire'),
('BAN-MON', 'Mbamenda Main Town', 15000, 3.00, '{"lat": 5.93, "lng": 10.15}', 'Centre urbain'),
('EDK-IND', 'Zone Industrielle Edea', 7000, 10.00, '{"lat": 3.78, "lng": 10.10}', 'Grandes usines'),
('KRI-POR', 'Nouveau Port Kribi', 3000, 25.00, '{"lat": 2.90, "lng": 9.85}', 'Infrastructure portuaire moderne');


-- Route (~20 records) - Linking to existing cities (assuming IDs 1-15 for cities and 1-5 for revetement, 1-3 for electrification, 1-4 for profil)
INSERT INTO route (nom, code, localisation, longueur, largeur, nombre_voies, poids_max, devers, pente, id_type_revetement, id_electrification, id_profil_route, id_ville) VALUES
('Autoroute Douala-Yaoundé (tronçon test)', 'A3T', '{"start": {"lat": 4.06, "lng": 9.72}, "end": {"lat": 3.84, "lng": 11.48}}', 20.00, 14.00, 4, 50.00, 1.5, 0.8, 1, 1, 4, 1),
('Boulevard de la République', 'B-REP', '{"start": {"lat": 4.04, "lng": 9.71}, "end": {"lat": 4.06, "lng": 9.73}}', 3.50, 10.00, 3, 40.00, 1.0, 0.2, 1, 1, 1, 1),
('Route vers l''aéroport (DLA)', 'R-AER-DLA', '{"start": {"lat": 4.00, "lng": 9.75}, "end": {"lat": 4.01, "lng": 9.78}}', 6.00, 7.00, 2, 35.00, 2.0, 0.5, 1, 1, 1, 1),
('Rue des Ambassades', 'R-AMB', '{"start": {"lat": 3.86, "lng": 11.51}, "end": {"lat": 3.87, "lng": 11.53}}', 2.00, 8.00, 2, 30.00, 1.8, 1.2, 2, 1, 3, 2),
('Route de Mbalmayo (début)', 'R-MBA', null, 10.00, 6.00, 2, 40.00, 2.2, 1.5, 1, 1, 2, 2),
('Voie express Nord', 'V-EX-N', '{"start": {"lat": 3.88, "lng": 11.50}, "end": {"lat": 3.92, "lng": 11.51}}', 5.00, 12.00, 4, 45.00, 1.2, 0.3, 1, 1, 1, 2),
('Route du Mont Fébé', 'R-MFE', null, 7.00, 5.00, 2, 25.00, 2.5, 5.0, 3, 1, 2, 2),
('Route côtière vers Kribi', 'R-COT-S', null, 15.00, 6.00, 2, 40.00, 1.0, 0.1, 1, 1, 1, 11),
('Route de Bafoussam vers Foumban', 'R-BFO-FNB', null, 30.00, 6.00, 2, 35.00, 2.1, 3.0, 4, 1, 2, 7),
('Axe lourd Ngaoundéré-Garoua', 'N1T', null, 50.00, 7.00, 2, 45.00, 1.9, 0.7, 1, 1, 1, 9),
('Route de Dschang vers Bafoussam', 'R-DSG-BFO', null, 25.00, 6.00, 2, 35.00, 2.3, 4.5, 3, 1, 2, 8),
('Pénétrante Est Bertoua', 'P-EST-BER', null, 8.00, 7.00, 2, 40.00, 1.8, 0.6, 1, 1, 1, 13),
('Route principale Ebolowa', 'R-PR-EBO', null, 5.00, 8.00, 2, 35.00, 1.5, 0.4, 2, 1, 1, 14),
('Axe Kumba-Buea', 'R-KUM-BUE', null, 15.00, 7.00, 2, 40.00, 2.8, 6.0, 1, 1, 2, 3),
('Route périphérique Bamenda', 'R-PER-BMA', null, 12.00, 8.00, 3, 45.00, 1.0, 1.0, 1, 1, 3, 15),
('Rue commerçante Kumba', 'R-COM-KUM', null, 1.50, 5.00, 1, 10.00, 0.5, 0.1, 3, 1, 1, 4),
('Route vers le port de Kribi', 'R-PORT-KRI', null, 7.00, 10.00, 3, 60.00, 1.0, 0.2, 1, 1, 1, 11),
('Route de l''aéroport de Yaoundé', 'R-AER-YAO', null, 8.00, 7.00, 2, 35.00, 1.8, 0.5, 1, 1, 1, 2),
('Accès Zone Industrielle Edéa', 'A-ZI-EDK', null, 3.00, 9.00, 3, 50.00, 1.0, 0.1, 1, 1, 1, 10),
('Route de contournement Garoua', 'R-CON-GOU', null, 10.00, 7.00, 2, 40.00, 1.5, 0.4, 1, 1, 1, 5);


-- Projet (~15 records) - Linking to existing statut_projet (assuming IDs 1-5)
INSERT INTO projet (nom, code, localisation, date_debut, date_fin, id_statut_projet, observations) VALUES
('Élargissement A3', 'PROJ-A3', null, '2024-01-01', '2026-12-31', 2, 'Élargissement de l''autoroute'),
('Construction Gare Routière DLA', 'PROJ-G-DLA', '{"lat": 4.07, "lng": 9.71}', '2023-05-20', '2025-06-15', 2, 'Nouvelle gare centrale'),
('Réhabilitation Boulevard République', 'PROJ-B-REP', null, '2023-11-10', '2024-11-10', 2, 'Repavage et ajout de pistes cyclables'),
('Étude Faisabilité Ligne Tram YAO', 'PROJ-TRAM-YAO', null, '2024-03-01', '2025-03-01', 1, 'Étude technique et économique'),
('Amélioration Signalisation Kumba', 'PROJ-S-KUM', null, '2024-07-01', '2024-12-31', 1, 'Installation de nouveaux panneaux'),
('Construction Aire Repos N1', 'PROJ-AR-N1', null, '2025-01-01', '2025-08-31', 1, 'Sur l''axe Ngaoundéré-Garoua'),
('Réparation Pont Edéa', 'PROJ-P-EDK', '{"lat": 3.79, "lng": 10.16}', '2024-06-01', '2024-11-30', 2, 'Renforcement structurel'),
('Extension Réseau Bus Yaoundé Sud', 'PROJ-BUS-YAO', null, '2024-09-01', '2026-08-31', 1, 'Nouvelles lignes et achat de bus'),
('Création Voies Cyclables Buea', 'PROJ-VC-BUE', null, '2025-03-01', '2025-11-30', 1, 'Dans le centre ville'),
('Modernisation Port Kribi', 'PROJ-PORT-KRI', '{"lat": 2.905, "lng": 9.86}', '2022-01-01', '2024-12-31', 2, 'Agrandissement des quais'),
('Étude Contournement Bafoussam', 'PROJ-CON-BFO', null, '2024-04-01', '2024-10-31', 1, 'Réduire le trafic en centre ville'),
('Projet Transport Électrique Garoua', 'PROJ-EV-GOU', null, '2025-06-01', '2027-06-01', 1, 'Introduction de bus électriques'),
('Aménagement Centroïde Yaoundé Obili', 'PROJ-C-ORA', '{"lat": 3.86, "lng": 11.48}', '2024-08-01', '2025-07-31', 2, 'Amélioration de la circulation'),
('Construction Route Bafoussam-Banyo', 'PROJ-R-BB', null, '2023-01-01', '2025-12-31', 2, 'Nouvelle liaison majeure'),
('Analyse Trafic Douala', 'PROJ-TR-DLA', null, '2024-01-01', '2024-12-31', 2, 'Collecte de données pour planification future');


-- Accident (~15 records) - Linking to existing centroides (assuming IDs 1-10, some null)
INSERT INTO accident (annee, localisation, observations, id_centroide) VALUES
(2023, '{"lat": 4.052, "lng": 9.701}', 'Collision multiple au carrefour', 1),
(2023, '{"lat": 3.855, "lng": 11.505}', 'Accident mortel sur la voie rapide', 3),
(2024, '{"lat": 4.151, "lng": 9.235}', 'Sortie de route, cause inconnue', 5),
(2023, null, 'Accident sur route non spécifiée', null),
(2024, '{"lat": 9.335, "lng": 13.41}', 'Collision entre un camion et un bus', 7),
(2023, '{"lat": 5.46, "lng": 10.43}', 'Plusieurs blessés légers', null),
(2024, '{"lat": 3.801, "lng": 10.155}', 'Accident près de l''usine', 9),
(2023, '{"lat": 2.95, "lng": 9.91}', 'Véhicule léger impliqué', null),
(2024, '{"lat": 5.931, "lng": 10.152}', 'Piéton renversé', 8),
(2023, '{"lat": 4.065, "lng": 9.73}', 'Délit de fuite', null),
(2024, '{"lat": 3.875, "lng": 11.52}', 'Accident sans gravité', 4),
(2023, '{"lat": 4.645, "lng": 9.925}', 'Plusieurs véhicules impliqués', 6),
(2024, null, 'Accident sur route de campagne', null),
(2023, '{"lat": 7.37, "lng": 13.60}', 'Choc frontal', null),
(2024, '{"lat": 4.581, "lng": 13.685}', 'Véhicule utilitaire impliqué', null);


-- Vehicule (~20 records) - Linking to lookup tables (assuming IDs 1-8 modele, 1-5 propulsion, 1-4 gabarit, 1-5 type_vehicule)
INSERT INTO vehicule (annee, id_modele, id_propulsion, id_gabarit, id_type_vehicule, observations) VALUES
(2022, 1, 1, 1, 1, 'Voiture particulière'), -- Corolla Essence Petit Voiture
(2018, 2, 2, 4, 2, 'Camion Longue distance'), -- Actros Diesel Très grand Camion
(2019, 3, 2, 3, 3, 'Bus de transport urbain'), -- Hiace Diesel Grand Bus
(2021, 4, 1, 1, 4, 'Moto de livraison'), -- FZ-S Essence Petit Moto
(2023, 5, null, 1, 5, 'Vélo standard'), -- VéloVille null Petit Vélo
(2023, 6, 3, 1, 1, 'Voiture électrique'), -- Model 3 Electrique Petit Voiture
(2022, 7, 3, 1, 1, 'Voiture électrique compacte'), -- Leaf Electrique Petit Voiture
(2020, 8, 2, 2, 2, 'Fourgon Diesel Moyen Camion'), -- Kangoo Diesel Moyen Camion
(2015, 1, 1, 1, 1, 'Voiture ancienne'),
(2017, 2, 2, 4, 2, 'Camion benne'),
(2016, 3, 2, 3, 3, 'Bus interurbain'),
(2020, 4, 1, 1, 4, 'Moto sportive'),
(2024, 5, null, 1, 5, 'Vélo électrique'),
(2024, 6, 3, 1, 1, 'Voiture électrique luxe'),
(2023, 7, 3, 1, 1, 'Voiture électrique citadine'),
(2021, 8, 1, 2, 1, 'Voiture familiale Essence Moyen Voiture'), -- Kangoo Essence Moyen Voiture
(2010, null, 2, 4, 2, 'Vieux camion citerne'), -- Modèle inconnu
(2014, null, null, 3, 3, 'Bus touristique'), -- Modèle/Propulsion inconnus
(2022, null, 1, 1, 4, 'Moto trail'), -- Modèle inconnu
(2023, null, null, 1, 5, 'Trottinette électrique'); -- Modèle/Propulsion inconnus


-- Gare (~10 records) - Linking to existing types (1-4) and routes (1-20, some null)
INSERT INTO gare (nom, code, position, capacite, superficie, observations, id_type_gare, id_route) VALUES
('Gare Centrale Douala', 'GR-DLA', '{"lat": 4.06, "lng": 9.71}', 5000, 10.00, 'Principale gare ferroviaire et routière', 3, null), -- Mixte, not directly on one road
('Gare Voyageurs Yaoundé', 'GR-YAO-VOY', '{"lat": 3.85, "lng": 11.51}', 4000, 8.00, 'Gare ferroviaire principale', 1, null), -- Voyageurs
('Gare Marchandises Douala', 'GR-DLA-MAR', '{"lat": 4.04, "lng": 9.68}', 8000, 15.00, 'Gare ferroviaire de fret', 2, null), -- Marchandises
('Gare Routière Kumba', 'GR-KUM', '{"lat": 4.65, "lng": 9.935}', 2000, 5.00, 'Terminal bus et taxis', 1, 16), -- Voyageurs, near Rue commerçante Kumba
('Gare de triage Edéa', 'GR-EDK-TRI', '{"lat": 3.78, "lng": 10.14}', 3000, 12.00, 'Tri des wagons', 4, null), -- Triage
('Gare Secondaire Yaoundé', 'GR-YAO-SEC', '{"lat": 3.88, "lng": 11.53}', 1000, 3.00, 'Petite gare de quartier', 1, 4), -- Voyageurs, near Rue des Ambassades
('Gare Garoua', 'GR-GOU', '{"lat": 9.32, "lng": 13.40}', 1500, 4.00, 'Gare ferroviaire et routière', 3, null), -- Mixte
('Gare Routière Bamenda', 'GR-BMA', '{"lat": 5.94, "lng": 10.16}', 2500, 6.00, 'Terminal de bus principaux', 1, 15), -- Voyageurs, on périphérique
('Gare Bertoua', 'GR-BER', '{"lat": 4.58, "lng": 13.69}', 1200, 3.50, 'Gare principale', 1, 12), -- Voyageurs, on pénétrante Est
('Gare de transit portuaire Kribi', 'GR-KRI-PORT', '{"lat": 2.90, "lng": 9.855}', 5000, 20.00, 'Gare liée au port pour le fret', 2, 17); -- Marchandises, near route portuaire

-- Aire_Repos (~10 records) - Linking to existing types (1-4) and routes (1-20)
INSERT INTO aire_repos (nom, code, localisation, capacite, superficie, observations, id_type_aire_repos, id_route) VALUES
('Aire N3 KM 50', 'AR-N3-50', '{"lat": 3.95, "lng": 10.50}', 50, 1.00, 'Aire de stationnement simple', 1, 1),
('Aire N3 KM 150', 'AR-N3-150', '{"lat": 3.90, "lng": 11.00}', 100, 2.50, 'Aire avec services basiques', 2, 1),
('Aire N1 Nord', 'AR-N1-N', '{"lat": 8.00, "lng": 13.50}', 80, 2.00, 'Aire avec restauration', 3, 10),
('Aire N1 Sud', 'AR-N1-S', '{"lat": 8.50, "lng": 13.55}', 120, 3.00, 'Aire complète', 4, 10),
('Aire Autoroute Test 1', 'AR-A3-1', '{"lat": 4.065, "lng": 9.74}', 30, 0.80, 'Petite aire sur tronçon test', 1, 1),
('Aire Autoroute Test 2', 'AR-A3-2', '{"lat": 4.07, "lng": 9.76}', 40, 1.20, 'Aire avec services', 2, 1),
('Aire Route Kribi', 'AR-R-KRI', '{"lat": 2.93, "lng": 9.88}', 60, 1.50, 'Aire simple près de la côte', 1, 17),
('Aire Route Bafoussam', 'AR-R-BFO', '{"lat": 5.50, "lng": 10.35}', 70, 1.80, 'Aire avec restauration', 3, 9),
('Aire Route Bertoua', 'AR-R-BER', '{"lat": 4.60, "lng": 13.70}', 55, 1.10, 'Aire simple', 1, 12),
('Aire Route Bamenda', 'AR-R-BMA', '{"lat": 5.92, "lng": 10.18}', 90, 2.20, 'Aire complète', 4, 15);


-- Pont (~10 records) - Linking to existing types (1-5) and routes (1-20)
INSERT INTO pont (nom, hauteur, longueur, largeur, position, poids_max, id_type_pont, id_route) VALUES
('Pont sur le Wouri (Douala)', 20.00, 1800.00, 25.00, '{"lat": 4.04, "lng": 9.69}', 60.00, 3, 2), -- À poutres, Boulevard République
('Pont sur la Sanaga (Edéa)', 15.00, 300.00, 15.00, '{"lat": 3.79, "lng": 10.16}', 50.00, 3, 10), -- À poutres, Accès ZI Edéa
('Pont sur le Nyong (Yaoundé)', 10.00, 150.00, 12.00, '{"lat": 3.80, "lng": 11.55}', 45.00, 3, 5), -- À poutres
('Pont sur le Logone (frontière)', 8.00, 100.00, 8.00, '{"lat": 10.65, "lng": 14.35}', 30.00, 3, null), -- À poutres
('Pont suspendu touristique', 50.00, 100.00, 2.00, '{"lat": 4.16, "lng": 9.24}', 5.00, 1, 3), -- Suspendu, près de Buea
('Petit pont urbain DLA', 5.00, 30.00, 10.00, '{"lat": 4.055, "lng": 9.715}', 20.00, 3, null), -- À poutres
('Pont en arc Dschang', 12.00, 80.00, 9.00, '{"lat": 5.46, "lng": 10.06}', 25.00, 4, 11), -- En arc, Route Dschang-Bafoussam
('Pont sur route de campagne', 3.00, 15.00, 6.00, null, 15.00, 3, null), -- À poutres
('Pont à haubans (projet)', 30.00, 500.00, 20.00, '{"lat": 4.10, "lng": 9.80}', 55.00, 2, 1), -- À haubans, sur Autoroute Douala-Yaoundé
('Pont sur un ruisseau (Bertoua)', 4.00, 20.00, 7.00, null, 25.00, 3, 12); -- À poutres, Pénétrante Est Bertoua


-- Statistiques (~10 records) - Linking to existing routes (1-20)
INSERT INTO statistiques (annee, id_route) VALUES
(2023, 1), (2023, 2), (2023, 4), (2023, 10), (2023, 15),
(2024, 1), (2024, 2), (2024, 5), (2024, 12), (2024, 17);


-- Insertion des données pour les tables de relations N-N (~5-10 links per table)

-- Signalisation_Route
-- Assuming Signalisation IDs 1-5 and Route IDs 1-20
INSERT INTO signalisation_route (id_signalisation, id_route, nombre, observations) VALUES
(1, 1, 10, 'Panneaux stop sur les accès'),
(2, 2, 5, 'Feux tricolores installés'),
(3, 4, 8, null),
(4, 2, 15, 'Passages piétons fréquents'),
(5, 6, 20, 'Nombreux panneaux zone 30'),
(1, 16, 3, null),
(2, 17, 2, null),
(4, 18, 10, null),
(5, 15, 12, null),
(1, 20, 5, null);

-- Heure_Pointe_Route
-- Assuming Heure_Pointe IDs 1-3 and Route IDs 1-20
INSERT INTO heure_pointe_route (id_heure_pointe, id_route) VALUES
(1, 1), (2, 1), (1, 2), (2, 2), (1, 4), (2, 4), (1, 6), (2, 6), (1, 10), (2, 10),
(1, 15), (2, 15), (1, 18), (2, 18);

-- Statistiques_Type_Infrastructure
-- Assuming Type_Infrastructure IDs 1-4 and Statistiques IDs 1-10
INSERT INTO statistiques_type_infrastructure (id_type_infrastructure, id_statistiques, nombre, observations) VALUES
(1, 1, 3, 'Ponts sur N3'), -- 3 Ponts sur la route (route 1) en 2023 (stats 1)
(1, 6, 4, 'Nouveaux ponts ajoutés'), -- 4 Ponts sur la route (route 1) en 2024 (stats 6)
(2, 2, 1, 'Un tunnel sur Boulevard République'), -- 1 Tunnel sur route 2 en 2023 (stats 2)
(3, 1, 2, 'Deux échangeurs majeurs'), -- 2 Échangeurs sur route 1 en 2023 (stats 1)
(4, 4, 5, 'Passages à niveau sur N1'), -- 5 Passages à niveau sur route 10 en 2023 (stats 4)
(1, 7, 1, 'Pont sur route 5'), -- 1 Pont sur route 5 en 2024 (stats 7)
(1, 8, 2, 'Ponts sur route 12'), -- 2 Ponts sur route 12 en 2024 (stats 8)
(3, 9, 1, 'Échangeur sur route 15'), -- 1 Échangeur sur route 15 en 2024 (stats 9)
(4, 10, 3, 'Passages à niveau sur route 17'); -- 3 Passages à niveau sur route 17 en 2024 (stats 10)


-- Accident_Gravite
-- Assuming Accident IDs 1-15 and Gravite_Accident IDs 1-4
INSERT INTO accident_gravite (id_accident, id_gravite_accident, nombre, observations) VALUES
(1, 4, 2, '2 morts'), -- Accident 1, 2 morts (Mortel)
(1, 2, 5, '5 blessés graves'), -- Accident 1, 5 blessés (Grave)
(1, 1, 8, '8 blessés légers'), -- Accident 1, 8 blessés (Léger)
(2, 4, 1, '1 mort'), -- Accident 2, 1 mort (Mortel)
(2, 2, 3, null), -- Accident 2, 3 blessés (Grave)
(3, 1, 10, null), -- Accident 3, 10 blessés (Léger)
(5, 3, 2, '2 personnes dans un état critique'), -- Accident 5, 2 blessés (Très grave)
(9, 4, 1, 'Le piéton est décédé'), -- Accident 9, 1 mort (Mortel)
(12, 2, 4, '4 blessés graves'), -- Accident 12, 4 blessés (Grave)
(14, 4, 1, '1 mort dans le choc frontal'); -- Accident 14, 1 mort (Mortel)


-- Accident_Blesse_Sexe & Accident_Mort_Sexe
-- Assuming Accident IDs 1-15 and Sexe_Passager IDs 1-3 (Homme, Femme, Non spécifié)
INSERT INTO accident_blesse_sexe (id_accident, id_sexe_passager, nombre) VALUES
(1, 1, 5), (1, 2, 8), -- Accident 1: 5 H, 8 F blessés (total 13, matches 5+8 in gravite_accident)
(2, 1, 3), -- Accident 2: 3 H blessés
(3, 1, 6), (3, 2, 4), -- Accident 3: 6 H, 4 F blessés (total 10)
(5, 1, 2), -- Accident 5: 2 H blessés
(12, 1, 3), (12, 2, 1); -- Accident 12: 3 H, 1 F blessés (total 4)

INSERT INTO accident_mort_sexe (id_accident, id_sexe_passager, nombre) VALUES
(1, 1, 2), -- Accident 1: 2 H morts
(2, 2, 1), -- Accident 2: 1 F mort
(9, 1, 1), -- Accident 9: 1 H mort
(14, 1, 1); -- Accident 14: 1 H mort

-- Accident_Blesse_Categorie & Accident_Mort_Categorie
-- Assuming Accident IDs 1-15 and Categorie_Passager IDs 1-4 (Conducteur, Passager, Piéton, Cycliste)
INSERT INTO accident_blesse_categorie (id_accident, id_categorie_passager, nombre) VALUES
(1, 1, 2), (1, 2, 9), (1, 3, 2), -- Accident 1: 2 Cond, 9 Pass, 2 Piétons blessés (total 13)
(2, 1, 1), (2, 2, 2), -- Accident 2: 1 Cond, 2 Passagers blessés (total 3)
(3, 1, 1), (3, 2, 7), (3, 4, 2), -- Accident 3: 1 Cond, 7 Pass, 2 Cyclistes blessés (total 10)
(5, 1, 1), (5, 2, 1), -- Accident 5: 1 Cond, 1 Passager blessés (total 2)
(12, 1, 2), (12, 2, 2); -- Accident 12: 2 Cond, 2 Passagers blessés (total 4)

INSERT INTO accident_mort_categorie (id_accident, id_categorie_passager, nombre) VALUES
(1, 1, 1), (1, 2, 1), -- Accident 1: 1 Cond, 1 Passager morts (total 2)
(2, 1, 1), -- Accident 2: 1 Conducteur mort
(9, 3, 1), -- Accident 9: 1 Piéton mort
(14, 1, 1); -- Accident 14: 1 Conducteur mort


-- Projet_Source_Financement
-- Assuming Projet IDs 1-15 and Source_Financement IDs 1-4
INSERT INTO projet_source_financement (id_projet, id_source_financement, montant, observations) VALUES
(1, 1, 5000000000.00, 'Budget public national'), -- Projet 1 (Élargissement A3) par Public
(1, 4, 7500000000.00, 'Prêt Banque Mondiale'), -- Projet 1 par International
(2, 1, 1000000000.00, 'Budget municipal'), -- Projet 2 (Gare DLA) par Public
(2, 3, 500000000.00, 'Partenariat avec société privée'), -- Projet 2 par PPP
(3, 1, 800000000.00, null), -- Projet 3 (Réhab Blvd Rep) par Public
(4, 1, 200000000.00, 'Budget État'), -- Projet 4 (Étude Tram YAO) par Public
(4, 4, 50000000.00, 'Subvention UE'), -- Projet 4 par International
(7, 1, 300000000.00, null), -- Projet 7 (Réparation Pont Edéa) par Public
(10, 3, 15000000000.00, 'PPP avec Bolloré'), -- Projet 10 (Port Kribi) par PPP
(10, 4, 10000000000.00, 'Investissement Chinois'); -- Projet 10 par International


-- Projet_Ville
-- Assuming Projet IDs 1-15 and Ville IDs 1-15
INSERT INTO projet_ville (id_projet, id_ville) VALUES
(1, 1), (1, 2), -- Élargissement A3 concerne Douala et Yaoundé
(2, 1), -- Gare Routière DLA à Douala
(3, 1), -- Réhabilitation Blvd République à Douala
(4, 2), -- Étude Tram YAO à Yaoundé
(5, 4), -- Signalisation Kumba à Kumba
(6, 9), (6, 5), -- Aire Repos N1 concerne Ngaoundéré et Garoua
(7, 10), -- Pont Edéa à Edéa
(8, 2), -- Réseau Bus Yaoundé Sud à Yaoundé
(9, 3), -- Voies Cyclables Buea à Buea
(10, 11), -- Port Kribi à Kribi
(11, 7), -- Contournement Bafoussam à Bafoussam
(12, 5), -- Transport Électrique Garoua à Garoua
(13, 2), -- Aménagement Centroïde Obili à Yaoundé (assuming Obili is in Yaounde)
(14, 7), (14, 15), -- Route Bafoussam-Banyo concerne Bafoussam et Bamenda (assuming Banyo is near Bamenda)
(15, 1); -- Analyse Trafic Douala à Douala

-- Vehicule_Tranche_Age
-- Assuming Vehicule IDs 1-20 and Tranche_Age IDs 1-5
-- This table structure is a bit odd, linking *specific vehicle instances* to age tranches,
-- but following the schema, we'll link some instances to age ranges.
INSERT INTO vehicule_tranche_age (id_vehicule, id_tranche_age, nombre, observations) VALUES
(1, 3, 1, '1 véhicule (celui avec ID 1) dans la tranche 25-44 ans?'), -- Ambiguous schema usage
(6, 2, 1, '1 véhicule (celui avec ID 6) dans la tranche 15-24 ans?'),
(9, 5, 1, '1 véhicule (celui avec ID 9) dans la tranche 65+ ans?'); -- Data meaning is unclear from schema


-- Vehicule_Tranche_Poids
-- Assuming Vehicule IDs 1-20 and Tranche_Poids IDs 1-3
-- Similar ambiguity to Tranche_Age
INSERT INTO vehicule_tranche_poids (id_vehicule, id_tranche_poids, nombre, observations) VALUES
(1, 1, 1, '1 véhicule (celui avec ID 1) dans la tranche 0-1t?'),
(8, 2, 1, '1 véhicule (celui avec ID 8) dans la tranche 1-3.5t?'),
(2, 3, 1, '1 véhicule (celui avec ID 2) dans la tranche 3.5t+?');


-- Vehicule_Ville
-- Assuming Vehicule IDs 1-20 (interpreting as vehicle types/models) and Ville IDs 1-15
-- Using 'nombre' attribute to represent fleet count per type/city.
INSERT INTO vehicule_ville (id_vehicule, id_ville) VALUES
(1, 1), -- Corolla in Douala
(1, 2), -- Corolla in Yaoundé
(6, 1), -- Model 3 in Douala
(6, 2), -- Model 3 in Yaoundé
(2, 1), -- Actros in Douala
(2, 4), -- Actros in Kumba
(3, 2), -- Hiace in Yaoundé
(3, 7), -- Hiace in Bafoussam
(5, 1), -- VéloVille in Douala
(5, 3); -- VéloVille in Buea

-- Vehicule_Route
-- Assuming Vehicule IDs 1-20 (interpreting as vehicle types) and Route IDs 1-20
-- Using 'nombre' attribute to represent frequency or count on a route.
INSERT INTO vehicule_route (id_vehicule, id_route) VALUES
(2, 1), -- Actros on Route 1 (A3T)
(2, 10), -- Actros on Route 10 (N1T)
(3, 1), -- Hiace on Route 1 (A3T)
(3, 18), -- Hiace on Route 18
(1, 2), -- Corolla on Route 2
(6, 2), -- Model 3 on Route 2
(5, 9), -- VéloVille on Route 9 (VC-BUE)
(4, 4); -- FZ-S on Route 4


-- Marque_Modele
-- Assuming Marque IDs 1-7 and Modele IDs 1-8
-- Using 'nombre' attribute, unclear purpose per schema, maybe count of variants?
INSERT INTO marque_modele (id_marque, id_modele, nombre) VALUES
(1, 1, null), -- Toyota Corolla
(1, 3, null), -- Toyota Hiace
(2, 2, null), -- Mercedes Actros
(3, 4, null), -- Yamaha FZ-S
(4, 5, null), -- Specialized VéloVille
(5, 6, null), -- Tesla Model 3
(6, 7, null), -- Nissan Leaf
(7, 8, null); -- Renault Kangoo


-- Fin des insertions de données test.