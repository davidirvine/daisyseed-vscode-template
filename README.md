# DaisyVSCodeTemplate

This is a template repo for DaisySeed development using VSCode. To create a private repo using this repo as a template:

```
gh repo create {new_repo_name} --private --clone --template davidirvine/DaisyVSCodeTemplate
```

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
```
make program
```

## Source Level Debugging
A launch configuration is provided which enables source level debugging using a JTAG debug probe.
