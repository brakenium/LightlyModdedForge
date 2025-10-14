#!/bin/bash

# Read the CSV file and add each mod using packwiz
while IFS=',' read -r name url version; do
    # Skip the header line if it exists
    if [[ "$name" == "name" ]] || [[ -z "$name" ]]; then
        continue
    fi

    echo "Adding mod: $name (version $version)"

    # Extract the project ID from the Modrinth URL
    # URLs are in format: https://modrinth.com/mod/{project_id}
    if [[ "$url" =~ modrinth\.com/mod/([^/]+) ]]; then
        project_id="${BASH_REMATCH[1]}"
        echo "  Project ID: $project_id"

        # Add the mod using packwiz with the project ID
        packwiz modrinth add -y --project-id "$project_id" --version-filename "$version"

        if [[ $? -eq 0 ]]; then
            echo "  ✓ Successfully added $name"
        else
            echo -e "  \033[0;31m✗ Failed to add $name\033[0m"
        fi
    else
        echo "  ⚠ Skipping $name - not a Modrinth URL: $url"
    fi

    echo ""
done <modlist.csv

echo "Finished adding mods!"
