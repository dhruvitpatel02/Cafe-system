# Use official PHP-Apache image
FROM php:8.0-apache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install core system dependencies
# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    zlib1g-dev \
    libicu-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    nano \
    curl \
    && docker-php-ext-install mysqli pdo pdo_mysql json zip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql mbstring json

# Install the zip extension specifically
RUN docker-php-ext-configure zip && docker-php-ext-install -j$(nproc) zip

# Set working directory
WORKDIR /var/www/html

# Copy project files into Apache root
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose Apache on port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]