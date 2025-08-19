-- Create OpenCart database if it doesn't exist
CREATE DATABASE IF NOT EXISTS opencart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges to opencart user
GRANT ALL PRIVILEGES ON opencart.* TO 'opencart_user'@'%';
FLUSH PRIVILEGES;
```

```
