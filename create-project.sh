#!/bin/bash

cd "$(dirname "$0")"

set -e

echo "📁 Nom du projet :"
read PROJECT_NAME

# Afficher le menu de sélection
echo -e "\n📦 Choisis ton gestionnaire de paquets :"

echo "1) npm - Gestionnaire standard de Node.js (recommandé)"
echo "2) yarn - Gestionnaire rapide et fiable"
echo "3) pnpm - Gestionnaire rapide et économe en espace"

while true; do
  read -p "→ Ton choix [1-3] : " choice
  
  case $choice in
    1) PACKAGE_MANAGER="npm"; break ;;
    2) PACKAGE_MANAGER="yarn"; break ;;
    3) PACKAGE_MANAGER="pnpm"; break ;;
    *) echo -e "❌ Option invalide. Réessaie.\n" ;;
  esac
done

echo -e "\n✅ Gestionnaire sélectionné : $PACKAGE_MANAGER\n"

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
echo "🌐 Type de projet :"
echo "1) HTML/CSS"
echo "2) React"
echo "3) Next.js"
echo "4) Astro"
read -p "Ton choix : " PROJECT_TYPE

case $PROJECT_TYPE in
  "1")
    mkdir "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    mkdir src
    echo "<!DOCTYPE html><html><head><title>$PROJECT_NAME</title></head><body><h1>Hello $PROJECT_NAME</h1></body></html>" > src/index.html
    echo "🧱 Projet HTML/CSS créé."
    ;;
  "2")
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

  ;;
  "3")
    npx create-next-app@latest "$PROJECT_NAME" --typescript --eslint --tailwind --app --src-dir --import-alias "@/*"
    cd "$PROJECT_NAME"
    echo "⚡ Projet Next.js créé avec TypeScript, ESLint, Tailwind CSS et le dossier app."
    ;;
  "4")
    npm create astro@latest "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    echo "🚀 Projet Astro créé."
    ;;
  *)
    echo "❌ Option non valide"
    exit 1
    ;;
esac

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

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF
    ;;
  2)
    echo "Copyright (c) $YEAR $AUTHOR

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License." > LICENSE
    ;;
  3)
    cat > LICENSE <<EOF
Copyright (c) $YEAR $AUTHOR

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
EOF
    ;;
  *)
    echo "Pas de licence ajoutée."
    ;;
esac

# Init Git
git init
echo "✅ Dépôt Git initialisé (pas de commit auto)"

echo "🎉 Projet $PROJECT_NAME prêt à être codé !"

