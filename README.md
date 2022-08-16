# App Update / Install App

## Install App
* Create Folder
```
/var/www/journal.cafe_v2.0
```
* Copy configs from old installation to new installation:
```
./config/database.yml
./config/credentials.yml.enc
./config/master.key
```
* Set Symlink to access attachment storage
```
cd /var/www/app.journal.cafe_v2.0
ln -s /var/www/storage/ storage
```
* Update Rails
```
cd journal.cafe_v2.0
bundle install && gem update && npm install && yarn && bundle exec rails webpacker:install && rails webpacker:compile && RAILS_ENV=production bundle exec rake assets:precompile && rails assets:precompile
Note: Required Ruby Version in Gemfile

```
* Set Access Rights
```
chown -R www-data:www-data /var/www/journal.cafe_v2.0
chmod -R 755 /var/www/journal.cafe_v2.0
find /var/www/journal.cafe_v2.0 -type d -exec chmod g+s {} \;
```

* Point to new Instalaltion & migrate DB
```
Create Server Snapshot before that
service nginx stop
ln -s journal.cafe_v2.0/ journal.cafe
export JOURNAL_CAFE_DATABASE_PASSWORD="SET in 1Password"
RAILS_ENV=production rails db:migrate
service nginx start
```

# Test App wihtout Nginx
```
Set Environment Variables manually
export SECRET_KEY_BASE="SET in 1Password"
export JOURNAL_CAFE_DATABASE_PASSWORD="SET in 1Password"
Start Testserver with rails s
```

# Web Server Config

<details>

## Certbot
```
apt install python3-certbot-nginx
certbot --nginx
```

## Nginx
* Certificate for main domain
```
certbot --nginx
```
* Certificate for *.maindomain.com
```
sudo certbot certonly \
  --agree-tos \
  --email admin@journal.cafe \
  --manual \
  --preferred-challenges=dns \
  -d *.journal.cafe \
  --server https://acme-v02.api.letsencrypt.org/directory
```
```
server {
        listen 443 ssl;
        listen [::]:443 ssl;

        server_name _;
        root /var/www/journal.cafe/public;

        rails_env production;
        passenger_enabled on;

        passenger_env_var JOURNAL_CAFE_DATABASE_PASSWORD 28HMTZ7Cdw-fE37J6JVCEEYzvjeFz3Vq;
        passenger_env_var SECRET_KEY_BASE vUbgWDnzVDNcrsHNwgEMFwdwQvxCZDQA;

        client_max_body_size 10M;

        ssl_certificate /etc/letsencrypt/live/journal.cafe-0001/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/journal.cafe-0001/privkey.pem;
        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;


}

#Directive for main domain journal.cafe

server {
        listen 443 ssl;
        listen [::]:443 ssl;

        server_name journal.cafe;
        root /var/www/journal.cafe/public;

        rails_env production;
        passenger_enabled on;

        passenger_env_var JOURNAL_CAFE_DATABASE_PASSWORD 28HMTZ7Cdw-fE37J6JVCEEYzvjeFz3Vq;
        passenger_env_var SECRET_KEY_BASE vUbgWDnzVDNcrsHNwgEMFwdwQvxCZDQA;

        client_max_body_size 10M;

        ssl_certificate /etc/letsencrypt/live/journal.cafe/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/journal.cafe/privkey.pem;
        include /etc/letsencrypt/options-ssl-nginx.conf;
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;


}

# Redirect to HTTPS

server {

        listen 80;
        listen [::]:80;

        return 301 https://$host$request_uri;
}

```

</details>

# Database Setup App Setup

<details>

#### Database
Create User
```
sudo -i -u postgres
createuser --interactive
postgres createuser <username>
> Enter name of role to add: journal\_cafe 
> Shall the new role be a superuser? (y/n) n
> Shall the new role be allowed to create databases? (y/n) y
> Shall the new role be allowed to create more new roles? (y/n) n
```        
##### Change Password
```
sudo -u postgres psql
ALTER ROLE journal\_cafe WITH PASSWORD 'secret123';
rm /var/lib/postgresql/.history
```
##### Config Database
Set configuration and user in config/database.yml
```
Set Environment Variables manually
export SECRET_KEY_BASE="SET in 1Password"
export JOURNAL_CAFE_DATABASE_PASSWORD="SET in 1Password"
rails db:create
rails db:migrate
Rerun with "RAILS_ENV=production"
```

</details>

# Prerequisites for App Setup

<details>
        
## Prerequisites
For Ubuntu 20.04
#### Ruby
```
apt install ruby-bundler ruby-dev gcc make libffi-dev libxml2-dev g++ libpq-dev nodejs npm
```
#### NPM
```
npm install --global yarn
npm install --global webpack
npm install --global webpack-cli
```
#### Database
```
apt install postgresql postgresql-contrib
```
#### Webserver
* NGINX
```
apt install nginx-full
```
* Passenger
```
gem install passenger
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger **focal** main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get install -y libnginx-mod-http-passenger
```            
#### Storage Folder

* Create empty folder for new installation and set access rights
```
mkdir /var/www/storage
chown -R www-data:www-data /var/www/storage
chmod -R 755 /var/www/storage
find /var/www/storage -type d -exec chmod g+s {} \;
```
</details>


