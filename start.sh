#!/bin/bash

echo "Starting OpenCart with Docker Compose..."

# Create necessary directories
mkdir -p docker/nginx/ssl
mkdir -p docker/mysql/init
mkdir -p docker/php

# Set proper permissions
chmod +x start.sh
chmod 755 upload/system/storage/cache
chmod 755 upload/system/storage/download
chmod 755 upload/system/storage/logs
chmod 755 upload/system/storage/modification
chmod 755 upload/system/storage/session
chmod 755 upload/system/storage/upload

# Start services
docker-compose up -d

echo "OpenCart is starting up..."
echo "Please wait a few minutes for all services to be ready."
echo ""
echo "Access URLs:"
echo "- OpenCart Frontend: http://localhost"
echo "- OpenCart Admin: http://localhost/admin"
echo "- Adminer (Database): http://localhost:8080"
echo ""
echo "Database credentials:"
echo "- Host: mysql"
echo "- Database: opencart"
echo "- Username: opencart_user"
echo "- Password: opencart_password"
echo ""
echo "To view logs: docker-compose logs -f"
echo "To stop: docker-compose down"
```

```bash:stop.sh
#!/bin/bash

echo "Stopping OpenCart..."

docker-compose down

echo "OpenCart stopped successfully."
```

Now let me create a README file with instructions:

```markdown:README-Docker.md
# OpenCart Docker Setup

This Docker Compose setup provides a complete OpenCart development environment with MySQL, PHP-FPM, Nginx, and Adminer.

## Prerequisites

- Docker
- Docker Compose
- Git

## Quick Start

1. **Clone and navigate to the project:**
   ```bash
   cd opencart-304
   ```

2. **Make the start script executable and run it:**
   ```bash
   chmod +x start.sh
   ./start.sh
   ```

3. **Wait for services to start up (2-3 minutes)**

4. **Access OpenCart:**
   - Frontend: http://localhost
   - Admin Panel: http://localhost/admin
   - Database Admin: http://localhost:8080

## Services

### MySQL (Port 3306)
- Database: `opencart`
- Username: `opencart_user`
- Password: `opencart_password`
- Root Password: `opencart_root_password`

### PHP-FPM
- PHP 8.1 with required extensions
- Optimized for OpenCart
- Custom configuration

### Nginx (Port 80)
- Reverse proxy to PHP-FPM
- Optimized for OpenCart
- Static file caching

### Adminer (Port 8080)
- Database management interface
- Connect to MySQL service

## Configuration

### Environment Variables
Edit `.env` file to customize:
- Database passwords
- PHP settings
- Port configurations

### PHP Configuration
- Memory limit: 256M
- Upload max filesize: 100M
- OPcache enabled
- Error logging enabled

### Nginx Configuration
- Gzip compression
- Security headers
- Static file caching
- OpenCart-specific routing

## File Structure

```
docker/
├── mysql/
│   └── init/
│       └── 01-opencart.sql
├── nginx/
│   ├── nginx.conf
│   └── opencart.conf
└── php/
    ├── Dockerfile
    ├── php.ini
    └── www.conf
```

## Management Commands

### Start services:
```bash
docker-compose up -d
```

### Stop services:
```bash
docker-compose down
```

### View logs:
```bash
docker-compose logs -f
```

### Rebuild containers:
```bash
docker-compose up -d --build
```

### Access container shell:
```bash
docker-compose exec php-fpm bash
docker-compose exec mysql mysql -u root -p
```

## Troubleshooting

### Common Issues:

1. **Permission errors:**
   ```bash
   chmod -R 755 upload/system/storage/
   ```

2. **Port conflicts:**
   - Edit ports in `docker-compose.yml`
   - Check if ports 80, 3306, 8080 are free

3. **Database connection issues:**
   - Wait for MySQL to fully start
   - Check container logs: `docker-compose logs mysql`

4. **PHP errors:**
   - Check PHP logs: `docker-compose logs php-fpm`
   - Verify PHP configuration

### Reset everything:
```bash
docker-compose down -v
docker system prune -f
./start.sh
```

## Development

### Adding custom PHP extensions:
Edit `docker/php/Dockerfile` and rebuild:
```bash
docker-compose up -d --build php-fpm
```

### Custom Nginx configuration:
Edit `docker/nginx/opencart.conf` and restart:
```bash
docker-compose restart nginx
```

## Security Notes

- Change default passwords in production
- Use HTTPS in production
- Restrict database access
- Regular security updates
- Backup database regularly

## Performance

- OPcache enabled for PHP
- Nginx static file caching
- Gzip compression
- Optimized PHP-FPM settings
```

This Docker Compose setup provides:

1. **MySQL 8.0** - Database server with OpenCart database
2. **PHP 8.1-FPM** - Custom PHP with all required extensions
3. **Nginx** - Web server with OpenCart-optimized configuration
4. **Adminer** - Database management interface
5. **Proper networking** - All services can communicate
6. **Volume persistence** - Database data persists between restarts
7. **Security** - Proper file permissions and security headers
8. **Performance** - OPcache, gzip, and caching optimizations

The setup includes:
- Custom PHP Dockerfile with OpenCart requirements
- Nginx configuration optimized for OpenCart
- Database initialization scripts
- Environment configuration
- Start/stop scripts
- Comprehensive documentation

To use this setup, simply run `./start.sh` and wait for all services to start. OpenCart will be available at http://localhost, and Adminer at http://localhost:8080 for database management.
```

