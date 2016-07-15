#!/bin/sh
set -ue

# RSA-decrypt the device key.
openssl pkeyutl -decrypt -inkey master.pem -in device_key_encrypted.dat -out device_key.dat
