# Imagen base con Apache + PHP 8.2
FROM php:8.2-apache

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Instalar utilitarios del sistema y extensiones necesarias
RUN apt-get update && apt-get install -y \
    unzip \
    zip \
    curl \
    libzip-dev \
    git \
    gnupg \
    && docker-php-ext-install zip

# Instalar Node.js 18 LTS + npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Instalar Composer (última versión estable)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos al contenedor
COPY . .

# Instalar dependencias de Composer y npm si los archivos existen
RUN if [ -f composer.json ]; then composer install; fi
RUN if [ -f package.json ]; then npm install; fi

# Dar permisos adecuados a Apache
RUN chown -R www-data:www-data /var/www/html

# Exponer puerto 80
EXPOSE 80

# Iniciar Apache
CMD ["apache2-foreground"]

