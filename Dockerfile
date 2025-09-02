# Use official PHP-Apache image
FROM php:8.0-apache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libonig-dev \       # for mbstring
    libzip-dev \        # for zip
    zlib1g-dev \        # for zip support
    libicu-dev \        # for internationalization support
    libxml2-dev \       # required by mbstring/json sometimes
    zip \
    unzip \
    git \
    nano \
    curl \
    && docker-php-ext-install mysqli pdo pdo_mysql mbstring json zip \
    && rm -rf /var/lib/apt/lists/*


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
