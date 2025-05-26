# Linux-SYNC-script-and-service

A robust file synchronization solution for Linux that automatically detects local file changes and synchronizes them to a remote server using rsync over SSH.

## Overview

This project provides a complete solution for real-time file synchronization between a local directory and a remote server. It consists of:

1. A Bash script that monitors local directory changes using `inotify` and syncs them to a remote server via `rsync`
2. A systemd service definition for running the sync script as a background service
3. A utility script for restarting and monitoring the sync service

## Components

### 1. rsync.sh

The main script that:
- Checks for and installs required dependencies (`inotify-tools` and `sshpass`)
- Continuously monitors a local directory for file changes (create, modify, delete)
- Synchronizes changes to the remote server using rsync when changes are detected
- Uses SSH for secure file transfer

**Configuration variables:**
- `REMOTE`: SSH connection string to the remote server (e.g., "root@192.168.1.1")
- `REMOTE_PATH`: Target directory path on the remote server
- `LOCAL_PATH`: Local directory to monitor (defaults to current directory)
- `PASSWORD`: SSH password for the remote server

### 2. sync-watch.service

A systemd service definition that:
- Runs the sync script as a background service
- Automatically starts after the network is available
- Restarts the service if it fails
- Sets the appropriate working directory and environment

### 3. restartSyncServiceDev.sh

A utility script that:
- Reloads the systemd daemon
- Restarts the sync service
- Shows real-time service logs using journalctl
- Displays the location of the service file

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/Linux-SYNC-script-and-service.git
   cd Linux-SYNC-script-and-service
   ```

2. Modify the configuration variables in `rsync.sh`:
   ```bash
   REMOTE="your-username@your-server-ip"
   REMOTE_PATH="/path/on/remote/server"
   LOCAL_PATH="/path/to/local/directory"  # Change from "." if needed
   PASSWORD="your-secure-password"
   ```

3. Update the paths in `sync-watch.service` to match your actual script location:
   ```
   ExecStart=/path/to/your/rsync.sh
   WorkingDirectory=/path/to/your/directory/
   ```

4. Make the scripts executable:
   ```bash
   chmod +x rsync.sh restartSyncServiceDev.sh
   ```

5. Install the systemd service:
   ```bash
   sudo cp sync-watch.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable sync-watch.service
   sudo systemctl start sync-watch.service
   ```

## Usage

### Manual Usage

To run the sync script manually:
```bash
./rsync.sh
```

### Service Management

To start/stop/restart the service:
```bash
sudo systemctl start sync-watch.service
sudo systemctl stop sync-watch.service
sudo systemctl restart sync-watch.service
```

To check service status:
```bash
sudo systemctl status sync-watch.service
```

For service logs:
```bash
sudo journalctl -u sync-watch.service
```

To use the restart script (also shows logs):
```bash
./restartSyncServiceDev.sh
```

## Security Considerations

1. **Password Security**: The script currently stores the SSH password in plain text. For better security, consider:
   - Using SSH keys instead of passwords
   - Using environment variables for sensitive information
   - Implementing a secure password manager

2. **Root Access**: The example uses root access to the remote server. It's recommended to:
   - Use a dedicated user with limited permissions
   - Apply the principle of least privilege

## Dependencies

- inotify-tools (automatically installed by the script if missing)
- sshpass (automatically installed by the script if missing)
- rsync (usually pre-installed on most Linux distributions)

## Troubleshooting

1. **Service fails to start**:
   - Check logs: `sudo journalctl -u sync-watch.service`
   - Verify paths in the service file
   - Ensure scripts are executable

2. **Sync not working**:
   - Verify network connectivity to the remote server
   - Check SSH credentials
   - Ensure proper permissions on local and remote directories

3. **High CPU usage**:
   - If watching large directories with many changes, consider adding exclusion patterns

## License

[Your License Here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.