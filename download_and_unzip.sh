#!/bin/bash

# Check if the shareable link is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <Google Drive shareable link>"
    exit 1
fi

# Extract the file ID from the shareable link
FILEID=$(echo "$1" | sed -rn 's|.*?/d/([^/]+).*|\1|p')

# Check if the file ID was extracted successfully
if [ -z "$FILEID" ]; then
    echo "Error: Unable to extract file ID from the provided link."
    exit 1
fi

# Download the file
FILENAME="downloaded_file.zip"
echo "Downloading file with ID: $FILEID"
CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate \
'https://docs.google.com/uc?export=download&id='$FILEID -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+).*/\1/p')

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$FILEID" -O $FILENAME && rm -rf /tmp/cookies.txt

# Check if the download was successful
if [ ! -f "$FILENAME" ]; then
    echo "Error: File download failed."
    exit 1
fi

# Unzip the file
echo "Unzipping file: $FILENAME"
unzip $FILENAME

# Clean up
rm $FILENAME
echo "Download and unzip complete."
