# DOCKER MASTERCLASS – PART 1  
### Chapters 1–4  
### (Introduction, Need for Docker, Containerization vs Virtualization, Installation)

---

# 1. What is Docker

Docker is a platform designed to run applications inside lightweight, isolated environments called **containers**.  
To understand Docker deeply, it helps to break the definition into key components:

### 1.1 Docker as an Application Delivery Platform  
Docker provides a consistent runtime environment for applications. This means that when you run an app inside Docker, it behaves the same way across:

- Developer machine  
- Test and QA environments  
- Staging  
- Production servers  
- Cloud environments (AWS, Azure, GCP)

This consistency eliminates the infamous problem:

> “It works on my machine, but not on the server.”

### 1.2 Docker as an Abstraction Layer  
Docker abstracts away:

- The underlying OS differences  
- Library compatibility issues  
- Dependency conflicts  
- Version mismatches  

You package everything your application needs inside a container image.  
This makes deployments **predictable and reproducible**.

### 1.3 Docker as an Isolation Mechanism  
Containers provide isolated execution environments using Linux kernel features such as:

- Namespaces (for isolation of processes, networking, mounts, hostname…)  
- cgroups (for controlling CPU, memory, IO usage)  
- Union file systems (overlay filesystem for layers)

This ensures that:

- Your application cannot affect others  
- Your app has its own filesystem  
- Your app has its own network interface  
- Its resource usage is controlled  

Isolation makes Docker ideal for microservices and distributed systems.

---

# 2. Why Docker

Understanding WHY Docker exists is key to mastering it. The main reasons include:

### 2.1 Environment Consistency  
Developers and servers can use:

- Different OS versions  
- Different library versions  
- Different dependency versions  

This causes failures that only appear in production.

Docker fixes this by packaging:

- OS libraries  
- Runtime  
- Dependencies  
- Application code  

Into a **single image**.

### 2.2 Fast Deployment  
Before Docker:

- Deployments meant copying source code  
- Installing dependencies manually  
- Configuring environments  
- Installing language runtimes  

This was slow, error-prone, and inconsistent.

With Docker:

- You package the app into an image once  
- Run it instantly anywhere  
- Deployment becomes a matter of running a container

### 2.3 Lightweight and Efficient  
Containers share the host OS kernel, unlike virtual machines.  
This makes them:

- Small (MBs instead of GBs)  
- Fast to start (milliseconds instead of minutes)  
- Easy to scale  

### 2.4 Perfect for Microservices  
Docker fits microservices architectures perfectly because:

- Each service runs in its own container  
- Services are isolated  
- Individual services can be scaled independently  
- Failures don’t spill across services  

### 2.5 Developer Productivity  
Developers can:

- Clone a project  
- Run containers  
- Instantly get a working setup  

No need to install:

- Python, Node, Java versions  
- Databases  
- Redis, Nginx, Postgres  
- Dependencies manually  

Everything is containerized.

---

# 3. Virtualization vs Containerization

This is one of the most important concepts for understanding Docker.

## 3.1 Virtual Machines (VMs)

Virtual machines emulate an entire hardware stack and run a complete OS.  
Each VM has:

- Guest OS  
- Kernel  
- Init system  
- File tree  
- Processes  
- Libraries  
- Applications  

### VM Architecture Diagram

```
+------------------------------+
|        App / Libraries       |
+------------------------------+
|       Guest OS Kernel        |
+------------------------------+
|         Guest OS             |
+------------------------------+
|       Hypervisor (KVM)       |
+------------------------------+
|          Host OS             |
+------------------------------+
|          Hardware            |
+------------------------------+
```

### Drawbacks of VMs

- Heavy (consume GBs)  
- Slow to start (minutes)  
- Require full OS installation  
- Resource-intensive  
- Hard to scale quickly  
- Isolation is strong but costly  

## 3.2 Containers

Containers run directly on the host OS kernel.  
They do NOT require a separate guest operating system.

### Container Architecture Diagram

```
+------------------------------+
|       App / Process          |
+------------------------------+
|  Runtime Libraries (Layered) |
+------------------------------+
|   Container Engine (Docker)  |
+------------------------------+
|         Host OS Kernel       |
+------------------------------+
|           Hardware           |
+------------------------------+
```

### Key Benefits

- Lightweight  
- Start instantly  
- Share host kernel  
- Very efficient  
- Easy to scale  
- Perfect for microservices  

### 3.3 The Real Difference  
| Feature | VMs | Containers |
|---------|-----|------------|
| Boot Time | Minutes | Seconds / milliseconds |
| OS Required | Guest OS | No extra OS |
| Size | GBs | MBs |
| Isolation | Strong | Strong but lighter |
| Performance | Slower | Near native |
| Density | Few per machine | Dozens/hundreds |

Containers give you VM-like process isolation **without** the overhead of virtualization.

---

# 4. Installing Docker

Docker installation differs slightly across operating systems.  
Below are the most common methods.

---

## 4.1 Installing Docker on Ubuntu

### Step 1: Update system

```
sudo apt update
```

### Step 2: Install Docker Engine

```
sudo apt install docker.io -y
```

### Step 3: Enable Docker at startup

```
sudo systemctl enable docker
sudo systemctl start docker
```

### Step 4: Verify installation

```
docker --version
docker info
```

### Step 5: Allow non-root usage

By default, `docker` requires `sudo`.

To run Docker without `sudo`:

```
sudo usermod -aG docker $USER
```

Log out and log in again for changes to apply.

### Step 6: Check status

```
systemctl status docker
```

---

## 4.2 Installing Docker on Windows

### Using Docker Desktop

1. Install **Docker Desktop for Windows**  
2. Enable **WSL2 backend**  
3. Install **Ubuntu** from Microsoft Store  
4. Docker Desktop integrates automatically  

### Verification

```
docker version
docker info
```

Docker Desktop bundles:

- Docker CLI  
- Docker Daemon  
- Kubernetes (optional)  
- GUI dashboard  

---


# 5. Docker Engine Architecture (Deep Explanation)

Docker Engine is the heart of Docker. It is responsible for building images, running containers, managing networks, handling storage, and interacting with the OS kernel.

Understanding this architecture is essential for becoming a real Docker expert.

---

## 5.1 High-Level Architecture Overview

Below is a simplified representation of the Docker Engine:

```
+-------------------------------------------------------------+
|                         Docker Client                       |
|                   (docker CLI, REST API calls)              |
+-------------------------------------------------------------+
                                 |
                                 v
+-------------------------------------------------------------+
|                      Docker REST API Layer                  |
|         (Receives commands, validates, forwards to daemon)  |
+-------------------------------------------------------------+
                                 |
                                 v
+-------------------------------------------------------------+
|                         Docker Daemon (dockerd)             |
|   - Builds images                                            |
|   - Runs containers                                          |
|   - Manages networks                                         |
|   - Manages volumes                                          |
|   - Talks to containerd runtime                              |
+-------------------------------------------------------------+
                                 |
                                 v
+-------------------------------------------------------------+
|                         containerd                           |
|       - Manages container lifecycle (create, start, stop)    |
|       - Downloads/pushes images                              |
|       - Works with runc to run containers                    |
+-------------------------------------------------------------+
                                 |
                                 v
+-------------------------------------------------------------+
|                             runc                             |
|     - OCI-compliant runtime                                  |
|     - Actually spawns containers using Linux kernel APIs     |
+-------------------------------------------------------------+
```

This pipeline is extremely important:

- **docker CLI** does *not* run containers  
- It sends instructions to the **dockerd daemon**  
- **dockerd** delegates container execution to **containerd**  
- **containerd** uses **runc** to actually create OS-level container processes  

---

## 5.2 Why So Many Components?

Docker used to be one big monolithic daemon.  
Now it follows the **OCI (Open Container Initiative)** standards.

Breaking into components gives:

1. **Security**  
   - runc runs containers in an isolated environment  
2. **Stability**  
   - If a container crashes, daemon stays running  
3. **Modularity**  
   - Other tools (Kubernetes) can use containerd and runc  
4. **Compatibility**  
   - Any OCI-compliant image or runtime works

---

## 5.3 How Docker Creates a Container (Internals)

When you run:

```
docker run ubuntu
```

Internally, this is what happens:

1. **CLI parses your command**  
   - Recognizes options: -it, -d, -p, -v  

2. **CLI sends REST request** to dockerd  
   Example: `POST /containers/create`

3. **dockerd pulls image** (if needed)

4. **dockerd asks containerd** to start container

5. **containerd uses runc** to create a container process using:

   - **Namespaces** (PID, UTS, IPC, NET, MNT)  
   - **cgroups** (resource control)  
   - **UnionFS** (layered filesystem)  

6. **runc executes the container process**  
   It becomes a real Linux process on host.

7. **containerd monitors** the container  
8. **dockerd reports status** to CLI  
9. **CLI prints container ID**

---

## 5.4 Docker Communication Methods

Docker communications use:

- Unix socket: `/var/run/docker.sock`  
- Or TCP port: `2375` (if enabled)  

The socket is extremely powerful — it allows full control of Docker.  
This is why exposing it publicly is a **security risk**.

---

# 6. Docker Client & Daemon (Deep Dive)

## 6.1 Docker Client (CLI)

The Docker client is:

- A command-line tool  
- A REST API client  
- A translator between user commands and daemon instructions  

It does NOT:

- Start containers  
- Manage images  
- Allocate networks  
- Handle storage  

It simply forwards instructions to the daemon.

Examples:

```
docker images
docker run nginx
docker exec -it container_id bash
```

All of these become REST calls like:

```
GET /images/json
POST /containers/create
POST /containers/{id}/exec
```

---

## 6.2 Docker Daemon (dockerd)

The daemon is the brain of the system.

It is responsible for:

- Loading and saving images  
- Building images from Dockerfiles  
- Creating and running containers  
- Handling networking (bridge, host, overlay)  
- Managing volumes  
- Supporting plugins  
- Enforcing resource limits  
- Communicating with containerd  

### Daemon internals:

- Written in Go  
- Runs as root  
- Uses Linux kernel features directly  
- Manages container metadata  
- Watches container lifecycle events  

### Check if daemon is running:

```
systemctl status docker
```

### Restart daemon:

```
systemctl restart docker
```

---

# 7. Docker Objects (Extremely Detailed)

This chapter explains Docker’s core objects.  
A deep understanding of these is required before moving to Dockerfile, Compose, or orchestration.

---

## 7.1 Images (Deep Explanation)

A Docker image is:

- A read-only filesystem  
- Built from layers  
- Created using a Dockerfile  
- Versioned using tags (e.g., `python:3.10`)  
- Portable across machines  
- Immutable once built  

### Images contain:

- Base OS layer  
- Application dependencies  
- Application source code  
- Metadata (CMD, ENV, EXPOSE, ENTRYPOINT)

### Images are stored in:

- Local Docker host  
- Docker Hub  
- Private registries  

### Image Layers Example:

```
Layer 4: Application code
Layer 3: Dependencies
Layer 2: Language runtime (Python/Node)
Layer 1: Base OS (Debian/Alpine)
```

Each layer is **cached** and **shared** between images.

---

## 7.2 Containers (Extremely Deep Explanation)

A container is a **runtime instance** of an image.

Meaning:

- An image is a template  
- A container is the actual running process created from that template  

### 7.2.1 What Makes a Container?

A container =

1. The **filesystem** (from image + writable layer)  
2. The **startup command** (from CMD/ENTRYPOINT)  
3. The **execution environment** (namespaces)  
4. The **resource control** (cgroups)  
5. The **network namespace**  
6. A **unique container ID**  
7. A running Linux process  

### 7.2.2 Filesystem Structure Inside a Container

```
/bin
/usr
/lib
/etc
/home
/app
```

This acts as if it were its own OS — but it's not a full OS.  
It’s simply isolated directories mounted using union filesystems.

### 7.2.3 How Containers Isolate Processes

Docker uses the following namespaces:

| Namespace | Purpose |
|----------|---------|
| PID      | Process isolation |
| NET      | Network interfaces, IPs, ports |
| UTS      | Hostname isolation |
| IPC      | Interprocess communication |
| MNT      | Filesystem mounts |
| USER     | User/Group IDs |

This means:

- A container cannot see host processes  
- A container cannot see host network interfaces  
- A container has its own hostname  
- A container has its own filesystem  

### 7.2.4 How Containers Control Resources

Docker uses **cgroups** to restrict:

- CPU  
- Memory  
- Disk IO  
- Network IO  

Example:

```
docker run --cpus 1 --memory 512m ubuntu
```

This controls how much load a container can put on the system.

### 7.2.5 Container Write Layer

Images are read-only.  
Containers add a **writable layer** on top.

When a container writes to a file, it goes to this layer, not to the image.

Container changes include:

- New files  
- Modified files  
- Deleted files  
- Logs  
- Temporary data  

When the container is removed, the write layer is also removed.

### 7.2.6 Container Networking

Each container has:

- Its own IP  
- Its own network interface  
- Its own routing table  

Containers can:

- Talk to each other  
- Talk to host  
- Access internet  

Using Docker networks:

```
docker network create mynet
docker run --network mynet nginx
```

### 7.2.7 Container Lifecycle

States:

- Created  
- Running  
- Paused  
- Stopped  
- Restarting  
- Exited  

Commands mapping the lifecycle:

```
docker create
docker run
docker pause
docker stop
docker restart
docker rm
```

---

## 7.3 Volumes (Full Detail Will Come in Storage Chapter)

Volumes store persistent data.  
They survive container deletion.

We will cover volumes in extreme depth later.

---

## 7.4 Networks (Full Detail Later)

Docker has many network modes:

- Bridge  
- Host  
- None  
- Overlay  
- Macvlan  

These will be explained in the networking chapters.

---

# 8. Docker Commands (Expanded)

This section expands basic Docker commands into conceptual understanding.

---

## 8.1 Listing Containers

```
docker ps
docker ps -a
```

### Explanation:

- `docker ps`: running containers only  
- `docker ps -a`: includes stopped containers  

---

## 8.2 Running Containers (Deep)

```
docker run ubuntu
docker run -it ubuntu /bin/bash
docker run -d nginx
docker run --name myserver nginx
```

Explanation:

- `-it`: interactive/terminal  
- `-d`: detached (runs in background)  
- `--name`: custom container name  

What happens internally:

- Creates container configuration  
- Allocates namespaces  
- Creates write layer  
- Assigns IP  
- Starts entrypoint  

---

## 8.3 Stopping / Removing Containers

```
docker stop myapp
docker rm myapp
docker rm -f myapp
```

`docker rm -f` = stop + remove in one command.

---

## 8.4 Executing Commands Inside Containers

```
docker exec -it app bash
docker exec app ls /
```

Difference:

- `exec` runs inside the container  
- `attach` connects STDIN/STDOUT  

---

## 8.5 Logs and Debugging

```
docker logs app
docker logs -f app
docker logs --tail 20 app
```

Logs include:

- STDOUT  
- STDERR  
- Application logs  

---

## 8.6 Pruning

```
docker container prune
docker image prune
docker system prune -a
```

Be careful with:

```
docker system prune -a
```

It deletes:

- All stopped containers  
- All dangling images  
- All unused images  

---

---

# 9. Docker Images (Extreme Deep Dive)

A Docker image is a **read-only, layered filesystem** used to create containers.  
It is one of the most important concepts to understand because everything in Docker relies on image behavior.

---

## 9.1 What an Image Actually Is

A Docker image is NOT:

- A full OS  
- A virtual machine  
- A running environment  

It IS:

- A stack of read-only layers  
- Each layer contains filesystem changes  
- Metadata describing how to run a container  

Think of it as:

```
A snapshot + instructions on how to launch the application
```

---

## 9.2 Image Structure

A Docker image typically contains:

1. **Base layer**  
   Example: Ubuntu, Alpine, Debian, CentOS  

2. **Runtime layer**  
   Example: Node.js, Python, Java, Go  

3. **Dependency layer**  
   Requirements, pip modules, npm packages, system dependencies  

4. **Application code layer**  
   Your app files  

5. **Configuration metadata**  
   EXPOSE, CMD, ENTRYPOINT, ENV, WORKDIR  

### Diagram

```
+----------------------------------------+
|            App Code Layer              |
+----------------------------------------+
|       Dependencies / Libraries         |
+----------------------------------------+
|      Language Runtime (Python/Node)    |
+----------------------------------------+
|              Base OS Layer             |
+----------------------------------------+
```

Each layer is:

- Immutable  
- Cached  
- Shared between images  
- Only rebuilt when needed  

---

## 9.3 Why Images Are Layered

Layering provides:

### 1. Efficient Caching  
If only one file changes, Docker rebuilds **only the affected layer**.

### 2. Fast Builds  
Layers that haven't changed are reused instantly.

### 3. Shared Storage  
If two images use the same base (e.g., Debian), they share the layer.

### 4. Portability  
Images can be transferred between machines efficiently.

---

## 9.4 Common Image Operations

```
docker pull ubuntu
docker images
docker inspect nginx
docker rmi myimage
```

---

# 10. Union File Systems (OverlayFS)

Docker uses a union filesystem such as:

- overlay2 (default)  
- AUFS (old)  
- btrfs, zfs (optional)

### 10.1 What UnionFS Does

UnionFS allows multiple layers to appear as **one merged filesystem**.

For example:

```
Layer 1: /usr/bin
Layer 2: /usr/local
Layer 3: /app
```

Container sees:

```
/usr/bin
/usr/local
/app
```

Merged into a single view.

---

### 10.2 Layer Types

#### Read-Only Layers
Built from the Dockerfile. Shared by all containers.

#### Writable Container Layer
Only containers have this layer.

When a container writes a file:

- The file is copied from image → to container’s writable layer  
- Then modified there  
- This is called **Copy-on-Write**

You will see this effect:

```
docker commit
docker diff
```

---

# 11. Build Context (Very Important)

Build context is the folder you pass to the `docker build` command.

Example:

```
docker build -t myapp .
```

The `.` means:

- Send entire folder to Docker daemon  
- Docker daemon uses it for COPY, ADD instructions  

### 11.1 Why Build Context Matters

Docker sends **everything in the directory** to the daemon.  
This can result in:

- Slow builds  
- Huge image context  
- Accidental leak of files (e.g., large logs, .env files)

### 11.2 Use .dockerignore

Always create:

```
.dockerignore
```

Example:

```
node_modules
.env
.git
__pycache__
*.log
```

This improves:

- Build performance  
- Security  
- Clean images  

---

# 12. Dockerfile (Formal Deep Dive)

A Dockerfile is a set of instructions that tells Docker:

- What to include in the image  
- Which commands to run  
- How to set up the environment  
- How to start the application  

---

## 12.1 Most Common Instructions

In order of appearance:

1. **FROM**  
2. **WORKDIR**  
3. **COPY**  
4. **ADD**  
5. **RUN**  
6. **ENV**  
7. **EXPOSE**  
8. **ENTRYPOINT**  
9. **CMD**  

We will explain each deeply.

---

# 13. FROM Instruction

`FROM` defines the base image.

Examples:

```
FROM ubuntu:22.04
FROM python:3.10-slim
FROM node:18-alpine
```

### 13.1 Why FROM is important

- Determines OS libraries  
- Determines image size  
- Determines security patches  
- Determines available tools  

### 13.2 Choosing Base Images

**Slim images**:

- python:3.10-slim  
- node:18-slim

Pros: small, fast  
Cons: some libraries missing

**Alpine images** (very small):

- node:18-alpine  
- golang:1.21-alpine

Pros: extremely small  
Cons: musl libc can break some packages  

**Full OS images**:

- ubuntu  
- debian  

Pros: full compatibility  
Cons: larger size  

---

# 14. WORKDIR Instruction

Sets the working directory inside the image.

```
WORKDIR /app
```

### Explanation:

- Prevents needing `cd /app` repeatedly  
- Automatically creates directory if it doesn't exist  
- All subsequent instructions use this directory  
- All CMD/ENTRYPOINT commands run in this directory  

---

# 15. COPY and ADD

## 15.1 COPY

Copies files from host to image:

```
COPY . .
COPY requirements.txt .
```

Best practice:

- COPY only what you need  
- Use .dockerignore  

## 15.2 ADD

Same as COPY **but with extra features**:

- Can extract tar files  
- Can download URLs  

Because of this, ADD is **not recommended** unless needed.

Example:

```
ADD app.tar.gz /app
```

Otherwise, always use:

```
COPY
```

---

# 16. RUN Instruction

RUN executes commands at **build time**, inside the image.

Examples:

```
RUN apt update
RUN pip install -r requirements.txt
RUN npm install
```

### 16.1 What RUN Actually Does

- Creates a new image layer  
- Executes command in that layer  
- Commits filesystem changes  

Example:

```
RUN apt update
```

Creates a layer that contains:

- Modified /var/lib/apt lists  
- Installed packages  

This layer is cached.  
If nothing changes, Docker reuses it.

---

# 17. CMD vs ENTRYPOINT (Complete Deep Dive)

This is one of the most confusing topics in Docker, so we will master it fully.

---

## 17.1 CMD (Container Default Command)

Example:

```
CMD ["python", "app.py"]
```

Meaning:

- If user runs `docker run image`, CMD executes  
- If user provides a command, CMD is **replaced**  

Example:

```
docker run myimage ls
```

This **replaces CMD** with `ls`.

CMD is typically used for:

- Default application start commands  
- Scripts that can be overridden  

---

## 17.2 ENTRYPOINT (Always Executes)

Example:

```
ENTRYPOINT ["python"]
CMD ["app.py"]
```

Container runs:

```
python app.py
```

If user runs:

```
docker run myimage test.py
```

The result is:

```
python test.py
```

ENTRYPOINT **cannot be replaced** (only appended).

---

## 17.3 Practical Rule

### Use ENTRYPOINT for:

- Required startup command  
- Commands that must always run  
- Tooling images (e.g., `docker run curl www.example.com`)

### Use CMD for:

- Default arguments  
- Configurable behavior  

---

## 17.4 ENTRYPOINT Modes

### Exec form:

```
ENTRYPOINT ["python", "app.py"]
```

Preferred.

### Shell form:

```
ENTRYPOINT python app.py
```

Runs in `/bin/sh`, less secure.

---

# 18. ENV Instruction

Sets environment variables **inside the image**.

Example:

```
ENV MODE=production
ENV PORT=5000
```

Inside container:

```
echo $MODE
echo $PORT
```

### ENV is used for:

- Configuration  
- Secrets (not recommended)  
- Passing data to ENTRYPOINT and CMD  

---

# 19. Multi-Stage Builds (Essential for Production)

Multi-stage builds create:

- Smaller images  
- Cleaner images  
- Faster builds  
- Better security  

---

## 19.1 Example

```
# Stage 1: Build stage
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Stage 2: Production stage
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

### What happens:

1. Node container builds the application  
2. Output files copied into a tiny Nginx image  
3. Final image is extremely small (~20MB)  
4. Build tools are not included in final image  

---

## 19.2 Benefits

- Reduced attack surface  
- Faster deployment  
- Less disk usage  
- Cleaner final image  
- Accurate separation of build and production environments  

---


# 20. Container Lifecycle (Extremely Detailed)

A Docker container goes through several stages from creation to deletion.  
It is essential to understand these states to manage containers effectively.

---

## 20.1 Container States

A container can be in:

1. **Created**  
   - The container exists, but the main process has not started  
   ```
   docker create nginx
   ```

2. **Running**  
   - The container’s main process (PID 1) is running  
   ```
   docker run nginx
   ```

3. **Paused**  
   - All processes are frozen using cgroups freezer subsystem  
   ```
   docker pause container
   ```

4. **Stopped (Exited)**  
   - Process stopped with exit code  
   ```
   docker stop container
   ```

5. **Restarting**  
   - Restart policy triggered  

6. **Dead**  
   - Abnormal termination; rarely occurs  

---

## 20.2 Lifecycle Commands

```
docker create image
docker run image
docker pause container
docker unpause container
docker stop container
docker start container
docker restart container
docker kill container
docker rm container
```

### Key Distinctions

- `docker stop` = graceful (SIGTERM → SIGKILL)  
- `docker kill` = immediate force kill  

---

## 20.3 How Docker Starts a Container (Internals)

Running:

```
docker run ubuntu
```

Internally:

1. Image is pulled (if missing)  
2. Container filesystem is created (read-only layers + write layer)  
3. Network namespace created  
4. IP assigned  
5. Mount namespace prepared  
6. Process executed through runc  
7. containerd monitors it  
8. dockerd reports status  

---

# 21. Ports in Docker (Very Deep Explanation)

Containers have their own **isolated network namespace**, meaning:

- Their own IP  
- Their own routing table  
- Their own network interfaces  
- They are not directly reachable from the host without publishing ports  

---

## 21.1 Port Mapping Syntax

```
docker run -p HOST_PORT:CONTAINER_PORT image
```

Example:

```
docker run -p 8080:80 nginx
```

Means:

- The application inside container listens on port **80**  
- Docker maps host **8080** → container **80**  
- Access via: http://localhost:8080  

---

## 21.2 EXPOSE Instruction (Misunderstood Feature)

```
EXPOSE 3000
```

Important facts:

- It **does NOT publish ports**  
- It only documents intended ports  
- It is metadata only  

You still must run:

```
docker run -p 3000:3000 image
```

---

## 21.3 Port Mapping Types

### Type 1: Host to container

```
-p 8080:80
```

### Type 2: Auto-assign host port

```
-P
```

Container EXPOSE ports get mapped automatically:

Example:

```
0.0.0.0:49153 → 80
```

---

# 22. Docker Networking Basics

Every container receives:

- Its own network namespace (isolated network stack)  
- Its own virtual NIC (veth pair)  
- Its own internal IP  
- Its own routing table  
- Its own DNS resolver  

### When a container is created:

1. Docker creates a veth pair  
2. One end stays in host  
3. Other end goes into container namespace  
4. Connects to a bridge network  
5. Container gets IP from Docker’s subnet  

Example:

```
172.17.0.2
```

---

# 23. Bridge Networks (Deep Internal Explanation)

Bridge is the **default network mode** used by Docker when you run:

```
docker run nginx
```

### 23.1 How Bridge Networking Works

Diagram:

```
+----------------------------- Host Machine ------------------------------+
|                                                                         |
|   +----------------------+            +------------------------------+   |
|   |  Container A         |            | Container B                 |   |
|   |  172.17.0.2          |            | 172.17.0.3                  |   |
|   +----------+-----------+            +--------------+--------------+   |
|              |                                           |             |
|              veth0                                       veth2           |
|              |                                           |             |
|        +-----+-------------------------------------------+-----+       |
|        |                 docker0 (bridge)                       |       |
|        +--------------------------------------------------------+       |
|                                                                         |
+-------------------------------------------------------------------------+
```

Bridge network acts like a virtual LAN.

Containers connected to the same bridge:

- Can communicate freely  
- Can reach internet via NAT  
- Cannot be accessed from outside without port mapping  

---

## 23.2 Default Bridge vs User-Defined Bridge

### Default Bridge (`docker0`)
- Automatically created  
- Containers communicate via IP only  
- Does not support DNS by name  

### User-Defined Bridge
Created using:

```
docker network create mynet
```

Benefits:

- Containers can communicate using names  
- Better isolation  
- Allows static IPs  
- Better for production  

Example:

```
docker run --network mynet --name app nginx
docker exec app ping other-container
```

---

## 23.3 Inspecting Bridge Network

```
docker network inspect bridge
```

Shows:

- Subnet  
- Gateway  
- Connected containers  
- veth mappings  

---

# 24. Host Network Mode

```
docker run --network host nginx
```

### Meaning:

- Container shares host's network stack  
- No isolation  
- No port mapping required  
- Performance is highest  
- Less secure  

Useful for:

- Monitoring agents  
- Network tools  

But **avoid using for web apps** due to security concerns.

---

# 25. None Network Mode

```
docker run --network none ubuntu
```

Container has:

- No internet  
- No access to other containers  
- No network interface except loopback  

Used for:

- Security  
- Testing  
- Isolated workloads  

---

# 26. User-Defined Networks (Deep Explanation)

User-defined networks allow:

- Full DNS-based service discovery  
- Better isolation  
- Clean architecture  

Create:

```
docker network create backend
docker run --network backend --name api python-app
docker run --network backend --name db postgres
```

Now containers can resolve each other by name:

```
ping db
ping api
```

---

# 27. Static IP Assignment (When Needed)

You can assign static IPs **only** on user-defined bridge networks.

Example:

```
docker network create --subnet=192.168.10.0/24 mynet

docker run --network mynet --ip 192.168.10.10 nginx
docker run --network mynet --ip 192.168.10.20 redis
```

### Why static IPs are rarely needed:

- DNS inside Docker works perfectly  
- Services should use names  
- IP conflicts possible  

Use static IPs only for:

- Legacy systems  
- Special networking setups  
- VPNs  
- Reverse proxies  

---

# 28. Docker DNS (Internal Mechanism)

Inside Docker networks, a DNS server runs automatically.

### DNS Behavior

- Every container registers its name  
- All containers on the same network can resolve via DNS  
- User-defined networks support name resolution  
- The default bridge network does **not** support names  

### Example

If you run:

```
docker run --network backend --name api python-app
docker run --network backend --name redis redis
```

Inside api container:

```
ping redis
```

It resolves automatically.

This is the foundation of microservices in Docker.

---

# 28. Advanced Networking Internals

Docker networking is built on top of Linux kernel primitives.  
To truly understand Docker networking, you must understand:

- veth pairs  
- Linux bridges  
- Namespaces  
- iptables  
- NAT (MASQUERADE)  
- Port forwarding rules  
- How Docker modifies kernel routing tables  

This chapter explains networking at a **low-level**, the way Docker actually implements it.

---

## 28.1 Virtual Ethernet Interfaces (veth pairs)

Every container gets a “virtual ethernet cable” called a **veth pair**:

- One side lives inside the container (`eth0`)  
- The other side lives on the host (`vethXYZ`)  

Diagram:

```
Container Namespace                 Host Namespace
--------------------               -----------------------
|   eth0 (veth peer) | <---------> | vethXYZ (peer)       |
--------------------               -----------------------
```

The container’s `eth0` connects into Docker’s virtual bridge.

---

## 28.2 docker0 — The Default Bridge

When Docker starts, it creates a Linux bridge:

```
docker0
```

This bridge behaves like a virtual switch.

```
+----------------------------+
|         docker0            |
|   (acts like a switch)     |
+----------------------------+
     |                |
  veth1             veth2
   |                  |
Container A      Container B
172.17.0.2        172.17.0.3
```

The bridge has:

- Its own IP (typically 172.17.0.1)  
- A routing table entry  
- DHCP-like IP assignment via Docker  

---

## 28.3 Routing Traffic

Containers route traffic to docker0:

```
default via 172.17.0.1 dev eth0
```

docker0 routes:

- Container-to-container  
- Container-to-host  
- Container-to-internet  

---

## 28.4 NAT and MASQUERADE

Docker uses iptables NAT (MASQUERADE) so containers can reach the internet.

Run:

```
iptables -t nat -L -n
```

You will see:

```
MASQUERADE  all  --  172.17.0.0/16  !172.17.0.0/16
```

Meaning:

- Any packet leaving the container subnet  
- Gets NATed to the host’s public IP  

This makes containers behave like devices behind a router.

---

## 28.5 Port Mapping Internals (-p)

If you run:

```
docker run -p 8080:80 nginx
```

Docker adds an iptables DNAT rule:

```
DNAT --to-destination 172.17.0.2:80
```

Meaning:

- Host port 8080 → container port 80  
- Achieved using iptables, not container changes  

Port mapping is purely a host-level operation.

---

# 29. Container-to-Host Communication

Containers can communicate with host in multiple ways.

---

## 29.1 docker0 Gateway

Host accessible inside container via:

```
172.17.0.1
```

Example:

```
curl http://172.17.0.1:5000
```

---

## 29.2 host.docker.internal (Docker Desktop)

On Windows/Mac:

```
ping host.docker.internal
```

Useful when:

- Application inside container needs host DB  
- Reverse proxies  
- Dev environment communication  

---

# 30. Volumes vs Bind Mounts (Deep Explanation)

Docker provides **three** types of file persistence:

1. **Volumes** (recommended for production)  
2. **Bind Mounts** (mount host directory)  
3. **tmpfs mounts** (in-memory filesystem)  

Understanding their differences is essential.

---

# 31. Volumes (Deep Dive)

Volumes are stored in Docker-managed locations:

```
/var/lib/docker/volumes/<volume>/_data/
```

### Characteristics:

- Managed entirely by Docker  
- Survive container deletion  
- Portable  
- Safe for databases  
- Permission-handled by Docker  

### Create a volume:

```
docker volume create mydata
```

### Use it:

```
docker run -v mydata:/var/lib/mysql mysql
```

### Inspect:

```
docker volume inspect mydata
```

---

## 31.1 Why Volumes are best for production

- They are portable  
- Docker manages permissions  
- Work consistently across OS  
- Backups can target volume directories  
- Bind mounts may break on Windows due to path differences  

---

# 32. Bind Mounts (Deep Explanation)

Bind mounts map a **host folder** into a container.

Usage:

```
docker run -v /host/path:/container/path nginx
```

### Characteristics:

- Direct access to host files  
- Useful for development  
- Allows hot-reloading code  
- Dangerous for production if host filesystem changes unexpectedly  

Example (local dev):

```
docker run -v $(pwd):/app python
```

Container sees live changes.

---

## 32.1 Drawbacks of Bind Mounts

- Host OS permissions affect container  
- Not portable  
- Windows path handling issues  
- SELinux/AppArmor restrictions  
- Easy to break if host folder deleted  

Production environments use **volumes**, not bind mounts.

---

# 33. tmpfs Mounts (In-memory storage)

tmpfs mounts store data **in RAM**, not disk.

Example:

```
docker run --tmpfs /cache nginx
```

Characteristics:

- Very fast  
- Disappears on container stop  
- Good for temporary files  
- Avoids disk I/O  

Used for:

- Caches  
- Session stores  
- Sensitive data that should not persist  

---

# 34. Docker Storage Drivers (Extremely Deep)

Docker uses storage drivers to manage:

- Read-only layers  
- Writable container layer  
- Union filesystem behavior  

---

## 34.1 Common Storage Drivers

| Driver | Description |
|--------|-------------|
| overlay2 | Default on modern Linux, fast + stable |
| aufs | Old driver, deprecated |
| btrfs | Advanced filesystem features |
| zfs | Enterprise-grade snapshotting |
| devicemapper | Old, block-based, deprecated |

Most systems use **overlay2**.

---

## 34.2 How overlay2 Works

overlay2 uses *copy-on-write* for modifications.

When container modifies a file:

1. Check if file exists in upper layer  
2. If not, copy from read-only lower layer  
3. Write modified file in upper layer  

Diagram:

```
UpperDir (container write layer)
/var/lib/docker/overlay2/<id>/diff

LowerDir (image layers)
/var/lib/docker/overlay2/<layers>
```

OverlayFS merges them into a single view.

---
# 35. Container Resource Limits (Deep Explanation)

Containers share the host kernel, which means they can potentially use unlimited CPU, memory, and IO unless restricted.  
Docker provides fine-grained controls using Linux cgroups to limit:

- CPU usage  
- Memory usage  
- Block I/O  
- PIDs  
- Huge pages  

These controls prevent one container from consuming all host resources.

---

## 35.1 Limiting Memory

Syntax:

```
docker run --memory=512m ubuntu
```

Meaning:

- Container can use up to **512 MB RAM**  
- If it exceeds this limit, OOM killer terminates the process  

Additional flags:

```
--memory-swap
--memory-reservation
```

### Example:

```
docker run --memory=256m --memory-swap=512m ubuntu
```

Explanation:

- Container can actively use 256 MB  
- It can borrow an additional 256 MB from swap  
- Hard limit is 512 MB  

---

## 35.2 Limiting CPU Usage

### Limit number of CPUs:

```
docker run --cpus=1.5 ubuntu
```

Meaning:

- Container can use 1.5 CPU cores (150% of a single core)

### CPU shares (relative CPU priority):

```
docker run --cpu-shares=512 ubuntu
```

Default is **1024**.

Values are relative:

- Container A: 1024  
- Container B: 512  

A gets 2× more CPU under load.

---

## 35.3 Limiting PIDs (process count)

```
docker run --pids-limit=100 ubuntu
```

Prevents runaway forks (fork bombs).

---

## 35.4 Limiting Block I/O

```
docker run --device-read-bps /dev/sda:1mb
docker run --device-write-iops /dev/sda:50
```

This is essential for:

- Database containers  
- High IO workloads  

---

# 36. Healthchecks (Deep Implementation)

A HEALTHCHECK monitors container health by running periodic commands.

Syntax:

```
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:5000/health || exit 1
```

### 36.1 What Docker Does Internally

Docker creates:

- A child process to run the check  
- Logs success/failure  
- Updates container health status  

Possible states:

- `healthy`  
- `starting`  
- `unhealthy`  

If `unhealthy`, orchestrators like Docker Swarm or Kubernetes can restart the container automatically.

---

## 36.2 Manual check inside container:

```
docker inspect --format='{{json .State.Health}}' app
```

---

# 37. Container Logging Drivers (Deep Dive)

Docker supports multiple logging drivers:

| Driver | Use Case |
|--------|----------|
| json-file | Default on Linux |
| local | Optimized format |
| syslog | Integrates with syslog server |
| journald | For systemd |
| fluentd | Centralized logging |
| awslogs | AWS CloudWatch |
| splunk | Enterprise logging |

---

## 37.1 Configure logging driver:

```
docker run --log-driver local nginx
```

---

## 37.2 json-file (default)

Logs stored in:

```
/var/lib/docker/containers/<id>/<id>-json.log
```

Disadvantage:

- Logs grow indefinitely unless log rotation is configured  

Enable log rotation:

```
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Saved in:

```
/etc/docker/daemon.json
```

---

# 38. Debugging Containers (Advanced Techniques)

Debugging requires understanding namespaces, processes, and runtime behavior.

---

## 38.1 Using docker exec

Check process:

```
docker exec -it app bash
```

Useful for:

- Inspecting logs  
- Checking environment variables  
- Debugging configuration  

---

## 38.2 Using nsenter (Most Powerful)

nsenter enters container namespaces **without exec**, meaning even when the container is broken.

Find container PID:

```
docker inspect -f '{{.State.Pid}}' app
```

Enter all namespaces:

```
nsenter --target <pid> --mount --uts --ipc --net --pid
```

This allows:

- Inspecting isolation  
- Debugging networking issues  
- Running commands inside container mount namespace  

---

## 38.3 Inspecting container filesystem

```
docker inspect app
docker diff app
docker cp app:/etc/app.conf .
```

`docker diff` shows:

- Modified  
- Added  
- Deleted files  

---

## 38.4 Using strace

Trace system calls:

```
docker exec -it app strace -p 1
```

Useful for:

- Debugging crashes  
- Understanding app behavior  
- Tracking file access  

---

# 39. Dockerfile Advanced Patterns

These patterns improve image quality, performance, and maintainability.

---

## 39.1 Using Builder Pattern (Multi-stage Builds)

Example for Go:

```
FROM golang:1.20 AS builder
WORKDIR /app
COPY . .
RUN go build -o server

FROM alpine
COPY --from=builder /app/server /usr/local/bin/server
CMD ["server"]
```

Benefits:

- Final image extremely small  
- No build tools in final image  
- Lower attack surface  

---

## 39.2 Minimizing Layers

Combine RUN commands:

```
RUN apk update && apk add --no-cache curl git openssl
```

---

## 39.3 Avoid Installing Unnecessary Packages

Bad:

```
RUN apt install wget vim git curl python3
```

Good:

- Install only what your application needs  

---

## 39.4 Explicit Version Pinning

Good practice:

```
RUN apk add --no-cache nginx=1.20.2
```

Ensures reproducible builds.

---

## 39.5 Never Run as Root

Add non-root user:

```
RUN addgroup -S app && adduser -S app -G app
USER app
```

Running as non-root improves security dramatically.

---

# 40. Container Security Best Practices (Deep)

Security is fundamental when deploying containers in production.

---

## 40.1 Minimize Attack Surface

- Use slim or alpine images  
- Remove build tools in final image  
- Use multi-stage builds  

---

## 40.2 Disable root user

```
USER app
```

---

## 40.3 Use Read-only Root Filesystem

```
docker run --read-only nginx
```

---

## 40.4 Drop Linux Capabilities

Containers run with many kernel capabilities by default.

Drop all:

```
--cap-drop ALL
```

Add only required:

```
--cap-add NET_ADMIN
```

---

## 40.5 Never Expose Docker Socket

Never mount:

```
/var/run/docker.sock
```

Unless absolutely required.  
Mounting the socket gives full host control.

---

# 41. Resource Monitoring Tools

Tools for real-time monitoring:

```
docker stats
docker top
docker ps --size
```

---

## 41.1 docker stats

Shows:

- CPU  
- Memory  
- Network IO  
- Block IO  

---

## 41.2 docker top

Shows processes running inside container.

Equivalent to `ps` inside the container.

---

# 42. Reinforcing Concepts with Real-World Examples

## 42.1 Node.js production image (optimized)

```
FROM node:18-alpine
WORKDIR /app
COPY package*.json .
RUN npm ci --only=production
COPY . .
CMD ["node", "server.js"]
```

---

## 42.2 Python optimized image

```
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

---

## 42.3 Nginx reverse proxy container

```
FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
```

---

# 43. Docker Networking Deep Dive: Overlay Networks

Overlay networks allow multiple Docker hosts to communicate as if they were on the same local network.  
These are essential for:

- Multi-node deployments  
- Distributed applications  
- Swarm clusters  
- Multi-host microservices  

Overlay networks operate at **Layer 3** and use:

- VXLAN encapsulation  
- Gossip-based membership  
- Distributed key-value store  

---

## 43.1 How Overlay Networks Work (Internal Explanation)

At a high level:

1. A container sends a packet to another container on a different host  
2. Docker encapsulates the packet inside a VXLAN header  
3. The packet travels across the physical network  
4. The receiving host removes VXLAN encapsulation  
5. Packet is delivered to the target container  

Diagram:

```
Container A ---- Host 1 ---- Physical Network ---- Host 2 ---- Container B
         \___________ VXLAN Encapsulated Traffic ___________/
```

Overlay networks create a virtual L3 network spanning multiple nodes.

---

## 43.2 Why Overlay Networks Matter

- They enable cross-host service discovery  
- They allow multi-machine microservices  
- They avoid manually configuring IP routes  
- They are essential for cluster orchestrators  

---

## 43.3 Creating Overlay Networks

Overlay networks require Docker Swarm or equivalent cluster.

Example:

```
docker swarm init
docker network create -d overlay my-overlay
```

Run service on overlay:

```
docker service create --name web --network my-overlay nginx
```

Containers across nodes join the same virtual network.

---

# 44. Docker Compose (Deep Dive)

Docker Compose is a tool for defining and running multi-container applications using a YAML file:

```
docker-compose.yml
```

Compose allows you to:

- Define services  
- Connect services with networks  
- Share volumes  
- Configure environment variables  
- Create dependencies  
- Define build instructions  

---

## 44.1 Compose File Structure (Complete Breakdown)

A typical `docker-compose.yml`:

```
version: "3.9"

services:
  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DB_HOST=db
    depends_on:
      - db

  db:
    image: postgres:15
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

---

### Sections explained:

#### version
Specifies Compose specification version.

#### services
Defines all containers your app needs.

#### build
Build image using Dockerfile.

#### image
Use an existing image from registry.

#### ports
Map host → container ports.

#### environment
Pass environment variables.

#### volumes
Mount persistent volumes.

#### depends_on
Controls startup order.

---

## 44.2 Starting and Stopping Compose Apps

Start everything:

```
docker compose up
```

Start in detached mode:

```
docker compose up -d
```

Stop services:

```
docker compose down
```

Stop but keep volumes:

```
docker compose down --volumes
```

Rebuild:

```
docker compose up --build
```

---

## 44.3 Compose Networks

By default, Compose creates a **bridge network** for the project.

Containers can communicate via service names:

```
api → db
redis → api
```

Inside api:

```
ping db
```

DNS resolves automatically.

---

## 44.4 Overriding Configurations

Create multiple configs:

- `docker-compose.yml`
- `docker-compose.prod.yml`

Run with:

```
docker compose -f docker-compose.yml -f docker-compose.prod.yml up
```

---

# 45. Multi-Container Application Architecture

Real applications require multiple containers:

- API  
- Database  
- Cache  
- Frontend  
- Message queue  
- Worker processes  
- Reverse proxy  

Docker Compose orchestrates these locally, while Swarm/Kubernetes orchestrate them in clusters.

---

## 45.1 Example Microservices Architecture

```
+-------------+      +-------------+      +-------------+
|   Frontend  | ---> |    API      | ---> |  Database   |
+-------------+      +-------------+      +-------------+
                           |
                           v
                    +-------------+
                    |   Redis     |
                    +-------------+
```

Each component is a separate container.

---

# 46. Docker Secret Management (Deep Explanation)

Secrets are used to store:

- Passwords  
- API keys  
- Database credentials  
- TLS certificates  

Best practice: **Never hardcode secrets in Dockerfile or image**.

---

## 46.1 Secrets in Docker Swarm

Create a secret:

```
echo "mypassword" | docker secret create db_pass -
```

Use secret in service:

```
docker service create \
  --name api \
  --secret db_pass \
  myapp
```

Inside container, secrets appear in:

```
/run/secrets/db_pass
```

---

## 46.2 Secrets in Compose

Compose v3 supports secrets, but only with Swarm.

Example:

```
secrets:
  api_key:
    file: ./api_key.txt
```

---

# 47. Docker Configs

Docker configs store non-sensitive application configs.

Example:

```
docker config create app_conf ./config.json
```

Use in service:

```
docker service create \
  --config app_conf \
  myapp
```

Configs appear at:

```
/etc/configs/<name>
```

---

# 48. OCI Standards (Deep Internal Explanation)

Docker follows the **OCI (Open Container Initiative)** specifications:

- Image Specification  
- Runtime Specification  
- Distribution Specification  

These standards allow:

- Kubernetes to use Docker images  
- containerd and CRI-O to run containers built by Docker  
- Tools like Podman to remain compatible  

---

## 48.1 OCI Image Specification

Defines how:

- Layers are structured  
- Metadata stored  
- Manifests created  

---

## 48.2 OCI Runtime Specification

Defines how container runtimes like runc:

- Create namespaces  
- Create cgroups  
- Set mount points  
- Spawn process #1  

---

## 48.3 Distribution Specification

Defines registry behavior:

- Pushing  
- Pulling  
- Authentication  
- Tagging  
- Manifests  

---

# 49. Docker in CI/CD Pipelines

Docker is heavily used in CI/CD for:

- Consistent build environments  
- Test isolation  
- Dependency reproducibility  
- Environment parity  
- Fast deployment  

---

## 49.1 Typical CI/CD Workflow

1. Push code to GitHub  
2. CI server builds Docker image  
3. CI runs tests inside the container  
4. Image is pushed to registry  
5. CD deploys it to production  
6. Orchestrator starts new containers  

---

## 49.2 Example GitHub Actions Workflow

```
name: Build Docker Image

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Build
        run: docker build -t myapp .

      - name: Test
        run: docker run myapp pytest
```

---

## 49.3 Pushing Image to Registry

```
docker login -u user -p pass
docker tag myapp user/myapp:v1
docker push user/myapp:v1
```

---

# 50. Docker Registry Deep Dive

Docker Registry stores and distributes images.  
There are three types:

1. Docker Hub (public)  
2. Private registry  
3. Cloud registries:
   - AWS ECR  
   - GCP GCR  
   - Azure ACR  

---

## 50.1 Private Registry Example

Run your own registry:

```
docker run -d -p 5000:5000 --name registry registry:2
```

Push image:

```
docker tag myapp localhost:5000/myapp
docker push localhost:5000/myapp
```

Pull image:

```
docker pull localhost:5000/myapp
```

---
# 51. Container Orchestration (High-Level Overview)

As applications grow, running individual containers manually becomes impossible.  
You need orchestration when you must manage:

- Multiple containers  
- Across multiple hosts  
- With dynamic scaling  
- Automated restarts  
- Rolling updates  
- Service discovery  
- Load balancing  

Orchestration systems automate all of this.

The two major orchestrators are:

1. Docker Swarm  
2. Kubernetes  

---

# 52. Docker Swarm (Deep Explanation)

Docker Swarm is Docker’s built-in clustering and orchestration system.  
It converts multiple Docker hosts into one **virtual Docker engine**.

---

## 52.1 Swarm Architecture

Swarm consists of:

- **Managers**  
  - Handle cluster state  
  - Perform scheduling  
  - Maintain the Raft consensus  
- **Workers**  
  - Run tasks (containers)  
  - Receive instructions from managers  

Diagram:

```
+----------------------------+
|         Manager 1          |
|   (Raft Leader / Scheduler)|
+----------------------------+
      /            \
     /              \
+---------+     +---------+
| Worker1 |     | Worker2 |
+---------+     +---------+
```

---

## 52.2 Initializing Swarm

Initialize a swarm:

```
docker swarm init
```

Add worker nodes:

```
docker swarm join --token <token> <manager-ip>:2377
```

---

## 52.3 Deploying Services in Swarm

A service is a replicated container managed by Swarm.

Example:

```
docker service create --name api --replicas 3 nginx
```

Swarm automatically:

- Schedules containers  
- Restarts failed tasks  
- Balances across nodes  

---

## 52.4 Scaling Services

```
docker service scale api=10
```

Swarm distributes 10 replicas across worker nodes.

---

## 52.5 Rolling Updates

```
docker service update --image nginx:latest api
```

Swarm performs:

- Incremental update  
- Automatic rollback on failure  

---

# 53. Kubernetes (Conceptual Deep Dive)

Kubernetes (K8s) is the **industry standard orchestration platform** used by:

- Google  
- AWS EKS  
- Azure AKS  
- DigitalOcean  
- Enterprises worldwide  

Kubernetes manages:

- Deployments  
- Autoscaling  
- Networking  
- Stateful services  
- Configuration  
- Secrets  
- Load balancing  

---

## 53.1 Kubernetes Objects

Key Kubernetes primitives:

- **Pod** — smallest deployable unit (runs containers)  
- **Deployment** — manages replicas, rolling updates  
- **Service** — stable networking endpoint  
- **Ingress** — HTTP routing and reverse proxy  
- **ConfigMap** — configuration  
- **Secret** — encrypted config  
- **Volume** — storage  

---

## 53.2 Pod Explained (Deep)

A pod is:

- A wrapper around one or more containers  
- Containers in a pod share:
  - Network namespace  
  - Storage volumes  
  - localhost addressing  

Typical pod:

```
+------------------------------+
|            Pod               |
|   +----------------------+   |
|   |     App Container    |   |
|   +----------------------+   |
|   |  Sidecar Container   |   |
|   +----------------------+   |
+------------------------------+
```

Pods allow container cooperation (logs, proxies, monitoring).

---

## 53.3 Deployment Explained

A Deployment manages:

- Desired replicas  
- Updates  
- Rollbacks  

Example Deployment YAML:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx
```

---

## 53.4 Kubernetes Services

Services expose pods inside or outside the cluster.

Types:

- ClusterIP (default)  
- NodePort  
- LoadBalancer  
- ExternalName  

---

## 53.5 Why Kubernetes Became Standard

- Runs on any cloud  
- Automates everything  
- Handles failures  
- Implements self-healing  
- Provides autoscaling  
- Manages secrets and configs  
- Network abstraction  
- Works with any OCI container (Docker, containerd, CRI-O)

---

# 54. Docker Networking for Kubernetes (Important)

When Docker is used as a container runtime (via containerd), Kubernetes handles networking through the **CNI (Container Network Interface)**.

CNI plugins include:

- Flannel  
- Calico  
- Cilium  
- Weave Net  

These provide:

- Pod IPs  
- Routing  
- Network policies  
- Encryption  
- BGP routing (Calico)  

This chapter bridges Docker networking knowledge with Kubernetes.

---

# 55. Docker Swarm vs Kubernetes (Practical Comparison)

| Feature | Swarm | Kubernetes |
|--------|--------|-------------|
| Learning curve | Easy | Hard |
| Ease of setup | Simple | Complex |
| Scalability | Medium | Very High |
| Production adoption | Low/Medium | Very High |
| Networking | Built-in | CNI-based |
| Auto-scaling | No | Yes |
| Rolling updates | Yes | Yes |
| Secrets/Configs | Yes | Yes |

Swarm is excellent for:

- Simple clusters  
- Small teams  
- Quick deployments  

Kubernetes is ideal for:

- Enterprise scale  
- Multi-cloud  
- Complex workloads  

---

# 56. Docker Best Practices (Production-Level)

## 56.1 Minimize Image Size

- Use slim/alpine bases  
- Multi-stage builds  
- Remove build dependencies  
- Clean package caches  

---

## 56.2 Use Non-root User

Add user:

```
RUN adduser -D app
USER app
```

---

## 56.3 Read-only Filesystem

```
docker run --read-only nginx
```

---

## 56.4 Drop Linux Capabilities

```
--cap-drop ALL
--cap-add NET_ADMIN
```

---

## 56.5 Avoid Storing Secrets in Images

Use:

- Secrets  
- Vaults  
- Environment variables (limited use)  

Never store `.env` inside the image.

---

## 56.6 Pin Versions

```
RUN apk add --no-cache nginx=1.20.2
```

Prevents unexpected upgrades.

---

## 56.7 Use Healthchecks

```
HEALTHCHECK CMD curl -f http://localhost/ || exit 1
```

---

## 56.8 Optimize Layer Ordering

Changes early in Dockerfile invalidate the entire build cache.

Place frequently changing files (source code) **at the bottom**.

---

# 57. Real-World Docker Deployment Workflow

A typical real deployment flow:

1. Developer commits code  
2. CI builds image  
3. Tests run inside containers  
4. Image pushed to registry  
5. Production pulls image  
6. Orchestrator deploys new version  
7. Rolling updates applied  
8. Old containers gracefully removed  

This is the modern DevOps pipeline.

---

# 58. Debugging Networking Issues (Advanced)

## 58.1 Checking container interfaces

```
docker exec app ip addr
```

## 58.2 Checking routes

```
docker exec app ip route
```

## 58.3 Checking DNS resolving

```
docker exec app cat /etc/resolv.conf
```

## 58.4 Tracing traffic using tcpdump

Install tcpdump in debugging container:

```
docker exec -it app tcpdump -i eth0
```

---

# 59. Debugging Build Issues

## 59.1 Use interactive shell in intermediate stages

```
docker build -t debug --target builder .
docker run -it debug sh
```

---

## 59.2 Inspect build cache

```
docker build --progress=plain .
```

---

## 59.3 Use echo statements inside Dockerfile

Example:

```
RUN echo "Installing dependencies..." && apk add --no-cache git
```

---




# DOCKER IMAGES & CONTAINERS — FULL DEEP THEORY  
(A complete, long, book-style explanation)

---

# 1. DOCKER IMAGES — DEEP THEORY

## 1.1 What Exactly Is a Docker Image?

A Docker image is a **read-only, immutable, layered filesystem** that contains everything needed to run a piece of software:

- Application code  
- Required binaries  
- Language runtimes (Node, Python, Java, Go, etc.)  
- System tools  
- Libraries  
- Environment metadata  
- Default CMD / ENTRYPOINT  

It is a *blueprint* for creating running containers.

A container **is never modified** inside the image.  
All modifications happen in the container’s writable layer.

---

## 1.2 What an Image Is NOT

To understand images better, here’s what they are *not*:

- Not a virtual machine  
- Not a running process  
- Not a full OS  
- Not a “snapshot of RAM”  

A Docker image *only* stores filesystem contents and metadata.

---

## 1.3 Image Structure (The Real Internal Layout)

Every Docker image consists of:

### 1. Layers (Filesystem “diffs”)
Each layer includes:

- Added files  
- Modified files  
- Deleted files (recorded as whiteouts)  

Layers are like Git commits for the filesystem.

Example:

```
Layer 1: Base OS files
Layer 2: Runtime (Python, Node, etc.)
Layer 3: Dependencies installed
Layer 4: Application code
```

### 2. Image Configuration JSON
Contains metadata:

- Environment variables  
- Entrypoint  
- Command  
- Working directory  
- Exposed ports  
- List of layer digests  

### 3. Manifest
Points to config + layers.  
Registry uses the manifest to deliver the correct image.

---

## 1.4 Why Are Images Layered?

This is one of the most powerful aspects of Docker:

### Benefits:
- Faster rebuilds (reuses layers)  
- Smaller downloads (only changed layers)  
- Shared storage (multiple images use same base layer)  
- Efficient distribution  

### Practical example:

You update only a single file →  
Only the top layer changes →  
Pulling the image requires downloading only one new layer.

---

## 1.5 How Images Are Stored on Disk

Docker stores images in a **content-addressable storage** using SHA256 digests.

On Linux:

```
/var/lib/docker/overlay2/
```

Stored items include:

- Layer tarballs  
- Metadata JSON  
- Manifest files  

Nothing is stored by name — only by digest.

---

## 1.6 How Dockerfile Creates Images (Line-by-Line)

Each Dockerfile instruction usually creates **a new layer**.

Example:

```
FROM python:3.11
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

Layer mapping:

| Dockerfile Instruction | Creates Layer? | Description |
|------------------------|----------------|-------------|
| FROM python:3.11       | Yes            | Base layer |
| COPY . .               | Yes            | App files |
| RUN pip install        | Yes            | Dependencies |
| CMD [...]              | No             | Metadata only |

CMD, ENTRYPOINT, ENV, EXPOSE → metadata only.

---

## 1.7 Build Cache — Why Ordering Matters

Docker caches layers.  
If a layer changes, all layers *after it* rebuild.

Bad ordering:

```
COPY . .
RUN pip install
```

Any small source code change → breaks cache → re-runs install.

Good ordering:

```
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
```

---

## 1.8 Image Tagging vs Digest

### Tag (mutable)
Example:

```
nginx:latest
python:3.10
```

Tags can change — **NOT safe for production**.

### Digest (immutable)
Example:

```
nginx@sha256:abc123...
```

Always refers to exact content.  
This is how Kubernetes ensures consistent deployments.

---

## 1.9 How `docker pull` Actually Works

Steps:

1. Client requests manifest from registry  
2. Manifest lists layer digests  
3. Client checks which layers exist locally  
4. Only missing layers are downloaded  
5. Layers extracted and stored in local overlay storage  
6. Image is ready

---

## 1.10 Inspecting and Understanding Images

Useful commands:

```
docker image inspect <image>
docker history <image>
docker pull --quiet
docker save <image> -o file.tar
docker load -i file.tar
```

`docker history` maps image layers to Dockerfile commands.

`docker inspect` shows metadata (env, ports, layers, entrypoint).

---

## 1.11 Image Security (Very Important)

Risks:

- Hidden malicious binaries  
- Exploitable packages  
- Secret leaks  
- Old vulnerable libraries  

Mitigations:

- Use minimal bases (alpine, slim, distroless)  
- Scan with Trivy, Clair  
- Never run as root  
- Avoid copying host environment files  
- Always pin versions  

---

# 2. DOCKER CONTAINERS — DEEP THEORY

## 2.1 What Is a Container?

A container is a **runtime instance of an image** + **an isolated execution environment**.

A container =

- Image (read-only)  
- Writable layer  
- Namespaces (isolation)  
- cgroups (resource limits)  
- runc (runtime)  
- Processes (PID 1, child processes)  

When you run:

```
docker run nginx
```

You get:

- A new filesystem (image layers + writable layer)  
- Network namespace  
- PID namespace  
- Mount namespace  
- UTS namespace  
- IPC namespace  
- Cgroup constraints  

Each container has its own:

- /proc  
- /tmp  
- /etc  
- hostname  
- IP  
- routing table  
- process tree  

---

## 2.2 How a Container Starts (Internal Flow)

When you run:

```
docker run nginx
```

Internally:

1. Docker client → dockerd  
2. dockerd → containerd  
3. containerd → runc (low-level runtime)  
4. runc:
   - Creates namespaces  
   - Applies cgroups  
   - Prepares root filesystem  
   - Mounts overlayfs  
   - Executes PID 1 inside namespace  

The running process inside container is **PID 1**, responsible for handling signals.

---

## 2.3 Container Filesystem — Why Copy-on-Write?

Containers share read-only image layers.

Any write (e.g., creating a file) triggers “Copy-on-Write”:

1. Kernel checks if file exists in lower image layer  
2. Copies file to writable layer  
3. Container modifies writable version  

This makes containers:

- Lightweight  
- Fast  
- Efficient  

---

## 2.4 Container Lifecycle States

A container goes through:

- **Created**  
- **Running**  
- **Paused**  
- **Stopped**  
- **Restarting**  
- **Dead**  

`docker ps -a` shows full state list.

---

## 2.5 What Happens When PID 1 Dies?

PID 1 = main container process.  
If PID 1 exits → entire container stops.

Example:

```
docker run ubuntu ls
```

ls runs → exits → container stops.

---

## 2.6 Networking in Containers

Each container has its own network namespace:

- Virtual Ethernet interface (veth)  
- Private IP  
- Routing table  
- NAT to host  
- DNS resolver  

Containers communicate via:

- Bridge networks  
- Host network  
- Overlay networks (multi-node)  
- Macvlan networks  

---

## 2.7 Entering a Container’s Namespace

You can enter namespaces without using `docker exec`.

Steps:

Find container PID:

```
docker inspect -f '{{.State.Pid}}' <container>
```

Enter its namespaces:

```
nsenter --target <PID> --mount --uts --ipc --net --pid
```

This bypasses docker exec — extremely useful for debugging.

---

## 2.8 Container Resource Control (cgroups)

Cgroups control:

- CPU  
- Memory  
- Disk I/O  
- PIDs  
- Network  

Examples:

```
docker run --cpus=1.5 ubuntu
docker run --memory=300m ubuntu
docker run --pids-limit=100 ubuntu
```

---

## 2.9 Container Logging (Important Theory)

Docker captures STDOUT/STDERR by default.

Logging drivers:

- json-file  
- journald  
- local  
- syslog  
- fluentd  
- awslogs  
- splunk  

Logs can grow indefinitely unless configured with rotation.

---

## 2.10 Volumes vs Writable Layer

Writable layer volatile → disappears when container is removed.

Use volumes for persistence:

- Databases  
- Logs  
- Uploaded files  
- Configs  
- Application state  

Writable layer is good only for:

- Temporary files  
- Scratch space  
- Caches  

---

# 3. CREATING YOUR OWN IMAGES (THEORY + PRINCIPLES)

## 3.1 Dockerfile Best Practices (Theoretical)

- One responsibility per layer  
- Use slim/minimal bases  
- Use .dockerignore  
- Place frequently changing code at bottom  
- Use multi-stage builds  
- Pin dependency versions  
- Run as non-root  
- Use HEALTHCHECK  
- Clean caches to reduce size  
- Minimize number of layers  

---

## 3.2 Ideal Dockerfile Layout

```
FROM python:3.11-slim
WORKDIR /app

# Dependency caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# App code
COPY . .

# Non-root user
RUN adduser --disabled-password appuser
USER appuser

CMD ["python", "main.py"]
```

---

## 3.3 Multi-stage Builds (Deep Theory)

Multi-stage builds allow separating:

- Build tools  
- Runtime environment  

Example:

```
FROM golang:1.21 AS build
WORKDIR /src
COPY . .
RUN go build -o server

FROM alpine
COPY --from=build /src/server /usr/local/bin/server
CMD ["server"]
```

Benefits:

- Smaller image  
- No build tools in final image  
- Better security  

---

## 3.4 Choosing Base Images — Theory

| Type | Example | When to Use |
|------|---------|--------------|
| Full | ubuntu, debian | Development, compatibility |
| Slim | python-slim | Production, fewer libs |
| Alpine | node:alpine | Very small apps |
| Distroless | gcr.io/distroless/base | High-security production |

---

# 4. FULL END-TO-END THEORY OF IMAGE → CONTAINER FLOW

1. **Write Dockerfile**  
2. **Build image**  
   - Docker parses instructions  
   - Creates layers  
   - Stores metadata  
   - Produces an OCI image  
3. **Tag image**  
4. **Push to registry**  
5. **Pull on server**  
6. **containerd prepares rootfs**  
7. **runc launches container**  
8. **Namespaces, cgroups activated**  
9. **Process starts as PID 1**  
10. **Container runs using image’s filesystem**  

Lifecycle ends when:

- PID 1 exits  
- System kills container  
- Orchestration triggers update  

---

# 5. FINAL SHORT SUMMARY (THEORY ONLY)

### Images:
- Immutable, layered, content-addressable filesystem snapshots  
- Built using Dockerfile instructions  
- Stored as blobs + config + manifest  
- Shared efficiently  
- Versioned by digest  

### Containers:
- Runtime instances of images  
- Use namespaces for isolation  
- Use cgroups for resource limits  
- Writable layer on top of image layers  
- Stop when PID 1 exits  

---

