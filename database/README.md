# Installation
you must unsplit the dump

on Mac or unix
```cat 2022_05_30.sql.* > 2022_05_30.sql```

on windows
```copy /b 2022_05_30.sql.* 2022_05_30.sql```


then restore the database on postgres

# Update
to update the database, on symfony:

```bin/console app:database:update```

# Licence
Copyright (c) 2022 OpenStudio

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
