# IAT API project

## Installation 

Prérequis : 
- curl
- Postgresql 12 (voir script psql_install.sh)

via composer 
```bash
composer install
```

## Initialisation

Créer le fichier `.env.local` à la racine du projet
```
###> database connexion ###
DB_URI=pgsql:dbname=DBNAME;user=USERNAME;password=PASSWORD;host=HOST
###< database connexion ###
###> Insee api connect ###
INSEE_KEY=...
INSEE_SECRET=...
###< Insee api connect ###
```

Pour la base de données, exécuter les commandes d'initialsiation 
```bash
bin/console app:database:create
bin/console app:database:update
bin/console app:database:initialise
bin/console app:establishment:initialise
bin/console app:industry_territory:initialise
```

## Routes
L'application fournit quelques routes de test : 

- `GET /base/{entityName}/{id}` pour lire une entité spécifique
- `GET /visualisation/establishment?departement=DEP_CODE` pour lire les établissements d'un département, DEP_CODE étant
 la liste des départements désiré, séparé par une virgule 

# Licence
Copyright (c) 2022 OpenStudio

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
