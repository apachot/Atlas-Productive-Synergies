NB="11"
cd "$(dirname "$0")"
STARTED_AT="$(date)"
bin/console cache:clear --env=prod
echo ">>> Step 1/${NB} : $(date)"
bin/console app:database:create --env=prod
echo ">>> Step 2/${NB} : $(date)"
bin/console app:database:update --env=prod
echo ">>> Step 3/${NB} : $(date)"
bin/console app:database:initialise --env=prod
echo ">>> Step 4/${NB} : $(date)"
bin/console app:product:complete --env=prod
echo ">>> Step 5/${NB} : $(date)"
bin/console app:establishment:initialise 63 --env=prod
echo ">>> Step 6/${NB} : $(date)"
bin/console app:industry_territory:initialise --env=prod
echo ">>> Step 7/${NB} : $(date)"
bin/console app:faker:establishment --env=prod
echo ">>> Step 8/${NB} : $(date)"
bin/console app:spec_faker:establishment --env=prod
echo ">>> Step 9/${NB} : $(date)"
bin/console app:faker:recommendation 63 --env=prod
echo ">>> Step 10/${NB} : $(date)"
bin/console app:database:optimize --env=prod
echo ">>> Installation Finished."
echo "started at : ${STARTED_AT}"
echo "finished at : $(date)"