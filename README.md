# DaisyVSCodeTemplate

This is a template repo for DaisySeed development using VSCode. To create a private repo using this repo as a template:

```
gh repo create {new_repo_name} --private --clone --template davidirvine/DaisyVSCodeTemplate
```
## Values You'll Want to Change

When creating a nekw project from this template you'll need to change the following values:

- `CMakeLists.txt:16` project name
- `src/CMakeLists.txt:4` TARGET value

## Thirdparty Dependencies

External dependencies like `libDaisy` and `DaisySP` are managed using CMake `external_project` and will be downloaded and built as part of the build process. 

These repos are cloned into the `thirdparty` directory. `doctest` has been copied along with it's license to `thirdparty/doctest`.


## Build Setup
```
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug ..
```

## Building
```
make
```

## Device Programming

You can specify where you want your program to reside on the device by setting `EXECUTABLE_STORAGE_LOCATION` in the root `CMakeLists.txt` file. Options are: `BOOT_FLASH`, `BOOT_SRAM`, `BOOT_QSPI`.

Both `BOOT_SRAM` and `BOOT_QSPI` require the Daisy bootloader to be installed. In these cases use `make program-bootloader` to install the bootloader before installing your program. See `cmake/compiler_linker_options.cmake`.

To program the device using `dfu-util` with a USB connection to the DaisySeed use:

```
make program-dfu
```

To program the device for debugging via a JTAG device using `openOCD` use the following. Currently this is only supported when `EXECUTABLE_STORAGE_LOCATION` equals `BOOT_FLASH`.

```
make program-ocd
```

## Source Level Debugging
A launch configuration is provided which enables source level debugging using a JTAG debug probe.
