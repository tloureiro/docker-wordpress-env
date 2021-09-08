# to build the image

```
docker build -t wordpress-env --no-cache .
```

# vscode xdebug config

```json
{
    "name": "Listen for Xdebug",
    "type": "php",
    "request": "launch",
    "port": 9003,
    "pathMappings": {
        "/var/www/html": "${workspaceFolder}/",
    },
},
```