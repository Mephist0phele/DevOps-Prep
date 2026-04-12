# Docker Hands-On Lab Guide

## Lab 1: Your First Container (10 minutes)

### Objective
Learn basic Docker commands and run your first container.

### Steps

**1. Check Docker installation:**
```bash
docker --version
docker run hello-world
```

**2. List all images:**
```bash
docker images
```

**3. List all containers (including stopped):**
```bash
docker ps -a
```

### Expected Output
- You should see a hello-world message
- The hello-world image should appear in `docker images`
- The hello-world container should appear in `docker ps -a`

### Questions for Students
- Where did the hello-world image come from?
- Why is the container not running after completion?
- What happens if you run the same command twice?

---

## Lab 2: Build Your First Image (15 minutes)

### Objective
Create your own Docker image from a Dockerfile.

### Steps

**1. Create a directory and files:**
```bash
mkdir my-first-app
cd my-first-app
```

**2. Create app.py:**
```python
import os
import time

print("Application started!")
print(f"Hostname: {os.environ.get('HOSTNAME', 'unknown')}")
for i in range(5):
    print(f"Count: {i+1}")
    time.sleep(1)
print("Application completed!")
```

**3. Create Dockerfile:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY app.py .
CMD ["python3", "app.py"]
```

**4. Build the image:**
```bash
docker build -t my-first-app:1.0 .
```

**5. Run the container:**
```bash
docker run --name my-app-run my-first-app:1.0
```

**6. View logs:**
```bash
docker logs my-app-run
```

### Expected Output
- Build completes successfully
- Application runs and prints all messages
- Container exits after completion

### Challenge
- Modify app.py to print different messages
- Rebuild with a new tag (1.1)
- Run the new version

---

## Lab 3: Port Mapping & Web Server (20 minutes)

### Objective
Master port mapping by running a web server.

### Steps

**1. Run an nginx web server:**
```bash
docker run -d -p 8080:80 --name my-web nginx
```

**2. Verify it's running:**
```bash
docker ps
```

**3. Access the web server:**
```bash
# On Windows/Mac (in PowerShell):
curl http://localhost:8080

# Or open browser: http://localhost:8080
```

**4. Check container logs:**
```bash
docker logs my-web
```

**5. Stop the container:**
```bash
docker stop my-web
```

**6. Start it again:**
```bash
docker start my-web
```

**7. Remove the container:**
```bash
docker rm my-web
```

### Port Mapping Explanation
```
docker run -p [HOST_PORT]:[CONTAINER_PORT] image
         -p 8080:80
            ↑
         HOST (your computer)
            
            80
            ↑
         CONTAINER (inside Docker)

So: http://localhost:8080 → port 80 inside container
```

### Try These
- Use different ports: `-p 9000:80`, `-p 3000:80`
- Run multiple containers on different ports
- Access from your browser

---

## Lab 4: Running Commands in Containers (15 minutes)

### Objective
Execute commands inside running containers.

### Step 1: Start a long-running container
```bash
docker run -d --name ubuntu-container ubuntu:22.04 sleep 1000
```

### Step 2: Execute commands using docker exec
```bash
# Simple command
docker exec ubuntu-container echo "Hello from container!"

# Update and install
docker exec ubuntu-container apt-get update
docker exec ubuntu-container apt-get install -y curl

# Check if curl installed
docker exec ubuntu-container which curl
```

### Step 3: Interactive bash shell
```bash
docker exec -it ubuntu-container /bin/bash

# Now you're inside the container - try these commands:
ls -la
pwd
cat /etc/os-release
curl https://www.google.com
exit
```

### Step 4: Execute file inside container
```bash
docker exec ubuntu-container cat /etc/hostname
```

### Expected Output
- Commands execute successfully
- You can interact with the container's file system
- Changes are temporary (lost when container stops)

### Practice
- `ls` - list files
- `cd` - change directory
- `mkdir` - create directory
- `echo` - print text
- `cat` - read file

---

## Lab 5: Volume Mounting (15 minutes)

### Objective
Share files between host and container.

### Steps

**1. Create a test directory and file:**
```bash
mkdir shared-data
echo "Hello from host!" > shared-data/message.txt
```

**2. Run container with volume mount:**
```bash
docker run -d --name volume-test \
  -v C:\path\to\shared-data:/app/shared \
  ubuntu:22.04 sleep 1000
```

**Note:** On Windows, use `C:\path\to\shared-data` (full path)

**3. Read the file from container:**
```bash
docker exec volume-test cat /app/shared/message.txt
```

**4. Modify file from container:**
```bash
docker exec volume-test sh -c \
  'echo "Modified from container!" >> /app/shared/message.txt'
```

**5. Check modified file on host:**
```bash
cat shared-data/message.txt
```

### Expected Output
- Files are shared between host and container
- Changes in one place appear in the other
- Container sees mounted directory

---

## Lab 6: Environment Variables (10 minutes)

### Objective
Pass environment variables to containers.

### Steps

**1. Run container with environment variables:**
```bash
docker run -d --name env-test \
  -e APP_NAME="MyApp" \
  -e LOG_LEVEL="DEBUG" \
  -e DATABASE_URL="localhost:5432" \
  ubuntu:22.04 sleep 1000
```

**2. Check environment variables:**
```bash
docker exec env-test env
```

**3. Use the variables:**
```bash
docker exec env-test sh -c 'echo "App: $APP_NAME, Level: $LOG_LEVEL"'
```

### Practice
- Add more environment variables
- Create a script that uses these variables
- Run containers with different configurations

---

## Lab 7: Build & Run Python Application (20 minutes)

### Objective
Complete workflow from code to running container.

### Steps

**1. Create app directory:**
```bash
mkdir python-app
cd python-app
```

**2. Create app.py:**
```python
#!/usr/bin/env python3
import os
import sys

print("=" * 50)
print("Python Docker Application")
print("=" * 50)

# Read environment variable
name = os.environ.get("USER_NAME", "Guest")
print(f"Welcome, {name}!")

# Accept command line arguments
if len(sys.argv) > 1:
    print(f"Arguments: {' '.join(sys.argv[1:])}")

# Read from file if exists
try:
    with open('/app/data/input.txt') as f:
        print(f"File contents: {f.read()}")
except FileNotFoundError:
    print("No data file found")

print("=" * 50)
```

**3. Create Dockerfile:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

# Create data directory
RUN mkdir -p /app/data

COPY app.py .

# Make executable
RUN chmod +x app.py

ENV USER_NAME="Docker Student"

CMD ["python3", "app.py"]
```

**4. Build:**
```bash
docker build -t python-app:1.0 .
```

**5. Run basic:**
```bash
docker run python-app:1.0
```

**6. Run with custom environment:**
```bash
docker run -e USER_NAME="Alice" python-app:1.0
```

**7. Run with volume:**
```bash
echo "Data from host file" > data.txt
docker run -v C:\path\to\data.txt:/app/data/input.txt python-app:1.0
```

---

## Lab 8: Clean Up (5 minutes)

### Objective
Learn how to clean up Docker resources.

### Steps

**1. List all containers:**
```bash
docker ps -a
```

**2. Stop all running containers:**
```bash
docker stop $(docker ps -q)
```

**3. Remove all containers:**
```bash
docker rm $(docker ps -aq)
```

**4. List all images:**
```bash
docker images
```

**5. Remove unused images:**
```bash
docker rmi image-name:tag
```

**6. Remove all dangling images:**
```bash
docker image prune
```

**7. Full cleanup:**
```bash
docker system prune -a
```

### Be careful!
- `docker system prune -a` removes everything not running
- You'll lose all images and containers

---

## Challenge Exercises

### Challenge 1: Multi-Container App
- Run a web server on port 8080
- Run a database container on different port
- Make them talk to each other

### Challenge 2: Custom Web Image
- Create your own web server image
- Serve custom HTML content
- Run multiple instances on different ports

### Challenge 3: Application Stack
- Create a Python app that uses a database
- Package both in Docker
- Run them together

### Challenge 4: Performance
- Compare image sizes
- Try multi-stage builds
- Optimize Dockerfile

---

## Troubleshooting Guide

| Problem | Solution |
|---------|----------|
| Port already in use | Use different port: `-p 9000:80` |
| Container exits immediately | Add `sleep 1000` or keep process running |
| Can't access web server | Check port mapping: `docker ps` |
| No permission to write file | Use volume mount for data |
| Container can't reach network | Check Docker daemon is running |
| Out of disk space | Run `docker system prune` |

---

## Quick Command Reference

```bash
# Build and run basic workflow
docker build -t myapp:1.0 .
docker run myapp:1.0

# Run with features
docker run -d -p 8080:80 -e VAR=value -v /host:/container myapp:1.0

# Inspect and manage
docker ps -a
docker logs container-name
docker exec -it container-name bash
docker stop container-name
docker rm container-name

# Cleanup
docker system prune
docker rmi image-name
```

---

## Next Steps

1. Practice each lab multiple times
2. Try the challenge exercises
3. Create your own applications
4. Learn Docker Compose for multiple containers
5. Explore Docker registries
