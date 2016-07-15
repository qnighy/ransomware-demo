#!/bin/sh
set -ue

# Generate an RSA private key. Only the server has it.
openssl genpkey -out server/master.pem -algorithm rsa -pkeyopt rsa_keygen_bits:4096

# Generate the corresponding public key. It is embedded to the client.
openssl pkey -in server/master.pem -out client/master.pem -pubout
