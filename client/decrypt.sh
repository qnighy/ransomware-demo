#!/bin/sh
set -ue

if [ ! -f device_key.dat ]; then
  echo "device_key.dat not found. First pay for us!" >&2
  exit 1
fi

device_key=$(cat device_key.dat)

# Decrypt each file.
for filename_enc in documents/*.enc; do
  filename=$(echo $filename_enc | sed -e 's/\.enc$//')

  # Decrypt the file.
  iv=$(cat $filename.iv)
  openssl enc -aes-256-cbc -d -K $device_key -iv $iv -in $filename.enc -out $filename

  # Calculate hash for the file.
  if openssl sha256 -r $filename | diff -q - $filename.sha256; then
    # Remove the encrypted file and related files.
    rm $filename.sha256 $filename.iv $filename.enc
  else
    echo "$filename: digest mismatch" >&2
  fi
done
