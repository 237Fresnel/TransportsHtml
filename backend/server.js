// Backend ExpressJS pour recevoir les données et les insérer dans PostgreSQL 'transports' database
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();

// Middleware pour définir la Content-Security-Policy (peut être ajusté si nécessaire)
app.use((req, res, next) => {
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'self'; img-src 'self'; script-src 'self' 'unsafe-inline';" // Added 'unsafe-inline' for simplicity with inline event handlers like onclick in this example, adjust for better security in production
  );
  next();
});
const port = 3000;

app.use(cors());
app.use(express.json()); // Middleware pour parser le JSON des requêtes

// Connexion à PostgreSQL
const pool = new Pool({
    user: 'postgres', // à adapter si besoin
    host: 'localhost',
    database: 'trip',
    // password: 'votre_mot_de_passe', // Décommentez et mettez votre mot de passe si besoin
    // Si aucun mot de passe, laissez la ligne ci-dessous (ou commentez la ligne password: null)
   // password: null,
    port: 5432,
});

// Vérification de la connexion à la base de données au démarrage du serveur
pool.connect((err, client, release) => {
    if (err) {
        console.error('Erreur de connexion à la base de données :', err.stack);
    } else {
        console.log('Connexion à la base de données réussie !');
        release(); // Libère le client immédiatement après le test de connexion
    }
});

// Helper function for insertions
// Handles snake_case or camelCase column names by quoting if necessary
async function insertData(table, data) {
    const keys = Object.keys(data);
    const values = Object.values(data);
    // Filter out keys with null/undefined values if they are not required by schema,
    // or adjust the SQL query generation for optional fields.
    // For simplicity here, we assume all keys in 'data' correspond to columns.
    const params = keys.map((_, i) => `$${i + 1}`).join(', ');

    // Quote keys to handle snake_case or potential reserved words
    const escapedKeys = keys.map(key => `"${key}"`);

    const sql = `INSERT INTO ${table} (${escapedKeys.join(', ')}) VALUES (${params}) RETURNING *`;
    console.log(`Executing INSERT: ${sql} with values ${JSON.stringify(values)}`); // Log the query
    try {
        const { rows } = await pool.query(sql, values);
        return rows[0];
    } catch (error) {
        console.error(`Error during INSERT into ${table}:`, error);
        throw error; // Re-throw the error to be caught by the route handler
    }
}

// Helper function for updates
async function updateData(table, id, data) {
    const keys = Object.keys(data);
    const values = Object.values(data);
    // Exclude 'id', 'created_at', 'updated_at' from update fields
    const updateKeys = keys.filter(key => key !== 'id' && key !== 'created_at' && key !== 'updated_at');
    const setClauses = updateKeys.map((key, i) => `"${key}" = $${i + 1}`).join(', ');
    const updateValues = updateKeys.map(key => data[key]);

    if (updateKeys.length === 0) {
         // No fields to update (might happen if only ID/timestamps were sent)
         // Optionally fetch and return the existing row or return a message
        console.log(`No updateable fields provided for table ${table} with id ${id}`);
        const existingRow = await pool.query(`SELECT * FROM "${table}" WHERE id = $1`, [id]);
        return existingRow.rows[0]; // Return existing data
    }

    // Add the ID for the WHERE clause
    updateValues.push(id);

    const sql = `UPDATE "${table}" SET ${setClauses}, "updated_at" = NOW() WHERE id = $${updateValues.length} RETURNING *`;
     console.log(`Executing UPDATE: ${sql} with values ${JSON.stringify(updateValues)}`); // Log the query
     try {
        const { rows } = await pool.query(sql, updateValues);
        return rows[0];
    } catch (error) {
         console.error(`Error during UPDATE into ${table} (id: ${id}):`, error);
         throw error;
    }
}


// Helper function for deletes
async function deleteData(table, id) {
     const sql = `DELETE FROM "${table}" WHERE id = $1 RETURNING id`;
     console.log(`Executing DELETE: ${sql} with id ${id}`); // Log the query
     try {
        const { rows } = await pool.query(sql, [id]);
        return rows.length > 0; // Return true if a row was deleted, false otherwise
    } catch (error) {
        console.error(`Error during DELETE from ${table} (id: ${id}):`, error);
        throw error;
    }
}


// Helper to get all data
async function getAllData(table) {
     // Selecting all columns dynamically can be complex due to quoting.
     // It's safer to list columns or assume standard names if possible,
     // or fetch schema information. For simplicity, let's select all,
     // but be aware this might break if columns have complex names needing quotes.
     // The insertData helper quotes on insert, let's try simple select first.
    const sql = `SELECT * FROM "${table}"`; // Quote table name
    console.log(`Executing SELECT ALL: ${sql}`); // Log the query
     try {
        const { rows } = await pool.query(sql);
        return rows;
    } catch (error) {
         console.error(`Error during SELECT ALL from ${table}:`, error);
         throw error;
    }
}

// Helper to get data by ID
async function getDataById(table, id) {
     const sql = `SELECT * FROM "${table}" WHERE id = $1`;
     console.log(`Executing SELECT BY ID: ${sql} with id ${id}`); // Log the query
      try {
        const { rows } = await pool.query(sql, [id]);
        return rows[0]; // Return the first row found
    } catch (error) {
         console.error(`Error during SELECT BY ID from ${table} (id: ${id}):`, error);
         throw error;
    }
}


// --- CRUD Routes for main entities ---

// Ville (anciennement 'villes')
app.post('/api/villes', async (req, res) => { // Create Ville
    try {
        // Data matches the 'ville' table columns
        const villeData = req.body;
        const row = await insertData('ville', villeData);
        res.json({ message: 'Ville ajoutée', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/villes:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/villes', async (req, res) => { // Read All Villes
    try {
        const data = await getAllData('ville');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/villes:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/villes/:id', async (req, res) => { // Read Single Ville
    try {
        const { id } = req.params;
        const data = await getDataById('ville', id);
        if (data) {
            res.json(data);
        } else {
            res.status(404).json({ message: 'Ville non trouvée' });
        }
    } catch (err) {
        console.error("ERREUR GET /api/villes/:id:", err);
        res.status(500).json({ error: err.message });
    }
});
app.put('/api/villes/:id', async (req, res) => { // Update Ville
    try {
        const { id } = req.params;
        const villeData = req.body; // Contains updated fields
        const row = await updateData('ville', id, villeData);
        if (row) {
            res.json({ message: 'Ville mise à jour', data: row });
        } else {
             res.status(404).json({ message: 'Ville non trouvée' });
        }
    } catch (err) {
        console.error("ERREUR PUT /api/villes/:id:", err);
        res.status(500).json({ error: err.message });
    }
});
app.delete('/api/villes/:id', async (req, res) => { // Delete Ville
    try {
        const { id } = req.params;
        const success = await deleteData('ville', id);
        if (success) {
            res.json({ message: 'Ville supprimée' });
        } else {
             res.status(404).json({ message: 'Ville non trouvée' });
        }
    } catch (err) {
        console.error("ERREUR DELETE /api/villes/:id:", err);
        // Check for foreign key constraint errors
        if (err.code === '23503') { // Foreign key violation error code
            res.status(400).json({ error: 'Impossible de supprimer cette ville car elle est liée à d\'autres données (routes, projets, etc.).' });
        } else {
             res.status(500).json({ error: err.message });
        }
    }
});

// Route
app.post('/api/routes', async (req, res) => { // Create Route
    try {
        const routeData = req.body;
        const row = await insertData('route', routeData);
        res.json({ message: 'Route ajoutée', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/routes:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/routes', async (req, res) => { // Read All Routes
     try {
        const data = await getAllData('route');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/routes:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/routes/:id, PUT /api/routes/:id, DELETE /api/routes/:id similarly

// Projet
app.post('/api/projets', async (req, res) => { // Create Projet
    try {
        // Note: frontend form has id_ville, but 'projet' table does not.
        // Linking ville to projet requires inserting into the 'projet_ville' N-N table.
        // For simplicity, this POST only inserts into the 'projet' table itself.
        // A separate endpoint or expanded logic would be needed for 'projet_ville'.
        const projetData = req.body; // Includes id_ville from frontend, which will be ignored by insertData unless 'projet' table changes.
        const row = await insertData('projet', projetData); // Insert into 'projet' table
        res.json({ message: 'Projet ajouté', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/projets:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/projets', async (req, res) => { // Read All Projets
    try {
        const data = await getAllData('projet');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/projets:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/projets/:id, PUT /api/projets/:id, DELETE /api/projets/:id similarly

// Vehicule (from old 'flotte')
app.post('/api/vehicules', async (req, res) => { // Create Vehicule
    try {
        // Note: frontend form has id_ville, but 'vehicule' table does not link directly.
        // Linking vehicule to ville requires inserting into the 'vehicule_ville' N-N table.
        // For simplicity, this POST only inserts into the 'vehicule' table itself.
        // A separate endpoint or expanded logic would be needed for 'vehicule_ville'.
        const vehiculeData = req.body; // Includes id_ville from frontend, which will be ignored.
        const row = await insertData('vehicule', vehiculeData); // Insert into 'vehicule' table
        res.json({ message: 'Véhicule ajouté', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/vehicules:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/vehicules', async (req, res) => { // Read All Vehicules
    try {
        const data = await getAllData('vehicule');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/vehicules:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/vehicules/:id, PUT /api/vehicules/:id, DELETE /api/vehicules/:id similarly

// Accident
app.post('/api/accidents', async (req, res) => { // Create Accident
    try {
        // Note: frontend form has id_ville, but 'accident' table links via id_centroide.
        // id_ville from frontend is ignored here.
        const accidentData = req.body; // Includes id_ville from frontend, ignored.
        const row = await insertData('accident', accidentData); // Insert into 'accident' table
        res.json({ message: 'Accident ajouté', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/accidents:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/accidents', async (req, res) => { // Read All Accidents
    try {
        const data = await getAllData('accident');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/accidents:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/accidents/:id, PUT /api/accidents/:id, DELETE /api/accidents/:id similarly

// Gare
app.post('/api/gares', async (req, res) => { // Create Gare
    try {
        // Note: frontend form has id_ville, but 'gare' table links via id_route.
        // id_ville from frontend is ignored here.
        const gareData = req.body; // Includes id_ville from frontend, ignored.
         // Handle JSON for position
        if (typeof gareData.position === 'string' && gareData.position.trim() !== '') {
            try { gareData.position = JSON.parse(gareData.position); } catch (e) { console.warn("Invalid JSON for gare position:", gareData.position, e); gareData.position = null; }
         } else if (typeof gareData.position !== 'object') { gareData.position = null; }

        const row = await insertData('gare', gareData);
        res.json({ message: 'Gare ajoutée', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/gares:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/gares', async (req, res) => { // Read All Gares
    try {
        const data = await getAllData('gare');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/gares:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/gares/:id, PUT /api/gares/:id, DELETE /api/gares/:id similarly

// Aire_Repos
app.post('/api/aires_repos', async (req, res) => { // Create Aire_Repos
    try {
        // Note: frontend form has id_ville, but 'aire_repos' table links via id_route.
        // id_ville from frontend is ignored here.
        const aireReposData = req.body; // Includes id_ville from frontend, ignored.
        // Handle JSON for localisation
        if (typeof aireReposData.localisation === 'string' && aireReposData.localisation.trim() !== '') {
            try { aireReposData.localisation = JSON.parse(aireReposData.localisation); } catch (e) { console.warn("Invalid JSON for aire_repos localisation:", aireReposData.localisation, e); aireReposData.localisation = null; }
        } else if (typeof aireReposData.localisation !== 'object') { aireReposData.localisation = null; }

        const row = await insertData('aire_repos', aireReposData);
        res.json({ message: 'Aire de repos ajoutée', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/aires_repos:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/aires_repos', async (req, res) => { // Read All Aires_Repos
    try {
        const data = await getAllData('aire_repos');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/aires_repos:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/aires_repos/:id, PUT /api/aires_repos/:id, DELETE /api/aires_repos/:id similarly

// Pont
app.post('/api/ponts', async (req, res) => { // Create Pont
    try {
         // Note: frontend form has id_ville, but 'pont' table links via id_route.
        // id_ville from frontend is ignored here.
        const pontData = req.body; // Includes id_ville from frontend, ignored.
        // Handle JSON for position
        if (typeof pontData.position === 'string' && pontData.position.trim() !== '') {
            try { pontData.position = JSON.parse(pontData.position); } catch (e) { console.warn("Invalid JSON for pont position:", pontData.position, e); pontData.position = null; }
        } else if (typeof pontData.position !== 'object') { pontData.position = null; }

        const row = await insertData('pont', pontData);
        res.json({ message: 'Pont ajouté', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/ponts:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/ponts', async (req, res) => { // Read All Ponts
     try {
        const data = await getAllData('pont');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/ponts:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/ponts/:id, PUT /api/ponts/:id, DELETE /api/ponts/:id similarly

// Centroide
app.post('/api/centroides', async (req, res) => { // Create Centroide
    try {
        const centroideData = req.body;
         // Handle JSON for localisation
        if (typeof centroideData.localisation === 'string' && centroideData.localisation.trim() !== '') {
            try { centroideData.localisation = JSON.parse(centroideData.localisation); } catch (e) { console.warn("Invalid JSON for centroide localisation:", centroideData.localisation, e); centroideData.localisation = null; }
        } else if (typeof centroideData.localisation !== 'object') { centroideData.localisation = null; }
        const row = await insertData('centroide', centroideData);
        res.json({ message: 'Centroïde ajouté', data: row });
    } catch (err) {
        console.error("ERREUR POST /api/centroides:", err);
        res.status(500).json({ error: err.message });
    }
});
app.get('/api/centroides', async (req, res) => { // Read All Centroides
     try {
        const data = await getAllData('centroide');
        res.json(data);
    } catch (err) {
        console.error("ERREUR GET /api/centroides:", err);
        res.status(500).json({ error: err.message });
    }
});
// Add GET /api/centroides/:id, PUT /api/centroides/:id, DELETE /api/centroides/:id similarly

// Note: For the many-to-many tables (signalisation_route, projet_ville, etc.),
// you would need dedicated endpoints (e.g., POST /api/projet_ville to link a project to a city)
// and possibly more complex frontend forms/logic to manage these relationships.
// The current implementation focuses on the main entity tables.


app.listen(port, () => {
    console.log(`Serveur backend démarré sur http://localhost:${port}`);
});