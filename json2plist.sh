#!/bin/sh

# Check if osrm-text-instructions exists, if not clone it
if [ ! -d "./osrm-text-instructions" ]; then
  echo "Submodule not found, cloning directly..."
  git clone https://github.com/Project-OSRM/osrm-text-instructions.git
  # Checkout the specific commit
  cd ./osrm-text-instructions && git checkout badb2192a10b827a53242dd93a70e4a907db41c8 && cd ..
else
  # Try submodule update if we're in a git repo
  git submodule init || echo "Not in a git repo, skipping submodule init"
  git submodule update || echo "Submodule update failed, continuing anyway"
fi

# Ensure the translations directory exists
mkdir -p "./osrm-text-instructions/languages/translations/"
cd "./osrm-text-instructions/languages/translations/" || exit 1

# Rest of the script remains unchanged
for file in ./*; do
    if [ "$file" = "./en.json" ]; then
      LANGUAGE="Base"
    else
      LANGUAGE=$(basename $file)
      LANGUAGE=${LANGUAGE%.json}
    fi

    LANGUAGE_DIR="${BUILT_PRODUCTS_DIR:-../../../OSRMTextInstructions/}/${UNLOCALIZED_RESOURCES_FOLDER_PATH:-}/${LANGUAGE}.lproj"
    mkdir -p "${LANGUAGE_DIR}"
    plutil -convert xml1 "./${file}" -o "${LANGUAGE_DIR}/Instructions.plist"
done

cd - || exit 1
