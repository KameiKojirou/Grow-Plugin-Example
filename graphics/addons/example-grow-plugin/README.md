Here’s a sample README.md you can drop in your project root:
markdown# Example Grow Plugin for Godot

This repo contains a Go-powered GDExtension plugin for Godot.  
You can cross-compile it to Linux, Windows and Android using Go+CGO + Zig (or the Android NDK).

---

## Prerequisites

-   Go 1.20+ (with CGO enabled)
-   Zig (for Linux/Windows cross-C compiler)
-   Android NDK r23.2.8568313
-   bash, make (optional)

## Environment Setup

Add to your `~/.bashrc` or `~/.profile`:

```bash
# Android SDK & NDK
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/23.2.8568313"
export ANDROID_API=21

# (Optional) make NDK clang visible
export PATH="$PATH:$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin"
```

Then:

```bash
source ~/.bashrc
```

Verify:

```bash
echo $ANDROID_NDK_HOME    # → /home/you/Android/Sdk/ndk/23.2.8568313
echo $ANDROID_API        # → 21
```

---

## Build Commands

All builds use:

go build -v -buildmode=c-shared -o <output> .
text
and emit:

-   `<output>` (`.so` or `.dll`)
-   `<output>.h`

### Linux / amd64

```bash
CGO_ENABLED=1 \
GOOS=linux GOARCH=amd64 \
CC="zig cc -target x86_64-linux-gnu" \
CXX="zig c++ -target x86_64-linux-gnu" \
go build -v -o linux_amd64.so -buildmode=c-shared .
Windows / amd64bashCGO_ENABLED=1 \
GOOS=windows GOARCH=amd64 \
CC="zig cc -target x86_64-windows-gnu" \
CXX="zig c++ -target x86_64-windows-gnu" \
CGO_CFLAGS="-Wno-macro-redefined -D__declspec(x)= " \
CGO_CXXFLAGS="-Wno-macro-redefined -D__declspec(x)= " \
go build -v -o windows_amd64.dll -buildmode=c-shared .

To target MSVC instead of MinGW, use -target x86_64-windows-msvc in CC & CXX.

Android / arm64bashCGO_ENABLED=1 \
GOOS=android GOARCH=arm64 \
CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android${ANDROID_API}-clang" \
CXX="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android${ANDROID_API}-clang++" \
go build -v -o android_arm64.so -buildmode=c-shared .

We skip 32-bit GOARCH=arm due to a known overflow in the graphics.gd module.
To add ARMv7, you’ll need to vendor & patch that constant to int64.

Integrating with Godot

Place your built libraries in addons/<your-plugin>/bin/<platform>/:

textaddons/example-grow-plugin/
└── bin/
    ├── linux.x86_64/linux_amd64.so
    ├── windows.x86_64/windows_amd64.dll
    └── android.arm64/android_arm64.so



Edit your .gdextension manifest:

ini[configuration]
entry_symbol        = "loadExtension"
compatibility_minimum = "4.4"

[libraries]
linux.x86_64    = "bin/linux.x86_64/linux_amd64.so"
windows.x86_64  = "bin/windows.x86_64/windows_amd64.dll"
android.arm64   = "bin/android.arm64/android_arm64.so"



When you export for each platform, Godot will pick the correct library.


Makefile Example
Optional Makefile to automate:
makefileANDROID_NDK   ?= $(HOME)/Android/Sdk/ndk/23.2.8568313
ANDROID_API   ?= 21

.PHONY: all linux windows android

all: linux windows android

linux:
	CGO_ENABLED=1 \
	GOOS=linux GOARCH=amd64 \
	CC="zig cc -target x86_64-linux-gnu" \
	CXX="zig c++ -target x86_64-linux-gnu" \
	go build -v -o bin/linux.x86_64/linux_amd64.so \
		-buildmode=c-shared .

windows:
	CGO_ENABLED=1 \
	GOOS=windows GOARCH=amd64 \
	CC="zig cc -target x86_64-windows-gnu" \
	CXX="zig c++ -target x86_64-windows-gnu" \
	CG

android:
	CGO_ENABLED=1 \
	GOOS=android GOARCH=arm64 \
	CC="$(ANDROID_NDK)/toolchains/llvm/prebuilt/linux-x86_64/bin/\
aarch64-linux-android$(ANDROID_API)-clang" \
	CXX="$(ANDROID_NDK)/toolchains/llvm/prebuilt/linux-x86_64/bin/\
aarch64-linux-android$(ANDROID_API)-clang++" \
	go build -v -o bin/android.arm64/android_arm64.so \
		-buildmode=c-shared .
Run:
bashmake all
```
