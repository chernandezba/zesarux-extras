#!/bin/bash

# Las librerias que usa el binario se pueden ver con comando: otool -L zesarux

echo "Installing ZEsarUX SSL enabled version..."

cp zesarux.ssl /Applications/zesarux.app/Contents/MacOS/zesarux
chmod 755 /Applications/zesarux.app/Contents/MacOS/zesarux


mkdir -p /usr/local/opt/openssl/lib/
cp libssl.1.0.0.dylib libcrypto.1.0.0.dylib /usr/local/opt/openssl/lib/

echo "Installation finished"
