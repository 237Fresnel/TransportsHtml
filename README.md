# TransportsHtml

Ce projet est une page web simple qui présente des informations sur différents moyens de transport. Il est composé principalement de deux fichiers :

- `index.html` : le fichier principal qui contient le code HTML de la page.
- `style.css` : la feuille de style associée pour l'apparence visuelle.

## Fonctionnalités
- Affichage d'une page web statique listant différents moyens de transport.
- Mise en forme personnalisée via CSS.

## Comment ça fonctionne ?
1. Ouvrez le fichier `index.html` dans un navigateur web moderne (comme Chrome, Firefox, Edge, etc.).
2. Le navigateur affichera automatiquement la page avec les styles définis dans `style.css` (assurez-vous que les deux fichiers sont dans le même dossier).

## Lancer le projet

### 1. Frontend (interface web)
Aucune installation n'est nécessaire pour la partie interface :

1. Télécharger ou cloner le dossier contenant `index.html`, `style.css` et `script.js`.
2. Double-cliquer sur `index.html` ou l'ouvrir avec votre navigateur préféré.

### 2. Backend (ExpressJS + PostgreSQL)
Pour enregistrer les données des formulaires dans la base PostgreSQL `transports` :

1. Installer [Node.js](https://nodejs.org/) et [PostgreSQL](https://www.postgresql.org/) si ce n'est pas déjà fait.
2. Créer la base de données `transports` et les tables nécessaires (voir plus bas).
3. Aller dans le dossier `backend` :
   ```bash
   cd backend
   ```
4. Installer les dépendances :
   ```bash
   npm install
   ```
5. Lancer le serveur backend :
   ```bash
   npm start
   ```
6. Le backend écoute sur http://localhost:3000

### 3. Structure du projet
```
transportsHtml/
├── index.html
├── style.css
├── script.js
├── README.md
└── backend/
    ├── server.js
    └── package.json
```

### 4. Connexion à PostgreSQL
- Par défaut, la connexion utilise :
  - utilisateur : `postgres`
  - mot de passe : `postgres`
  - base : `transports`
  - port : `5432`
- Modifiez ces paramètres dans `backend/server.js` si besoin.

### 5. Création des tables (exemple SQL)
Adaptez selon vos besoins :
```sql
CREATE TABLE villes (
  id SERIAL PRIMARY KEY,
  nom_ville VARCHAR(100),
  region VARCHAR(100),
  population INTEGER,
  superficie_km2 NUMERIC
);

CREATE TABLE projets (
  id SERIAL PRIMARY KEY,
  id_ville INTEGER,
  nom_projet VARCHAR(100),
  description TEXT,
  date_debut DATE,
  date_fin DATE
);

CREATE TABLE donnees (
  id SERIAL PRIMARY KEY,
  id_ville INTEGER,
  annee INTEGER,
  population INTEGER,
  pib NUMERIC,
  taux_chomage NUMERIC
);

CREATE TABLE flotte (
  id SERIAL PRIMARY KEY,
  id_ville INTEGER,
  type_vehicule VARCHAR(100),
  nombre INTEGER,
  annee INTEGER
);

CREATE TABLE infrastructures (
  id SERIAL PRIMARY KEY,
  id_ville INTEGER,
  type_infrastructure VARCHAR(100),
  nom_infrastructure VARCHAR(100),
  etat VARCHAR(50),
  longueur_km NUMERIC,
  date_construction DATE
);

CREATE TABLE accidents (
  id SERIAL PRIMARY KEY,
  id_ville INTEGER,
  date_accident DATE,
  nombre_vehicules_implique INTEGER,
  nombre_blesses INTEGER,
  nombre_morts INTEGER,
  cause_probable VARCHAR(255),
  lieu_accident VARCHAR(255)
);
```

## Auteur
- KENGNE TUEGUEM FRESNEL GRACE

N'hésitez pas à modifier ou à adapter le projet selon vos besoins !
