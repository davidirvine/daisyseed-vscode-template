# daisyseed-vscode-template

This is a template repo for C++ development using VSCode targeting the Daisy Seed hardware platform. 

I created this template for myself while learning about Daisy Seed development. Kind of as a way of taking notes as I worked my way through the ElectroSmith examples. I've found it useful and maybe others will too. 

I struggle with getting a JTAG probe to work reliably with `openocd`.

What I was looking for:
- to use CMake and not import or otherwise rely upon any makefiles from libDaisy 
- a simple `*.cmake` and `CMakeLists.txt` structure
- useful configurations in `launch.json`
- commands to program via `dfu-util` or `openocd`
- a home for unit tests to be compiled and run on the host
- default boot from flash but other options supported
- to do my own thing for the challenge

There's a _lot_ taken from the example projects provided by [Electrosmith](https://github.com/electro-smith). 

My [deepnote-seed](https://github.com/davidirvine/deepnote-seed) project is an example of a repo that was created from this template.

To create a private repo using this repo as a template:

```
gh repo create {new_repo_name} --private --clone --template davidirvine/DaisyVSCodeTemplate
```

## Values You'll Want to Change

When creating a nekw project from this template you'll need to change the following values:

- `CMakeLists.txt:16` project name
- `src/CMakeLists.txt:4` TARGET value

## Build Setup
```
mkdir build
cd build
cmake ..
```
If you want to compile with the `-g` option for debugging specify `CMAKE_BUILD_TYPE=Debug`
```
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

## Unit Tests
The `test` directory is there to support compiling and running unit tests on the host platdform using [DocTest](https://github.com/doctest/doctest). Of course you can only test code that has no dependencies on hardware. A version of DocTest can be found in the `thirdparty` directory.

After you add your test sources and dependencies to `test/CMakeLists.txt` you'll want to set up you unit test build with:
```
cd test
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug ..
```
and then build and run the tests with:
```
make
./bin/tests
```

## Source Level Debugging
Two launch configurations are provided for source level debugging.

- `On Device Debug` enables source level debugging using a JTAG debug probe.
- `Hosted Unit Test Debug` enables source level debugging of unit tests.


## Thirdparty Dependencies

External dependencies like `libDaisy` and `DaisySP` can either be managed through `git submodule` or are managed using CMake `external_project` depending on your needs. If you are going to use `external_project` add your dependencies to `cmake/add_thirdparty_dependencies.cmake`.

Regardless of which method you use the `thirdparty` directory is the intended location for external dependencies. `doctest` has been copied along with it's license to `thirdparty/doctest`.


