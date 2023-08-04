# Stage 1: Install Node.js packages
FROM node:16-alpine AS nodepackages

COPY . /app
WORKDIR /app
RUN npm install

# Stage 2: PHP container
FROM php:7.4-apache-buster

# Update package lists and upgrade installed packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nano git libzip-dev gnupg

# Enable Apache modules
RUN a2enmod rewrite headers

RUN apt-get install -y libpng-dev

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql zip gd

# Copy the apache security file
COPY security.conf /etc/apache2/conf-available/security.conf

# Copy the PHP configuration file
COPY php.ini /etc/php/7.4/apache2/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Add Node.js 14.x repository
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -

# Install Node.js and npm
RUN apt-get install -y nodejs

# Print Node.js and npm versions
RUN node -v
RUN npm -v

# Stage 3: Copy Node.js packages and PHP app
COPY --from=nodepackages /app /var/www/html/services/appointments/

# Install PHP dependencies using composer
WORKDIR /var/www/html/services/appointments/
RUN npm run build
RUN composer install

# Change ownership and permissions
RUN chown -R www-data:www-data /var/www/html/services/appointments
RUN chmod -R 755 /var/www/html/services/appointments

# Expose necessary ports
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
