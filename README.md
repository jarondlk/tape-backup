# tape-backup
The tape-backup system originally for my lab in Tohoku University

## Features

1. **Backup Modes**:
    
    - **Full Backup**: Archives the entire folder, disregarding any previous backups.
        
    - **Incremental Backup**: Archives only files that have changed since the last backup.
        
2. **Tape Device Selection**: Optionally specify the tape device (default: `/dev/st0`).
    
3. **Logging**: Detailed logs are stored in the same directory as the script for easy access.
    
4. **Snapshot Management**: Stores snapshots for incremental backups.
    
5. **Error Handling**: Provides clear error messages for common issues, such as missing folders or device errors.

---

## Script Location

Place the script (`tape_backup.sh`) in any directory accessible to the user. Ensure the script has executable permissions.

---

## Usage

### Command Format

```
tape_backup.sh <folder_to_backup> <mode> [tape_device]
```

### Parameters

1. `**<folder_to_backup>**` (Mandatory):
    
    - The path to the folder you want to back up.
        
    - Example: `/mnt/hdd/BACKUP`
        
2. `**<mode>**` (Mandatory):
    
    - `new`: For a full backup.
        
    - Leave blank or use any other value for an incremental backup.
        
3. `**[tape_device]**` (Optional):
    
    - The path to the tape device.
        
    - Default: `/dev/st0`
        
    - Example: `/dev/nst0`
        

### Examples

- **Full Backup**:
    
    ```
    ./tape_backup.sh /mnt/hdd/BACKUP new
    ```
    
- **Incremental Backup**:
    
    ```
    ./tape_backup.sh /mnt/hdd/BACKUP
    ```
    
- **Full Backup to a Different Tape Device**:
    
    ```
    ./tape_backup.sh /mnt/hdd/BACKUP new /dev/nst0
    ```
    

---

## Script Behavior

### Logging

- Logs are stored in the `tape_backup_logs` folder within the same directory as the script.
    
- Log filenames include timestamps, e.g., `backup_2025-01-14_17-00-11.log`.
    

### Snapshot Files

- Incremental backups use snapshot files stored in the `tape_backup_snapshots` folder within the same directory as the script.
    
- Snapshot filenames are based on the folder name being backed up, e.g., `BACKUP_snapshot.snar`.
    

### Tape Device Default

- If no tape device is specified, the script defaults to `/dev/st0`.
    

---

## Script Workflow

1. Parse user inputs.
    
2. Validate the folder to back up.
    
3. Determine the backup mode (full or incremental):
    
    - **Full Backup**:
        
        - Clears any existing snapshot file for the folder.
            
        - Archives the entire folder to the specified tape device.
            
    - **Incremental Backup**:
        
        - Uses a snapshot file to archive only changed files.
            
4. Create necessary directories for logs and snapshots if they don’t exist.
    
5. Write operation details to a log file.
    
6. Display operation status (success or failure).
    

---

## Prerequisites

1. **Permissions**:
    
    - Ensure the user has the necessary permissions to access the tape device and read the folder to be backed up.
        
2. **Software**:
    
    - `tar` command-line utility (available in most Unix-like systems).
        
3. **Executable Script**:
    
    - Make the script executable:
        
        ```
        chmod +x tape_backup.sh
        ```
        

---

## Error Handling

The script handles the following errors:

1. **Missing Folder**:
    
    - Error: “Folder '' does not exist.”
        
    - Resolution: Provide a valid path to an existing folder.
        
2. **Permission Denied**:
    
    - Error when accessing the tape device or creating logs/snapshots.
        
    - Resolution: Run the script with `sudo` if required.
        
3. **Tape Device Issues**:
    
    - Error when the specified tape device is unavailable.
        
    - Resolution: Ensure the correct tape device path is provided and accessible.
        
4. **Backup Failure**:
    
    - Error: “Backup failed. Check the log file for details.”
        
    - Resolution: Inspect the log file for detailed error information.
        

---

## Additional Notes

- To monitor backup progress, view the log file in real-time:
    
    ```
    tail -f ./tape_backup_logs/<log_filename>
    ```
    
- Use the `mt` command to manage the tape drive manually if needed (e.g., rewinding the tape):
    
    ```
    sudo mt -f /dev/st0 rewind
    ```
    
- Ensure sufficient space on the tape for the backup operation.
    

---

## Maintenance and Updates

- Periodically review and clean up old log files and snapshots to save space.
    
- Test the script periodically to ensure compatibility with your system and tape drive.
