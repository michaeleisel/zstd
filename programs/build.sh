make clean ; V=1 CFLAGS="-c -Os -target arm64-apple-ios14.0 -isysroot `xcode-select -p`/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk" LDFLAGS="$CFLAGS" make zstd-decompress
