#!/bin/bash

show_help() {
echo "Usage: $0 [NUMBER_OF_USERS | -d]"
    echo ""
    echo "Automates the creation or deletion of OSM projects and users."
    echo ""
    echo "Options:"
    echo "  -ca, --create-all NUMBER   Create projects and users from number 1 to the given number"
    echo "  -da, --delete-all          Delete users and projects sequentially"
    echo "  -da, --delete-all NUMBER   Forcefully delele users and projects until the given number."
    echo "  -d, --delete NUMBER        Delete a specific user and project (needs USER_NUMBER)"
    echo "  -c, --create NUMBER        Create/Recreate a specific user and project."
    echo "  -h, --help                 Show this help message and exit."
    echo ""
	echo "  Usernames are: user1, user2, user3..."
	echo "  Passwords are password1, password2, password3..."
	echo "  Projects are project1, project2, project3..."
	echo ""
    echo "Examples:"
    echo "  $0 -ca 10    Creates project1...project10 and user1...user10."
    echo "  $0 -da       Deletes project1, user1, project2, user2... until it finds one that is missing"
    echo "  $0 -d 3      Deletes project3 and user3 only."
    echo "  $0 -c 3      Creates project3 and user3."
}

# Check for help flags or empty arguments
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ -z "$1" ]]; then
    show_help
    exit 0

# --- Create Specific Mode (-c or --create-specific) ---
elif [[ "$1" == "-c" ]] || [[ "$1" == "--create" ]]; then
    SPEC_ID=$2
    if ! [[ "$SPEC_ID" =~ ^[0-9]+$ ]]; then
        echo "Error: $1 requires a numeric ID (e.g., $0 $1 5)."
        exit 1
    fi
    
    ROLE="project_admin"
    PROJECT="project$SPEC_ID"
    USER="user$SPEC_ID"
    USER_PASS="password$SPEC_ID" # OSM forces you to change your password on first login

    echo ">> Recreating specific set: $USER and $PROJECT..."
    
    osm project-create "$PROJECT" > /dev/null 2>&1 && echo "   [OK] Project $PROJECT created." || echo "   [!] Project $PROJECT already exists."
    
    if osm user-create "$USER" --password "$USER_PASS" --project-role-mappings "$PROJECT,$ROLE" > /dev/null 2>&1; then
        echo "   [OK] User $USER created and assigned to $PROJECT."
    else
        echo "   [!] Failed to create $USER (it may already exist)."
    fi
    exit 0

# --- Delete Specific Mode ---
elif [[ "$1" == "-d" ]] || [[ "$1" == "--delete" ]]; then
    SPECIFIC_ID=$2
    if ! [[ "$SPECIFIC_ID" =~ ^[0-9]+$ ]]; then
        echo "Error: $1 requires a numeric ID (e.g., $0 $1 1)."
        exit 1
    fi
    
    USER="user$SPECIFIC_ID"
    PROJECT="project$SPECIFIC_ID"

    echo ">> Deleting specific set: $USER and $PROJECT..."
    osm user-delete "$USER" > /dev/null 2>&1 && echo "   [OK] User $USER deleted." || echo "   [!] User $USER not found."
    osm project-delete "$PROJECT" > /dev/null 2>&1 && echo "   [OK] Project $PROJECT deleted." || echo "   [!] Project $PROJECT not found."
    exit 0

# --- Delete All Mode ---
elif [[ "$1" == "-da" ]] || [[ "$1" == "--delete-all" ]]; then
    echo "### Starting lab Cleanup ###"
    echo "--------------------------------------------------------"
    
    NUM_USERS=$2
    if [[ -n "$2" ]] && ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: Argument must be a positive integer."
        show_help
        exit 1
    elif [[ -n "$NUM_USERS" ]] && [[ "$NUM_USERS" =~ ^[0-9]+$ ]]; then
        echo "### Force Deleting up to Set $NUM_USERS ###"
        
        for i in $(seq 1 $NUM_USERS); do
            USER="user$i"
            PROJECT="project$i"
            echo ">> Deleting Set $i..."
            osm user-delete "$USER" > /dev/null 2>&1
            osm project-delete "$PROJECT" > /dev/null 2>&1
        done
    else
        echo "### Starting Sequential Cleanup (stopping at first gap) ###"
        i=1
        while true; do
            USER="user$i"
            PROJECT="project$i"
            if ! osm user-show "$USER" > /dev/null 2>&1; then
                echo ">> No more users found. Cleanup finished."
                break
            fi
            echo ">> Deleting Set $i..."
            osm user-delete "$USER" > /dev/null 2>&1
            osm project-delete "$PROJECT" > /dev/null 2>&1
            ((i++))
        done
    fi
    echo "--------------------------------------------------------"
    echo "Current user list:"
    osm user-list

    echo "Current project list:"
    osm project-list
    exit 0

# --- Bulk Create All Mode (-ca) ---
elif [[ "$1" == "-ca" ]] || [[ "$1" == "--create-all" ]]; then
    NUM_USERS=$2
    
    # Validate that the second argument is a positive integer
    if ! [[ "$NUM_USERS" =~ ^[0-9]+$ ]]; then
        echo "Error: -ca requires a numeric limit (e.g., $0 -ca 10)."
        exit 1
    fi

    ROLE="project_admin"

    echo "### Starting Lab Creation for $NUM_USERS Environments ###"
    echo "--------------------------------------------------------"

    for i in $(seq 1 "$NUM_USERS"); do
        PROJECT="project$i"
        USER="user$i"
        # Dynamic password per user as per your snippet
        USER_PASS="RDSV_OSM_lab$i" 

        echo ">> Processing Set $i..."

        # 1. Create the Project
        if osm project-create "$PROJECT" > /dev/null 2>&1; then
            echo "   [OK] Created $PROJECT"
        else
            echo "   [!] $PROJECT already exists, skipping creation."
        fi

        # 2. Create the User and assign to the Project
        if osm user-create "$USER" --password "$USER_PASS" --projects "$PROJECT" --project-role-mappings "$PROJECT,$ROLE" > /dev/null 2>&1; then
            echo "   [OK] Created $USER (Pass: $USER_PASS) assigned to $PROJECT"
        else
            echo "   [!] Failed to create $USER (it may already exist)."
        fi
    done
    
    echo "--------------------------------------------------------"
    echo "Current user list:"
        osm user-list

        echo "Current project list:"
        osm project-list
    exit 0
else
    show_help
    exit 0
fi

echo "--------------------------------------------------------"
echo "### Setup Complete: $NUM_USERS users/projects processed. ###"
