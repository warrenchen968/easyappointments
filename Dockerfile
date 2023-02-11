FROM node:16-alpine AS nodepackages

COPY . /app

WORKDIR /app

RUN npm install

FROM php:7.4-apache

COPY --from=nodepackages /app /var/www/html/services/appointments

# Update package lists and upgrade installed packages
RUN apt-get update && apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y nano git libzip-dev
RUN apt-get update && apt-get install -y \
                libfreetype6-dev \
                libjpeg62-turbo-dev \
                libpng-dev \
        && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd

# Enable Apache modules
RUN a2enmod rewrite
RUN a2enmod headers

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql zip

# Copy the apache security file
COPY security.conf /etc/apache2/conf-available/security.conf

# Copy the apache configuration file
#COPY apache2.conf /etc/apache2/apache2.conf

# Copy the PHP configuration file
COPY php.ini /etc/php/7.4/apache2/php.ini

# Changing directory
WORKDIR /var/www/html/services/appointments/

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install

# Change ownership and permissions
RUN chown -R www-data:www-data /var/www/html/services/appointments
RUN chmod -R 755 /var/www/html/services/appointments

# Expose necessary ports
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
