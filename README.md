# Lojistiks plugin

## Installation

This assumes you have `git clone`d or linked [office/scripts](https://gitlab.acorn.org/office/scripts) in to `/var/www`. It also assumes you have the full Apache2, PostGreSQL**@16**, PHP stack installed. The script `acorn-setup-laptop` will install everything you need including the necessary PostGreSQL extensions `http` and `hostname`.

```
# git pull your scripts first!
cd /var/www/
./scripts/acorn-setup-new-winter acorn-lojistiks
cd acorn-lojistiks
cd plugins/acorn
git clone git@gitlab.acorn.org:office/finance.git
git clone git@gitlab.acorn.org:office/lojistiks.git
git clone git@gitlab.acorn.org:office/oil.git
cd -
# Optional useful script links
ln -s ../scripts/acorn-git-all .
ln -s ../scripts/acorn-git-pull-all .
ln -s ../scripts/acorn-git-push-all .
ln -s ../scripts/acorn-winter-down-up . # Runs the ./artisan as www-data avoiding permissions issues
sudo chown -R www-data:www-data .; sudo chmod -R g+rw .
```

This will make a website at [http://acorn-lojistiks.laptop](http://acorn-lojistiks.laptop). It is a local website on your laptop, so use VPN bypass rules for `*.laptop`. **Login**: admin/password

This system is a **Distributed Database** system with UUIDs. If you wish to connect with the replication server to sync data then add the following database connection to your `config/database.php`. And add the following line to your local standard psql connection in `config/database.php`: `'subscribe_to' => 'replication_publisher',`. `./artisan winter:up` sets up the replication, however, `winter:down` does not work very well so you will have to `DROP SCHEMA` for the moment.

```
'replication_publisher' => [
    'charset' => 'utf8',
    'database' => env('DB_DATABASE', 'acornlojistiks'),
    'driver' => 'pgsql',
    'host' => env('DB_REPLICATION_PUBLISHER_HOST', 'gitlab.acorn.org'), // AA central server over VPN or direct
    'port' => env('DB_REPLICATION_PUBLISHER_PORT', '5433'), // AA PostGreSQL server v16 on port 5433 currently
    'username' => env('DB_USERNAME', 'postgres'),
    'password' => env('DB_PASSWORD', '12345678'),
],
```

To serve the websockets server use `./artisan websockets:serve`. All new Database rows will `TRIGGER` a `http` extension call to the `/api/datachange` API in `~/controllers/DB.php` which in turn creates and dispatches a websocket Event object on port 6001. _This is not completely working at time of writing._

To create or update a new SUPERUSER in PostGreSQL use `sudo -u postgres psql`, list users with `\du`, and then `CREATE` or `ALTER` users `WITH SUPERUSER`.

## Programming Requirements

Documentation: All programmers must pass a Winter test to join the team. This includes Backend Forms, Model relationships and Controller events:

* https://wintercms.com/docs/v1.2/docs/backend/forms
* https://wintercms.com/docs/v1.2/docs/backend/lists
* https://wintercms.com/docs/v1.2/docs/backend/relations
* https://wintercms.com/docs/v1.2/docs/ajax/attributes-api

## Programming Notes

**Encapsulation**: No access to Model properties, except relationships, from outside a Model.

**Plugin development only**: No changes to Winter or vendor will be recorded. This is a plugin, not a website.

**Merge requests only**: All code is reviewed before acceptance.
