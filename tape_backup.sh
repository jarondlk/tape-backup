#!/bin/bash

# Tape Backup Script
# Usage: tape_backup.sh <folder_to_backup> <mode> [tape_device]
# <folder_to_backup> - The folder to back up (mandatory)
# <mode> - "full" for full backup, "inc" for incremental backup, "dry" for testing without writing to tape
# [tape_device] - The tape device (optional, defaults to /dev/st0)

DEFAULT_TAPE_DEVICE="/dev/st0"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"  # Get the script's directory
LOG_DIR="$SCRIPT_DIR/tape_backup_logs"
SNAPSHOT_DIR="$SCRIPT_DIR/tape_backup_snapshots"
DATE=$(date '+%Y-%m-%d_%H-%M-%S')

mkdir -p "$LOG_DIR"
mkdir -p "$SNAPSHOT_DIR"

LOG_FILE="$LOG_DIR/backup_$DATE.log"

usage() {
    echo "Usage: $0 <folder_to_backup> <mode> [tape_device]"
    echo "  <folder_to_backup>: Folder to back up (mandatory)"
    echo "  <mode>: 'new' for full backup, 'incremental' for incremental backup, 'dry-run' for testing without writing to tape"
    echo "  [tape_device]: Optional tape device (default: $DEFAULT_TAPE_DEVICE)"
    exit 1
}

if [ "$#" -lt 1 ]; then
    echo "Error: Missing arguments"
    usage
fi

FOLDER_TO_BACKUP="$1"
MODE="${2:-incremental}"
TAPE_DEVICE="${3:-$DEFAULT_TAPE_DEVICE}"

if [ ! -d "$FOLDER_TO_BACKUP" ]; then
    echo "Error: Folder '$FOLDER_TO_BACKUP' does not exist."
    exit 1
fi

SNAPSHOT_FILE="$SNAPSHOT_DIR/$(basename "$FOLDER_TO_BACKUP")_snapshot.snar"

if [ "$MODE" == "full" ]; then
    echo "Performing full backup of '$FOLDER_TO_BACKUP' to device '$TAPE_DEVICE'..." | tee -a "$LOG_FILE"
    tar -cvf "$TAPE_DEVICE" "$FOLDER_TO_BACKUP" >"$LOG_FILE" 2>&1
    # Clear snapshot file for new backup
    rm -f "$SNAPSHOT_FILE"
elif [ "$MODE" == "inc" ]; then
    echo "Performing incremental backup of '$FOLDER_TO_BACKUP' to device '$TAPE_DEVICE'..." | tee -a "$LOG_FILE"
    tar -cvf "$TAPE_DEVICE" --listed-incremental="$SNAPSHOT_FILE" "$FOLDER_TO_BACKUP" >"$LOG_FILE" 2>&1
elif [ "$MODE" == "dry" ]; then
    echo "Performing dry run for '$FOLDER_TO_BACKUP'..." | tee -a "$LOG_FILE"
    tar -cvf /dev/null "$FOLDER_TO_BACKUP" >"$LOG_FILE" 2>&1
else
    echo "Error: Invalid mode '$MODE'. Use 'new', 'incremental', or 'dry-run'." | tee -a "$LOG_FILE"
    usage
fi

if [ "$?" -eq 0 ]; then
    echo "Backup completed successfully." | tee -a "$LOG_FILE"
else
    echo "Backup failed. Check the log file for details: $LOG_FILE" | tee -a "$LOG_FILE"
    exit 1
fi

# End of script
