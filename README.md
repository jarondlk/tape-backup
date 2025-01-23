# Tape Backup Script Documentation

## Overview
This script facilitates backups to a tape device. It supports full backups, incremental backups, and dry-run operations for testing without writing to the tape. Logs and snapshots are maintained to track operations and incremental backups.

## Usage
```bash
tape_backup.sh <folder_to_backup> <mode> [tape_device]
```

### Parameters
- `<folder_to_backup>`: **Mandatory**. The folder to back up.
- `<mode>`: **Mandatory**. Specifies the type of backup:
  - `full`: Perform a full backup.
  - `inc`: Perform an incremental backup (uses snapshots).
  - `dry`: Perform a dry run (testing without writing to the tape).
- `[tape_device]`: **Optional**. The tape device to use. Defaults to `/dev/st0`.

### Examples
- Full backup:
  ```bash
  tape_backup.sh /path/to/folder full
  ```
- Incremental backup to a specific tape device:
  ```bash
  tape_backup.sh /path/to/folder inc /dev/nst0
  ```
- Dry run:
  ```bash
  tape_backup.sh /path/to/folder dry
  ```

## Script Details

### Directory Setup
- **Logs**: Stored in `tape_backup_logs` within the script's directory.
- **Snapshots**: Stored in `tape_backup_snapshots` within the script's directory.

### Key Variables
- `DEFAULT_TAPE_DEVICE`: Default tape device (`/dev/st0`).
- `SCRIPT_DIR`: Directory of the script.
- `LOG_DIR`: Directory for log files.
- `SNAPSHOT_DIR`: Directory for snapshot files.
- `DATE`: Current date and time for unique log file naming.

### Functional Description
1. **Argument Validation**:
   - Ensures the required folder exists and validates the mode parameter.
   - Provides usage instructions if parameters are missing or invalid.

2. **Mode-Based Operations**:
   - **Full Backup (`full`)**:
     - Backs up the specified folder to the tape device.
     - Removes any existing snapshot file.
   - **Incremental Backup (`inc`)**:
     - Performs a backup that only includes changes since the last backup using a snapshot file.
   - **Dry Run (`dry`)**:
     - Simulates a backup without writing to the tape, using `/dev/null`.

3. **Error Handling**:
   - Logs errors and exits with a failure status if any issues occur during execution.

4. **Logging**:
   - All operations are logged in `tape_backup_logs/backup_<date>.log`.

### Exit Status
- `0`: Success.
- `1`: Failure due to invalid arguments or backup errors.

## Files and Directories
- **Log Directory**: `tape_backup_logs`
- **Snapshot Directory**: `tape_backup_snapshots`
- **Log File**: `backup_<date>.log` (e.g., `backup_2025-01-22_16-30-45.log`)
- **Snapshot File**: `<folder_name>_snapshot.snar`

## Notes
- Incremental backups require a snapshot file to track changes. This file is automatically managed by the script.
- Ensure the specified tape device is correctly connected and configured before running the script.

## Troubleshooting
- **Backup Failed**:
  - Check the log file for detailed error messages.
  - Verify the tape device is operational and accessible.
- **Invalid Folder**:
  - Confirm the folder path exists and is accessible.

## Author
Jaronchai Dilokkalayakul
2025 Tohoku University, Information Biology Lab
