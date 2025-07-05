// script.js
// Envoie les données des formulaires au backend ExpressJS et gère l'affichage des données

document.addEventListener('DOMContentLoaded', () => {
    // Gestion des onglets
    const tabLinks = document.querySelectorAll('.tab-link');
    const tabContents = document.querySelectorAll('.tab-content');
    tabLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            // Retire la classe active de tous les onglets
            tabLinks.forEach(l => l.classList.remove('active'));
            // Ajoute la classe active à l'onglet cliqué
            this.classList.add('active');
            // Masque toutes les sections
            tabContents.forEach(section => section.classList.remove('active'));
            // Affiche la section correspondant à l'onglet
            const tabId = this.getAttribute('data-tab');
            const targetSection = document.getElementById(tabId);
            if (targetSection) {
                targetSection.classList.add('active');
                // --- Charger les données quand l'onglet est activé ---
                fetchData(tabId, `list-${tabId}`);
            }
        });
    });

    // --- Création (POST) Operations ---

    const forms = [
        'form-villes', // Corresponds to 'ville' table API endpoint /api/villes
        'form-routes', // Corresponds to 'route' table API endpoint /api/routes
        'form-projets', // Corresponds to 'projet' table API endpoint /api/projets
        'form-vehicules', // Corresponds to 'vehicule' table API endpoint /api/vehicules
        'form-accidents', // Corresponds to 'accident' table API endpoint /api/accidents
        'form-gares', // Corresponds to 'gare' table API endpoint /api/gares
        'form-aires_repos', // Corresponds to 'aire_repos' table API endpoint /api/aires_repos
        'form-ponts', // Corresponds to 'pont' table API endpoint /api/ponts
        'form-centroides' // Corresponds to 'centroide' table API endpoint /api/centroides
        // Add other forms for other entities if needed
    ];
    forms.forEach(formId => {
        const form = document.getElementById(formId);
        if (form) {
            form.addEventListener('submit', function (e) {
                e.preventDefault();
                // Préparer les données du formulaire
                const data = {};
                Array.from(form.elements).forEach(el => {
                    // Inclure seulement les éléments avec un 'name' et une 'value' définie
                    if (el.name && el.value !== undefined && el.value !== '') {
                         // Tentative de conversion en nombre si le type est number
                         if (el.type === 'number') {
                              data[el.name] = Number(el.value);
                         } else {
                             data[el.name] = el.value;
                         }
                    } else if (el.name && (el.value === undefined || el.value === '')) {
                         // Gérer les champs vides explicitement comme null si nécessaire pour la BD
                         // Ou simplement ne pas les inclure dans le payload si le backend gère les valeurs manquantes
                         // Pour l'instant, on les omet s'ils sont vides.
                    }
                });

                // Gérer les champs JSON : 'localisation' et 'position'
                // Le backend s'attend à un objet JSON ou null
                if (data.localisation) {
                     try { data.localisation = JSON.parse(data.localisation); } catch (e) { console.error("JSON invalide pour localisation:", e); data.localisation = null; } // Envoyer null si JSON invalide
                } else if (data.localisation === '') { // Si le champ était vide
                    data.localisation = null;
                }

                 if (data.position) {
                     try { data.position = JSON.parse(data.position); } catch (e) { console.error("JSON invalide pour position:", e); data.position = null; } // Envoyer null si JSON invalide
                } else if (data.position === '') { // Si le champ était vide
                    data.position = null;
                }


                // Déterminer le point d'API cible basé sur l'ID du formulaire
                const endpoint = formId.replace('form-', ''); // Ex: 'form-villes' -> 'villes'

                fetch(`http://localhost:3000/api/${endpoint}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                })
                .then(res => {
                    if (!res.ok) {
                        // Tenter de lire l'erreur du backend si disponible
                        return res.json().then(errJson => { throw new Error(errJson.error || `Erreur réseau, statut ${res.status}`); });
                    }
                    return res.json();
                })
                .then(result => {
                    alert('Succès: ' + (result.message || 'Enregistré !'));
                    form.reset(); // Réinitialiser le formulaire après succès
                    // Recharger la liste des données après ajout
                    fetchData(endpoint, `list-${endpoint}`);
                })
                .catch(err => {
                    console.error(`Erreur lors de l\'envoi du formulaire ${formId}:`, err);
                    alert('Erreur lors de l\'envoi: ' + err.message);
                });
            });
        }
    }); // Fin forms.forEach

    // --- Read (GET) Operations ---

    // Fonction pour récupérer et afficher les données pour un point d'API et un élément de liste donnés
    async function fetchData(endpoint, listId) {
        const listElement = document.getElementById(listId);
        if (!listElement) return;
        listElement.innerHTML = '<h3>Chargement...</h3>'; // Indicateur de chargement

        try {
            // Adjusted endpoint mapping for 'villes' to 'ville' in the backend if needed,
            // but for now, the frontend uses 'villes' endpoint and backend listens on '/api/villes' and maps to 'ville' table.
            const res = await fetch(`http://localhost:3000/api/${endpoint}`);
            if (!res.ok) {
                throw new Error(`Erreur HTTP! statut: ${res.status}`);
            }
            const data = await res.json();
            displayData(data, listElement, endpoint); // Afficher les données récupérées
        } catch (err) {
            console.error(`Erreur lors du chargement des données pour ${endpoint}:`, err);
            listElement.innerHTML = `<h3>Erreur de chargement : ${err.message}</h3>`;
        }
    }

    // Fonction pour afficher les données dans un tableau
    function displayData(data, listElement, endpoint) {
        listElement.innerHTML = `<h3>Liste des ${endpoint.charAt(0).toUpperCase() + endpoint.slice(1)} (${data.length})</h3>`;
        if (data.length === 0) {
            listElement.innerHTML += '<p>Aucune donnée disponible.</p>';
            return;
        }

        // Créer un tableau
        const table = document.createElement('table');
        const thead = table.createTHead();
        const tbody = table.createTBody();
        const headerRow = thead.insertRow();

        // Créer les en-têtes à partir des clés du premier objet de données
        // Exclure les champs 'created_at' et 'updated_at' de l'affichage si trop verbeux, ou les formater.
        const keys = Object.keys(data[0]).filter(key => key !== 'created_at' && key !== 'updated_at');

        keys.forEach(key => {
            const th = document.createElement('th');
            th.textContent = key.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase()); // Format snake_case to Title Case
            headerRow.appendChild(th);
        });
         // Ajouter l'en-tête pour les Actions (Modifier/Supprimer)
        const thActions = document.createElement('th');
        thActions.textContent = 'Actions';
        headerRow.appendChild(thActions);

        // Remplir le corps du tableau avec les lignes de données
        data.forEach(item => {
            const row = tbody.insertRow();
            keys.forEach(key => {
                const cell = row.insertCell();
                // Formatage basique pour les types complexes ou dates
                 let cellContent = item[key];
                 if (cellContent === null) {
                     cellContent = 'N/A'; // Afficher null comme N/A
                 } else if (typeof cellContent === 'object') {
                     cellContent = JSON.stringify(cellContent, null, 2); // Afficher les objets JSON joliment formatés
                 } else if ((key.includes('date'))) { // Format les champs dont le nom inclut 'date'
                      try {
                        const dateObj = new Date(cellContent);
                        if (!isNaN(dateObj.getTime())) {
                            cellContent = dateObj.toISOString().split('T')[0]; // Format YYYY-MM-DD
                        } else {
                             cellContent = String(cellContent); // Fallback if date parsing fails
                        }
                     } catch (e) {
                         cellContent = String(cellContent); // Fallback
                     }
                 } else {
                     cellContent = String(cellContent); // Assurer que tout est une chaîne
                 }
                cell.textContent = cellContent;
            });
             // Ajouter les boutons d'action (Modifier/Supprimer)
            const cellActions = row.insertCell();
            // IMPORTANT: Ensure your tables have an 'id' column as the primary key for this to work.
            // The schema.sql provided uses 'id' as PRIMARY KEY for main entities.
            if (item.id !== undefined) {
                 cellActions.innerHTML = `
                    <button onclick="editItem('${endpoint}', ${item.id})">Modifier</button>
                    <button onclick="deleteItem('${endpoint}', ${item.id})">Supprimer</button>
                 `;
            } else {
                cellActions.textContent = 'Pas d\'ID pour CRUD'; // Message if item has no ID
            }
        });

        listElement.appendChild(table);
    }

    // --- Initialisation ---

    // Charger les données pour l'onglet actif par défaut au chargement de la page
    const activeTab = document.querySelector('.tab-link.active');
    if (activeTab) {
        const tabId = activeTab.getAttribute('data-tab');
        fetchData(tabId, `list-${tabId}`);
    }

    // --- CRUD (Update/Delete implementations) ---

    // Implémentation de la fonctionnalité Modifier
    // Cette fonction devrait idéalement récupérer les données de l'élément et pré-remplir le formulaire pour l'édition
    // NOTE : Pour une application complète, il faudrait un formulaire dédié ou modifier l'existant dynamiquement pour l'édition.
    // Pour cet exemple, nous affichons simplement un message.
    window.editItem = async (endpoint, itemId) => {
        alert(`Fonctionnalité "Modifier" pour l'élément ${itemId} de ${endpoint} à implémenter.`);
        console.log(`Tentative de modification de l'élément ${itemId} de ${endpoint}`);
        // Exemple: Récupérer les données de l'élément pour pré-remplir un formulaire d'édition
        // try {
        //     const res = await fetch(`http://localhost:3000/api/${endpoint}/${itemId}`);
        //     if (!res.ok) throw new Error(`Élément ${itemId} non trouvé.`);
        //     const itemData = await res.json();
        //     console.log("Données pour édition:", itemData);
        //     // Ici, vous implémenteriez la logique pour trouver le bon formulaire et le remplir
        //     // avec itemData, et changer son action pour envoyer un PUT au lieu de POST.
        //     // Cela nécessite une logique plus complexe que ce simple script.
        // } catch (err) {
        //     console.error(`Erreur lors du chargement pour modification de ${endpoint}/${itemId}:`, err);
        //     alert(`Erreur lors du chargement des données pour modification: ${err.message}`);
        // }
    };

    // Implémentation de la fonctionnalité Supprimer
    window.deleteItem = async (endpoint, itemId) => {
        if (confirm(`Êtes-vous sûr de vouloir supprimer l'élément ${itemId} de ${endpoint} ?`)) {
            try {
                const res = await fetch(`http://localhost:3000/api/${endpoint}/${itemId}`, {
                    method: 'DELETE',
                });
                if (!res.ok) {
                     // Tenter de lire l'erreur du backend si disponible
                    return res.json().then(errJson => { throw new Error(errJson.error || `Erreur réseau, statut ${res.status}`); });
                }
                // La suppression a réussi
                alert('Élément supprimé avec succès !');
                // Recharger la liste des données pour refléter la suppression
                fetchData(endpoint, `list-${endpoint}`);
            } catch (err) {
                console.error(`Erreur lors de la suppression de ${endpoint}/${itemId}:`, err);
                alert('Erreur lors de la suppression : ' + err.message);
            }
        }
    };

     // --- Fonctionnalités Avancées (Non implémentées dans cet exemple simple) ---
     // Pour une application complète, il faudrait:
     // 1. Récupérer les données des tables de référence (e.g., /api/type_revetement)
     // 2. Peupler les <select> dans les formulaires avec ces données.
     // 3. Implémenter les routes GET par ID, PUT et DELETE pour TOUTES les entités principales.
     // 4. Gérer l'édition en chargeant les données de l'élément dans le formulaire d'ajout (qui deviendrait un formulaire d'édition) ou dans un formulaire séparé/modal.
     // 5. Gérer les relations N-N (tables de jointure) via des formulaires et endpoints dédiés.
});