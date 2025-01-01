# Use the official PHP image with Apache
FROM php:8.2-apache

# Copy application files to the default web directory
COPY index.php /var/www/html/

# Set permissions for the Apache user
RUN chown -R www-data:www-data /var/www/html

# Expose the default HTTP port
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]