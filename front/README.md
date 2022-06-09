This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br />
You will also see any lint errors in the console.

### `npm run build`

Builds the app for production to the `build` folder.<br />
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br />
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.


### `npm run test`

Éxécution des fichiers de test, ie les fichiers étant suffixés par `.test.js`  

## Docker support

Build and tag a docker image

```sh
docker build -t sample:dev .
```

```sh
docker run \
    -it \
    --rm \
    -v ${PWD}:/app \
    -v /app/node_modules \
    -p 3011:3000 \
    -e CHOKIDAR_USEPOLLING=true \
    -e REACT_APP_API_URL=http://api.iat.openstudio-lab.xx/ \
    sample:dev
```

Open <http://localhost:3011>

## Dependencies 

```node v12```
Other dépendencies are handled with package.json

## Setup

```npm i```

Define api and app URL in your local env file : \
```REACT_APP_API_URL=http://127.0.0.1:8000/``` \
```REACT_APP_BASE_URL=http://127.0.0.1:3000/```

## Architecture
#### api/
Fonctions d'appel au back end
#### components/
Découpage des fonctionnalités en composants fonctionnels React
#### css/
Fichiers css custom et config tailwind
#### hooks/
Hooks personnalisés
#### lib/
Intégration de lib externe
#### maps/
Outils pour la visualisation des différentes cartes
#### pages/
Différentes vues de l'application\
* Pays : carte de la France découpée en région ou TI
* Produits : Graphique de l'espace productif 
* Produit : Graphique en forme de cible pour illustrer les sauts productifs possibles
* Etablissements : Vue des entreprises dans l'espace géographique
* Etablissement : Espace géographique centrée sur une entreprise
* Metiers : Adaptation de l'espace productif sur les codes Rome
* FiltresGlobaux : Page de sélection des filtres

#### svgs/
Différents pictos et logos
#### test/
Tests unitaires des méthodes génériques et tests de chargement des composants

### Licence
Copyright (c) 2022 OpenStudio

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
