# Docker Commands Quick Reference

## Image Management

```bash
# Build an image
docker build -t image-name:tag .
docker build -t image-name:tag -f Dockerfile.custom .

# List images
docker images
docker image ls -a

# Remove image
docker rmi image-name:tag
docker image rm image-id

# Search for image
docker search ubuntu

# Pull image from registry
docker pull ubuntu:22.04

# Push image to registry
docker push username/image-name:tag

# Tag an image
docker tag old-image:tag new-image:tag

# Inspect image
docker inspect image-name:tag
docker history image-name:tag
```

---

## Container Management

```bash
# Create and run container
docker run image-name
docker run --name container-name image-name
docker run -d image-name                    # Detached (background)
docker run -it image-name /bin/bash         # Interactive terminal

# List containers
docker ps                                   # Running only
docker ps -a                                # All containers
docker ps -l                                # Latest container

# Start/Stop/Restart
docker start container-name                 # Start stopped container
docker stop container-name                  # Stop running container
docker restart container-name               # Restart container
docker kill container-name                  # Force stop

# Remove containers
docker rm container-name
docker rm $(docker ps -aq)                  # Remove all containers

# View container information
docker logs container-name                  # View logs
docker logs -f container-name               # Follow logs (live)
docker inspect container-name               # Inspect container
docker stats container-name                 # Resource usage
```

---

## Port & Volume Mapping

```bash
# Port mapping
docker run -p 8080:80 image-name            # Map host:container
docker run -p 8080:80 -p 3000:3000 image    # Multiple ports

# Volume mounting
docker run -v /host/path:/container/path image
docker run -v C:\Windows\Path:/container/path image  # Windows

# Named volumes
docker volume create volume-name
docker run -v volume-name:/data image
docker volume ls
docker volume rm volume-name

# Read-only mount
docker run -v /host/path:/container/path:ro image
```

---

## Environment & Arguments

```bash
# Environment variables
docker run -e VAR_NAME=value image
docker run -e USER_NAME="John" image
docker run --env-file .env image            # Load from file

# Working directory
docker run -w /app image

# User
docker run -u root image
docker run -u 1000 image

# Hostname
docker run -h my-hostname image
docker run --hostname my-hostname image

# Network
docker run --network bridge image           # Default
docker run --network host image             # Host network
docker run --network my-network image       # Custom network
```

---

## Executing Commands

```bash
# Execute command in running container
docker exec container-name echo "Hello"

# Interactive execution
docker exec -it container-name /bin/bash
docker exec -it container-name sh

# Execute with specific user
docker exec -u root container-name apt-get update

# Get output
docker exec container-name cat /etc/hostname
docker exec container-name ls -la
```

---

## Naming & Tagging

```bash
# Run with name
docker run --name my-container image

# Tag an image
docker tag image-id username/repo:tag

# Build with tag
docker build -t myrepo/myapp:1.0 .

# Build with multiple tags
docker build -t myapp:latest -t myapp:1.0 .
```

---

## Advanced Options

```bash
# Resource limits
docker run --memory 512m image              # Limit RAM
docker run --cpus 0.5 image                 # Limit CPU

# Restart policy
docker run --restart=always image
docker run --restart=on-failure:5 image

# Health check
docker run --health-cmd="curl localhost:80" image

# Privileged mode (careful!)
docker run --privileged image

# Security options
docker run --security-opt=no-new-privileges image

# Logging
docker run --log-driver json-file image
docker run --log-opt max-size=10m image
```

---

## Docker Inspect & Debug

```bash
# Inspect container
docker inspect container-name

# Inspect specific field
docker inspect --format='{{.Config.Hostname}}' container

# Get IP address
docker inspect --format='{{.NetworkSettings.IPAddress}}' container

# View running processes
docker top container-name

# Check differences
docker diff container-name

# Copy files
docker cp container-name:/path/file ./host/file
docker cp ./host/file container-name:/path/file
```

---

## Docker System

```bash
# Info
docker --version
docker version
docker info

# Prune (cleanup)
docker system prune                 # Remove stopped containers
docker system prune -a              # Remove all unused images
docker image prune                  # Remove unused images
docker container prune              # Remove stopped containers
docker volume prune                 # Remove unused volumes

# Disk usage
docker system df                    # Docker disk usage
docker system df -v                 # Verbose
```

---

## Docker Registry Operations

```bash
# Login to registry
docker login
docker login myregistry.com

# Push to registry
docker push username/image:tag

# Pull from registry
docker pull ubuntu:22.04
docker pull myregistry.com/image:tag

# Logout
docker logout
```

---

## Network Operations

```bash
# List networks
docker network ls

# Create network
docker network create my-network

# Connect container to network
docker network connect my-network container-name

# Disconnect
docker network disconnect my-network container-name

# Inspect network
docker network inspect my-network

# Remove network
docker network rm my-network
```

---

## Docker Compose (Quick Reference)

```bash
# Start services
docker-compose up                   # Foreground
docker-compose up -d                # Background

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Execute command
docker-compose exec service-name bash

# List services
docker-compose ps

# Rebuild images
docker-compose build
```

---

## Useful Aliases (add to shell)

```bash
# PowerShell
function d { docker $args }
function drun { docker run -it $args }
function dbash { docker exec -it $args bash }
function dps { docker ps $args }
function dlog { docker logs -f $args }

# PowerShell Profile (~\Documents\WindowsPowerShell\profile.ps1)
Set-Alias -Name dcontainers -Value 'docker ps -a'
Set-Alias -Name dimages -Value 'docker images'
```

---

## Important Notes

- **Container ID**: Can use full or shortened ID
- **Tag format**: `registry/repository:tag`
- **Default tag**: `latest` if not specified
- **Port format**: `-p [host]:[container]`
- **Volume paths**: Can be absolute or relative
- **Windows paths**: Use `C:\path` or `C:/path`

---

## Common Workflows

### Build → Run → Test → Stop → Remove

```bash
# 1. Build
docker build -t myapp:1.0 .

# 2. Run
docker run -d --name myapp myapp:1.0

# 3. Check logs
docker logs myapp

# 4. Test
docker exec myapp curl localhost:3000

# 5. Stop
docker stop myapp

# 6. Remove
docker rm myapp

# 7. Cleanup
docker system prune
```

### Development Workflow

```bash
# 1. Run with volume for live code
docker run -d \
  --name dev-app \
  -v C:\project:/app \
  -p 3000:3000 \
  myapp:dev

# 2. Update code
# (edit files on host)

# 3. Restart if needed
docker restart dev-app

# 4. View logs
docker logs -f dev-app

# 5. Stop when done
docker stop dev-app
```

---

## Troubleshooting Checklist

- [ ] Is Docker daemon running?
- [ ] Does image exist? (`docker images`)
- [ ] Is port already in use?
- [ ] Are file paths correct?
- [ ] Check logs: `docker logs container-name`
- [ ] Check if container exited: `docker ps -a`
- [ ] Can you access with bash? `docker exec -it ... bash`
- [ ] Is network configured? `docker network ls`
- [ ] Do you have permission? (`sudo` on Linux)
- [ ] Is enough disk space available? (`docker system df`)
