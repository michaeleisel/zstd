#!/usr/bin/env bash

set -e

rm programs/*.a || true # `make clean` doesn't seem to catch this one, so delete manually

# Real phone
make clean
rm lib/decompress/*.o lib/common/*.o || true
CUSTOM_FLAGS="-c -Os -target arm64-apple-ios14.0 -isysroot `xcode-select -p`/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk"
V=1 CFLAGS="$CUSTOM_FLAGS" LDFLAGS="$CUSTOM_FLAGS" make -C programs zstd-decompress
mv programs/libzstd-decompress.a libzstd-decompress-iphone.a

# Simulator
make clean
rm lib/decompress/*.o lib/common/*.o || true
CUSTOM_FLAGS="-c -Os -target arm64-apple-ios14.0-simulator -isysroot `xcode-select -p`/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk"
V=1 CFLAGS="$CUSTOM_FLAGS" LDFLAGS="$CUSTOM_FLAGS" make -C programs zstd-decompress
mv programs/libzstd-decompress.a libzstd-decompress-simulator.a

HEADERS_DIR=/tmp/zstd-headers
rm -r $HEADERS_DIR || true
mkdir $HEADERS_DIR
cp lib/zstd.h $HEADERS_DIR

rm -r libzstd.xcframework || true

xcodebuild -create-xcframework -library libzstd-decompress-simulator.a -headers $HEADERS_DIR -library libzstd-decompress-iphone.a -headers $HEADERS_DIR -output libzstd.xcframework
