# Ransomware demo

This is a simple demo of ransomware.

## Disclaimer

- Be careful when trying this demo. This demo is provided without warranty of any kind.
- This demo is intended to help understanding how cryptography is used in ransomware. I don't expect it to be used in ransomwares "in practice". Creating ransomwares would be illegal. Moreover, this demo is not "practical", since it doesn't provide a way to ensure file erasure nor a way to pay and communicate keys.

## How to try

```
~$ git clone https://github.com/qnighy/ransomware-demo.git
~$ cd ransomware-demo
```

### Create a master key pair

First, create a master key pair.

```
~/ransomware-demo$ ./genmaster.sh
```

An RSA key pair `server/master.pem`/`client/master.pem` is created and it serves as a master key pair.

- **The private key** `server/master.pem` is kept secret.
- **The public key** `client/master.pem` is embedded in the ransomware.

### Run ransomware

Suppose the ransomware is distributed to victims and run. Let's simulate that.

```
~/ransomware-demo$ cd client
~/ransomware-demo/client$ find documents
documents
documents/lipsum.txt
documents/hello.txt
~/ransomware-demo/client$ cat documents/hello.txt
Hello, world!
~/ransomware-demo/client$ ./encrypt.sh
~/ransomware-demo/client$ find documents
documents
documents/hello.txt.enc
documents/hello.txt.iv
documents/hello.txt.sha256
documents/lipsum.txt.enc
documents/lipsum.txt.iv
documents/lipsum.txt.sha256
```

Here three things happen:

- A device key is created.
- The files are encrypted using the device key.
- The device key is encrypted using the master key.

### Pay something and recover the device key

To decrypt the files, you should pay for someone and have your device key recovered. Let's simulate that.

```
~/ransomware-demo/client$ ./decrypt.sh
device_key.dat not found. First pay for us!
~/ransomware-demo/client$ cp device_key_encrypted.dat ../server/
~/ransomware-demo/client$ mv ../server/
~/ransomware-demo/server$ ./decrypt-key.sh
~/ransomware-demo/server$ cp device_key.dat ../client/
~/ransomware-demo/server$ mv ../client/
~/ransomware-demo/client$ ./decrypt.sh
```

### Decrypt files

Now you can decrypt the files.

```
~/ransomware-demo/client$ ./decrypt.sh
~/ransomware-demo/client$ find documents
documents
documents/lipsum.txt
documents/hello.txt
~/ransomware-demo/client$ cat documents/hello.txt
Hello, world!
```
