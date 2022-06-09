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