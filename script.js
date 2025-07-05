// script.js
// Envoie les données des formulaires au backend ExpressJS

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
            if (targetSection) targetSection.classList.add('active');
        });
    });

    const forms = [
        'form-villes',
        'form-projets',
        'form-donnees',
        'form-flotte',
        'form-infrastructures',
        'form-accidents'
    ];
    forms.forEach(formId => {
        const form = document.getElementById(formId);
        if (form) {
            form.addEventListener('submit', function (e) {
                e.preventDefault();
                const data = {};
                Array.from(form.elements).forEach(el => {
                    if (el.name && el.value !== undefined) {
                        data[el.name] = el.value;
                    }
                });
                fetch(`http://localhost:3000/api/${formId.replace('form-', '')}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                })
                .then(res => res.json())
                .then(result => {
                    alert('Succès: ' + (result.message || 'Enregistré !'));
                    form.reset();
                })
                .catch(err => {
                    alert('Erreur lors de l\'envoi: ' + err.message);
                });
            });
        }
    });
});
