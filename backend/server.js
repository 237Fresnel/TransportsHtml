// Backend ExpressJS pour recevoir les données et les insérer dans PostgreSQL 'transports' database
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();

// Middleware pour définir la Content-Security-Policy
app.use((req, res, next) => {
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'self'; img-src 'self' http://localhost:3000; script-src 'self';"
  );
  next();
});
const port = 3000;

app.use(cors());
app.use(express.json());

// Connexion à PostgreSQL
const pool = new Pool({
    user: 'postgres', // à adapter si besoin
    host: 'localhost',
    database: 'transports',
    // password: 'votre_mot_de_passe', // Décommentez et mettez votre mot de passe si besoin
    // Si aucun mot de passe, laissez la ligne ci-dessous
   // password: null,
    port: 5432,
});

// Vérification de la connexion à la base de données
pool.connect((err, client, release) => {
    if (err) {
        console.error('Erreur de connexion à la base de données :', err.stack);
    } else {
        console.log('Connexion à la base de données réussie !');
        release();
    }
});

// Helpers pour insertions
async function insertData(table, data) {
    const keys = Object.keys(data);
    const values = Object.values(data);
    const params = keys.map((_, i) => `$${i + 1}`).join(', ');
    
    // Échapper les noms de colonnes qui contiennent des majuscules
    const escapedKeys = keys.map(key => {
        // Si le nom contient des majuscules, on l'entoure de guillemets doubles
        if (key !== key.toLowerCase()) {
            return `"${key}"`;
        }
        return key;
    });
    
    const sql = `INSERT INTO ${table} (${escapedKeys.join(', ')}) VALUES (${params}) RETURNING *`;
    const { rows } = await pool.query(sql, values);
    return rows[0];
}

// Routes pour chaque formulaire
app.post('/api/villes', async (req, res) => {
    try {
        let { nom, population, superficie, coordonnees, lat, lng } = req.body;
        const now = new Date().toISOString();

        // S'assurer que population et superficie sont des nombres
        population = population !== undefined && population !== null && population !== '' ? Number(population) : null;
        superficie = superficie !== undefined && superficie !== null && superficie !== '' ? Number(superficie) : null;

        // Gestion robuste des coordonnées
        let coordObj = null;
        if (coordonnees && typeof coordonnees === 'object') {
            coordObj = coordonnees;
        } else if (typeof coordonnees === 'string') {
            try {
                coordObj = JSON.parse(coordonnees);
            } catch (e) {
                coordObj = null;
            }
        } else if (lat !== undefined && lng !== undefined) {
            coordObj = { lat: Number(lat), lng: Number(lng) };
        }

        // Nettoyage du nom
        nom = nom ? nom.trim() : null;

        const villeData = {
            nom,
            population,
            superficie,
            coordonnees: coordObj,
            createdAt: now,
            updatedAt: now
        };

        const row = await insertData('villes', villeData);
        res.json({ message: 'Ville ajoutée', data: row });
        console.log("Insertion ville OK");
    } catch (err) {
        console.log("ERREUR insertion ville", err);
        res.status(500).json({ error: err.message });
    }
});

// NOUVELLE ROUTE POUR RÉCUPÉRER TOUTES LES VILLES (GET)
app.get('/api/villes', async (req, res) => {
    try {
        // N'oubliez pas les guillemets pour les colonnes avec des majuscules
        const result = await pool.query('SELECT id_ville, population, nom, superficie, coordonnees, "createdAt", "updatedAt" FROM villes');
        res.json(result.rows); // Renvoie toutes les lignes trouvées
    } catch (err) {
        console.error('Erreur lors de la récupération des villes :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération des villes.' });
    }
});

// Optionnel : Route pour récupérer une ville par son ID
app.get('/api/villes/:id', async (req, res) => {
    try {
        const { id } = req.params;
        // N'oubliez pas les guillemets pour les colonnes avec des majuscules
        const result = await pool.query('SELECT id_ville, population, nom, superficie, coordonnees, "createdAt", "updatedAt" FROM villes WHERE id_ville = $1', [id]);
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).json({ message: 'Ville non trouvée' });
        }
    } catch (err) {
        console.error('Erreur lors de la récupération de la ville :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération de la ville.' });
    }
});

app.post('/api/projets', async (req, res) => {
    try {
        let { id_ville, nom_projet, description, date_debut, date_fin, statut } = req.body;
        
        // Nettoyage et validation des données
        // Conversion de id_ville en nombre si présent
        id_ville = id_ville !== undefined && id_ville !== null && id_ville !== '' ? Number(id_ville) : null;
        
        // Nettoyage des chaînes de caractères
        nom_projet = nom_projet ? nom_projet.trim() : null;
        description = description ? description.trim() : null;
        statut = statut ? statut.trim() : null;
        
        // Validation des dates
        let date_debut_formatted = null;
        let date_fin_formatted = null;
        
        if (date_debut) {
            try {
                // Si c'est déjà au format YYYY-MM-DD, on le garde tel quel
                if (/^\d{4}-\d{2}-\d{2}$/.test(date_debut)) {
                    date_debut_formatted = date_debut;
                } else {
                    // Sinon on essaie de le convertir
                    const dateObj = new Date(date_debut);
                    if (!isNaN(dateObj.getTime())) {
                        date_debut_formatted = dateObj.toISOString().split('T')[0]; // Format YYYY-MM-DD
                    }
                }
            } catch (e) {
                console.log("Erreur de conversion de date_debut", e);
            }
        }
        
        if (date_fin) {
            try {
                // Si c'est déjà au format YYYY-MM-DD, on le garde tel quel
                if (/^\d{4}-\d{2}-\d{2}$/.test(date_fin)) {
                    date_fin_formatted = date_fin;
                } else {
                    // Sinon on essaie de le convertir
                    const dateObj = new Date(date_fin);
                    if (!isNaN(dateObj.getTime())) {
                        date_fin_formatted = dateObj.toISOString().split('T')[0]; // Format YYYY-MM-DD
                    }
                }
            } catch (e) {
                console.log("Erreur de conversion de date_fin", e);
            }
        }
        
        // Préparation des données pour l'insertion
        const projetData = {
            id_ville,
            nom_projet,
            description,
            date_debut: date_debut_formatted,
            date_fin: date_fin_formatted,
            statut
        };
        
        const row = await insertData('projets', projetData);
        res.json({ message: 'Projet ajouté', data: row });
        console.log("Insertion projet OK");
    } catch (err) {
        console.log("ERREUR insertion projet", err);
        res.status(500).json({ error: err.message });
    }
});

// Route GET pour récupérer tous les projets
app.get('/api/projets', async (req, res) => {
    try {
        // Colonnes exactes de votre table projets
        const result = await pool.query('SELECT id_projet, id_ville, nom_projet, description, date_debut, date_fin, statut FROM projets');
        res.json(result.rows);
    } catch (err) {
        console.error('Erreur lors de la récupération des projets :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération des projets.' });
    }
});

// Route GET pour récupérer un projet par son ID
app.get('/api/projets/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT id_projet, id_ville, nom_projet, description, date_debut, date_fin, statut FROM projets WHERE id_projet = $1', [id]);
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).json({ message: 'Projet non trouvé' });
        }
    } catch (err) {
        console.error('Erreur lors de la récupération du projet :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération du projet.' });
    }
});


app.post('/api/donnees', async (req, res) => {
    try {
        const row = await insertData('donnees', req.body);
        res.json({ message: 'Donnée ajoutée', data: row });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/flotte', async (req, res) => {
    try {
        const row = await insertData('flotte', req.body);
        res.json({ message: 'Flotte ajoutée', data: row });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/infrastructures', async (req, res) => {
    try {
        let { id_ville, type_infrastructure, nom_infrastructure, etat, longueur_km, date_construction } = req.body;

        // Nettoyage et typage
        id_ville = id_ville !== undefined && id_ville !== null && id_ville !== '' ? Number(id_ville) : null;
        type_infrastructure = type_infrastructure ? type_infrastructure.trim() : null;
        nom_infrastructure = nom_infrastructure ? nom_infrastructure.trim() : null;
        etat = etat ? etat.trim() : null;
        longueur_km = longueur_km !== undefined && longueur_km !== null && longueur_km !== '' ? Number(longueur_km) : null;

        // Gestion de la date
        let date_construction_formatted = null;
        if (date_construction) {
            if (/^\d{4}-\d{2}-\d{2}$/.test(date_construction)) {
                date_construction_formatted = date_construction;
            } else {
                const dateObj = new Date(date_construction);
                if (!isNaN(dateObj.getTime())) {
                    date_construction_formatted = dateObj.toISOString().split('T')[0];
                }
            }
        }

        const infraData = {
            id_ville,
            type_infrastructure,
            nom_infrastructure,
            etat,
            longueur_km,
            date_construction: date_construction_formatted
        };

        const row = await insertData('infrastructures', infraData);
        res.json({ message: 'Infrastructure ajoutée', data: row });
        console.log("Insertion infrastructure OK");
    } catch (err) {
        console.log("ERREUR insertion infrastructure", err);
        res.status(500).json({ error: err.message });
    }
});

// GET infrastructures
app.get('/api/infrastructures', async (req, res) => {
    try {
        const result = await pool.query('SELECT id_infra, id_ville, type_infrastructure, nom_infrastructure, etat, longueur_km, date_construction FROM infrastructures');
        res.json(result.rows);
    } catch (err) {
        console.error('Erreur lors de la récupération des infrastructures :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération des infrastructures.' });
    }
});

// GET flotte
app.get('/api/flotte', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM flotte');
        res.json(result.rows);
    } catch (err) {
        console.error('Erreur lors de la récupération de la flotte :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération de la flotte.' });
    }
});

// GET donnees
app.get('/api/donnees', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM donnees');
        res.json(result.rows);
    } catch (err) {
        console.error('Erreur lors de la récupération des donnees :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération des donnees.' });
    }
});

// GET accidents
app.get('/api/accidents', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM accidents');
        res.json(result.rows);
    } catch (err) {
        console.error('Erreur lors de la récupération des accidents :', err.message);
        res.status(500).json({ error: 'Erreur serveur lors de la récupération des accidents.' });
    }
});

app.post('/api/accidents', async (req, res) => {
    try {
        const row = await insertData('accidents', req.body);
        res.json({ message: 'Accident ajouté', data: row });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(port, () => {
    console.log(`Serveur backend démarré sur http://localhost:${port}`);
});
