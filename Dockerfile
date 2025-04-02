FROM php:8.2-apache

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Instalar dependencias del sistema y Node.js
RUN apt-get update && apt-get install -y \
    unzip zip curl git libzip-dev gnupg && \
    docker-php-ext-install zip && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos
COPY . .

# Instalar dependencias si existen
RUN if [ -f composer.json ]; then composer install; fi
RUN if [ -f package.json ]; then npm install; fi

# Permisos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]


