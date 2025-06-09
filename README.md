# create-project.sh

Un script Bash interactif pour générer rapidement une structure de projet web moderne (HTML/CSS, React, Next.js, Astro) avec le gestionnaire de paquets de ton choix (npm, yarn, pnpm).

## Fonctionnalités
- Choix du gestionnaire de paquets (npm, yarn, pnpm)
- Installation automatique du gestionnaire si besoin
- Création de projets :
  - **HTML/CSS** : structure minimale avec un fichier `index.html`
  - **React** (via Vite) : structure moderne, option single page ou multipages (avec react-router-dom)
  - **Next.js** : structure Next.js prête à l’emploi
  - **Astro** : site statique moderne optimisé avec Astro
- Structure de dossiers adaptée au type de projet

## Utilisation
```bash
./create-project.sh
```

Réponds aux questions pour configurer ton projet.

## Prérequis
- Bash
- Node.js
- Un gestionnaire de paquets (npm, yarn ou pnpm)

## Licence
Ce projet est distribué sous licence MIT (voir [LICENSE](./LICENSE)).

## Contribuer
Les contributions sont les bienvenues ! Pour proposer une amélioration ou corriger un bug, merci de faire une Pull Request (PR).

## Auteur
Créé par EsperluWeb. Merci de créditer l’auteur en cas d’utilisation ou de fork !
