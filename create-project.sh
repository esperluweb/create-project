#!/bin/bash

cd "$(dirname "$0")"

set -e

echo "📁 Nom du projet :"
read PROJECT_NAME

# Choix du gestionnaire de paquets
echo "📦 Choisis ton gestionnaire de paquets (npm / yarn / pnpm) :"
read PACKAGE_MANAGER

if ! command -v $PACKAGE_MANAGER &> /dev/null; then
  echo "❌ $PACKAGE_MANAGER n'est pas installé. Veux-tu l'installer ? (o/n)"
  read INSTALL_PM
  if [ "$INSTALL_PM" == "o" ]; then
    case $PACKAGE_MANAGER in
      yarn)
        npm install -g yarn
        ;;
      pnpm)
        npm install -g pnpm
        ;;
      *)
        echo "Gestionnaire inconnu ou non installable automatiquement."
        exit 1
        ;;
    esac
  else
    echo "Arrêt du script."
    exit 1
  fi
fi

# Type de projet
echo "🌐 Type de projet : (1) HTML/CSS (2) React (3) Next.js)"
read PROJECT_TYPE

if [ "$PROJECT_TYPE" == "1" ]; then
  mkdir "$PROJECT_NAME"
  cd "$PROJECT_NAME"
  mkdir src
  echo "<!DOCTYPE html><html><head><title>$PROJECT_NAME</title></head><body><h1>Hello $PROJECT_NAME</h1></body></html>" > src/index.html
  echo "🧱 Projet HTML/CSS créé."

elif [ "$PROJECT_TYPE" == "2" ]; then
  npm create vite@latest "$PROJECT_NAME" -- --template react
  cd "$PROJECT_NAME"
  echo "⚛️ Projet React avec Vite créé."
  mkdir -p src/components

  echo "App simple ou multipages ? (1) Simple (2) Multipages"
  read REACT_TYPE

  if [ "$REACT_TYPE" == "2" ]; then
    $PACKAGE_MANAGER install react-router-dom
    mkdir -p src/pages src/routes

    cat > src/pages/Home.jsx <<EOF
export default function Home() {
  return <h1>Accueil</h1>;
}
EOF

    cat > src/pages/Contact.jsx <<EOF
export default function Contact() {
  return <h1>Contact</h1>;
}
EOF

    cat > src/pages/About.jsx <<EOF
export default function About() {
  return <h1>À propos</h1>;
}
EOF

    cat > src/routes/routes.jsx <<EOF
import { createBrowserRouter } from 'react-router-dom';
import Home from '../pages/Home';
import Contact from '../pages/Contact';
import About from '../pages/About';

const router = createBrowserRouter([
  { path: '/', element: <Home /> },
  { path: '/contact', element: <Contact /> },
  { path: '/about', element: <About /> },
]);

export default router;
EOF
  fi

elif [ "$PROJECT_TYPE" == "3" ]; then
  npx create-next-app "$PROJECT_NAME"
  cd "$PROJECT_NAME"
  echo "⚙️ Projet Next.js créé."

else
  echo "❌ Choix invalide"
  exit 1
fi

# Description + Auteur
echo "📝 Petite description du projet :"
read DESCRIPTION

echo "👤 Nom de l'auteur :"
read AUTHOR

# Ajout README.md
cat > README.md <<EOF
# $PROJECT_NAME

$DESCRIPTION

## Installation

\`\`\`bash
$PACKAGE_MANAGER install
\`\`\`

## Démarrage

\`\`\`bash
$PACKAGE_MANAGER run dev
\`\`\`
EOF

# ESLint + Prettier
$PACKAGE_MANAGER install -D eslint prettier

echo '{}' > .eslintrc
echo '{}' > .prettierrc
echo 'node_modules' > .eslintignore
echo 'node_modules' > .prettierignore

# .gitignore
cat > .gitignore <<EOF
node_modules
dist
.next
.vite
.env
.DS_Store
EOF

# Licence
echo "📄 Choix de la licence (1) MIT (2) Apache 2.0 (3) GPL v3 (4) Aucune"
read LICENCE_CHOICE

YEAR=$(date +"%Y")

case $LICENCE_CHOICE in
  1)
    cat > LICENSE <<EOF
MIT License

Copyright (c) $YEAR $AUTHOR

Permission is hereby granted, free of charge, to any person obtaining a copy...
[à compléter avec le texte complet si besoin]
EOF
    ;;
  2)
    echo "Apache 2.0 - Placeholder" > LICENSE
    ;;
  3)
    echo "GPL v3 - Placeholder" > LICENSE
    ;;
  *)
    echo "Pas de licence ajoutée."
    ;;
esac

# Init Git
git init
echo "✅ Dépôt Git initialisé (pas de commit auto)"

echo "🎉 Projet $PROJECT_NAME prêt à être codé !"

