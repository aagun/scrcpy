#!/usr/bin/env bash
set -e

BUILDDIR=build-auto
PREBUILT_SERVER_URL=https://github.com/Genymobile/scrcpy/releases/download/v2.4/scrcpy-server-v2.4
PREBUILT_SERVER_SHA256=93c272b7438605c055e127f7444064ed78fa9ca49f81156777fd201e79ce7ba3

echo "[scrcpy] Downloading prebuilt server..."
wget "$PREBUILT_SERVER_URL" -qO scrcpy-server
echo "[scrcpy] Verifying prebuilt server..."
echo "$PREBUILT_SERVER_SHA256  scrcpy-server" | sha256sum --check

echo "[scrcpy] Building client..."
meson setup "$BUILDDIR" --buildtype=release --strip -Db_lto=true \
    -Dprebuilt_server=scrcpy-server
cd "$BUILDDIR"
ninja

rm -rf meson-* compile_commands.json build.ninja .hgignore .gitignore

PLATFORM_TOOLS_LINUX_URL="https://dl.google.com/android/repository/platform-tools-latest-linux.zip"
PLATFORM_TOOLS="platform-tools"

echo "\n[platform-tools] Downloading platform-tools..."
wget $PLATFORM_TOOLS_LINUX_URL -qO $PLATFORM_TOOLS.zip

echo "[platform-tools] Extracting file..."
unzip -p $PLATFORM_TOOLS.zip ./$PLATFORM_TOOLS/adb > adb
rm $PLATFORM_TOOLS.zip

cd ..
cp ./run ./$BUILDDIR

cd ..
cp -r scrcpy/$BUILDDIR ./
rm -rf scrcpy

#echo "[scrcpy] Installing (sudo)..."
#sudo ninja install
