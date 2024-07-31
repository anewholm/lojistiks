# Lojistiks plugin

## Installation

This assumes you have `git clone`d or linked [office/scripts](https://gitlab.acorn.org/office/scripts) in to `/var/www`. It also assumes you have the full Apache2, PostGreSQL**@16**, PHP stack installed. The script `acorn-setup-laptop` will install everything you need including the necessary PostGreSQL extensions. The `psql` command will ask for a password. The password is **QueenPool1@**.

```
cd /var/www/
scripts/acorn-setup-new-winter acorn-lojistiks
cd acorn-lojistiks
composer require simplesoftwareio/simple-qrcode
cd plugins/acorn
git clone git@gitlab.acorn.org:office/lojistiks.git
cd lojistiks
# This will ask for a password. The password is QueenPool1@
psql -U acornlojistiks -W -d acornlojistiks -a -f acornlojistiks.sql
cd ../../..
sudo chown -R www-data:www-data .; sudo chmod -R g+rw .
```

This will make a website at http://acorn-lojistiks.laptop. It is a local website on your laptop, so use VPN bypass rules for *.laptop.

**Login**: admin/password

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
