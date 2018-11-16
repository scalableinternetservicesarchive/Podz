# About

Team Podz is creating a platform for renting services and goods, including tools, gear, and transport.  A user of this service should be able to upload information about one or multiple items the user wishes to rent.  Another user should be able to, if the item is available, rent said item.  All items will fall into searchable categories, and users should be able to view top rented items from all categories.

# Team Members

## [Kasper Berg](https://github.com/kasperkberg)
![Kasper](headshots/bilde.jpg)

## [August Eilertsen](https://github.com/augustle)
![August](headshots/bilde_meg.png)

## [Ryan Allen](https://github.com/rmallensb)
![Ryan](headshots/UNADJUSTEDNONRAW_thumb_61f.jpg)

## [Alex Rich](https://github.com/alexrich021)
![Alex](headshots/IMG_1539.PNG)

# Deployment using elastic beanstalk

## Seeding Database

After `eb create` has finished running and app is successfully launched, do the following (from the Podz directory on the ec2 instance)

- `eb ssh podz-yourname` to ssh into the running app instance
- `cd /var/app/current` to enter the app directory
- `sudo su` to enable root privileges
- `rails db:seed RAILS_ENV=production` to seed the database

# Tsung

## Local installation

Run `brew install tsung`

- Note that when running a tsung server pointing at a locally hosted app server, the server port is 3000, not 80

## Using tsplot

To generate plots from multiple *tsung.log* files from multiple tsung tests, use the command `tsplot "test-1" /path/to/test-1/tsung.log "test-2" /path/to/test-2/tsung.log -d /output/directory/for/graphs/`
