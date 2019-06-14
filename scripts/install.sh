#!/bin/bash -xe

DRUSH_ALIAS=${1:-@docker.local}
if ! [[ -d drush && -f README.md && -f composer.json ]] ; then
  echo "Should run install from root of repository."
  exit -1
fi
export PATH="$PWD/vendor/bin:$PATH"
pushd scripts/docker
docker-compose up -d
popd
drush rsync . @docker.local
drush @docker.local ssh -- ./vendor/bin/drush si --db-url=mysql://drupal:drupal@drupaldb:3306/drupal --site-name=Pacifica
drush @docker.local ssh -- ./vendor/bin/drush en pacifica pacifica_search memcache memcache_admin search_api search_api_solr
