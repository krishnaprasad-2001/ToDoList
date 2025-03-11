#!/bin/bash

TASK_DIR="$HOME/.tasks"
mkdir -p "$TASK_DIR"

# Function to add a task
add_task() {
    TASK_NAME=$(rofi -dmenu -p "Task Name:" | tr -d '\n')
    [[ -z "$TASK_NAME" ]] && exit

    TASK_FILE="$TASK_DIR/$TASK_NAME.txt"

    # Check if task exists
    if [[ -f "$TASK_FILE" ]]; then
        notify-send "Task already exists!" "$TASK_NAME"
        exit
    fi

    # Prompt for description
    TASK_DESCRIPTION=$(rofi -dmenu -p "Short Description:" | tr -d '\n')

    # Prompt for details
    TASK_DETAILS=$(rofi -dmenu -p "Task Details (optional):" | tr -d '\n')

    # Set initial status
    echo -e "Status: New\nDescription: $TASK_DESCRIPTION\nDetails: $TASK_DETAILS" > "$TASK_FILE"

    notify-send "Task Added" "$TASK_NAME"
}

# Function to map short status input to full status name
map_status() {
    case "$1" in
        progress) echo "In Progress" ;;
        new) echo "New" ;;
        delay) echo "On Delay" ;;
        fixed) echo "Fixed" ;;
        *) echo "" ;;  # Return empty if invalid input
    esac
}

# Function to show tasks
show_tasks() {
    FILTER_STATUS=$(map_status "$1")  # Convert short status to full name

    [[ ! -d "$TASK_DIR" || -z "$(ls -A "$TASK_DIR")" ]] && notify-send "No tasks available" && exit

    TASK_LIST=""
    for TASK_FILE in "$TASK_DIR"/*.txt; do
        TASK_NAME=$(basename "$TASK_FILE" .txt)
        STATUS=$(grep '^Status:' "$TASK_FILE" | awk -F': ' '{print $2}')

        # Skip tasks if filtering is applied and status doesn't match
        [[ -n "$FILTER_STATUS" && "$STATUS" != "$FILTER_STATUS" ]] && continue

        case "$STATUS" in
            "In Progress") ICON="⏳" ;;
            "New") ICON="📝" ;;
            "On Delay") ICON="⚠" ;;
            "Fixed") ICON="✔" ;;
            "Fixed") ICON="✔" ;;
            *) ICON="❓" ;;
        esac

        TASK_LIST+="$ICON $TASK_NAME\n"
    done

    [[ -z "$TASK_LIST" ]] && notify-send "No matching tasks found" && exit

    # Show task selection
    TASK_NAME=$(echo -e "$TASK_LIST" | rofi -dmenu -p "Tasks:" | cut -d' ' -f2-)
    [[ -z "$TASK_NAME" ]] && exit

    TASK_FILE="$TASK_DIR/$TASK_NAME.txt"

    # Show options for selected task
    CHOICE=$(echo -e "View Details\nChange Status" | rofi -dmenu -p "$TASK_NAME:")
    case "$CHOICE" in
        "View Details")
            TASK_DETAILS=$(cat "$TASK_FILE" | rofi -dmenu -p "Task Details")
            [[ -z "$TASK_DETAILS" ]] && exit
            ;;
        "Change Status")
            NEW_STATUS=$(echo -e "progress\nnew\ndelay\nfixed" | rofi -dmenu -p "Change Status:")
            NEW_STATUS=$(map_status "$NEW_STATUS")
            [[ -n "$NEW_STATUS" ]] && sed -i "s/^Status:.*/Status: $NEW_STATUS/" "$TASK_FILE" && notify-send "Task Updated" "$TASK_NAME -> $NEW_STATUS"
            ;;
    esac
}

clean_list(){
	read -p "Please confirm if you want to clean the list"
	if [[ $REPLY = "y" || $REPLY = "Y" ]]
	then
		rm -rf $TASK_DIR
	else
		echo "Cancelling operation"
	fi
}

# Handle script arguments
case "$1" in
    add) add_task ;;
    show) show_tasks "$2" ;;  # Pass status filter
    clean) clean_list "$2" ;;  # Pass status filter
    *)
        echo -e "Usage: $0 {add|show [status]}\n\nStatus Options:\n  progress - Show 'In Progress' tasks\n  new - Show 'New' tasks\n  delay - Show 'On Delay' tasks\n  fixed - Show 'Fixed' tasks\n  clean - 'Clean list'"
        exit 1
        ;;
esac

