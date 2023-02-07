# Sélectionnez une image PHP en tant qu'image de base
FROM php:8.1-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Installez les extensions PHP nécessaires pour Symfony
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo_pgsql intl zip

# Copiez les fichiers de votre application dans le conteneur
COPY . /var/www
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf



# Installez les dépendances nécessaires avec Composer
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
    mv composer.phar /usr/local/bin/composer

RUN curl -sS https://get.symfony.com/cli/installer | bash


RUN apt-get update && apt-get install -yqq nodejs npm nano
RUN cd /var/www && \
    composer install && \
    npm install --force

# Définissez le chemin d'accès à votre application
WORKDIR /var/www

#RUN apt-get update && apt-get install symfony-cli

# ENTRYPOINT [ "bash", "./docker/docker.sh" ]


# Exposez le port 80 pour permettre aux requêtes HTTP d'atteindre le conteneur
EXPOSE 80

