set(DAISY_PID df11)
set(STM_PID df11)

set(INTERNAL_ADDRESS 0x08000000)
set(QSPI_ADDRESS 0x90040000)

set(TARGET_BIN ${CMAKE_BINARY_DIR}/bin/${TARGET}.bin)
set(TARGET_ELF ${CMAKE_BINARY_DIR}/bin/${TARGET}.elf)
set(TARGET_HEX ${CMAKE_BINARY_DIR}/bin/${TARGET}.hex)

#
# Configure the linker script and other odds and ends for the
# selected boot mode
message(STATUS "Using ${EXECUTABLE_STORAGE_LOCATION} storage location")
if ("x_${EXECUTABLE_STORAGE_LOCATION}" STREQUAL "x_BOOT_FLASH")
  include(boot_flash)
elseif ("x_${EXECUTABLE_STORAGE_LOCATION}" STREQUAL "x_BOOT_SRAM")
  include(boot_sram)
elseif ("x_${EXECUTABLE_STORAGE_LOCATION}" STREQUAL "x_BOOT_QSPI")
  include(boot_qspi)
else()
  message(FATAL_ERROR "Invalid EXECUTABLE_STORAGE_LOCATION: ${EXECUTABLE_STORAGE_LOCATION}")
endif()


set_target_properties(${TARGET} PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED YES
  C_STANDARD 11
  C_STANDARD_REQUIRED YES
  SUFFIX ".elf"
  LINK_DEPENDS ${LINKER_SCRIPT}
)

add_compile_definitions($<$<CONFIG:Release,MinSizeRel>:NDEBUG>)

target_link_options(${TARGET} PUBLIC
  LINKER:-T,${LINKER_SCRIPT}
  $<$<CONFIG:Debug>:LINKER:-Map=${TARGET}.map>
  $<$<CONFIG:Debug>:LINKER:--cref>
  $<$<CONFIG:Release,MinSizeRel,RelWithDebInfo>:LINKER:-flto>
  LINKER:--gc-sections
  LINKER:--check-sections
  LINKER:--unresolved-symbols=report-all
  LINKER:--warn-common
  $<$<CXX_COMPILER_ID:GNU>:LINKER:--warn-section-align>
  $<$<CXX_COMPILER_ID:GNU>:LINKER:--print-memory-usage>
)

set(c_flags   
  -Wall
  -Wno-attributes
  -Wno-strict-aliasing
  -Wno-maybe-uninitialized
  -Wno-missing-attributes
  -Wno-stringop-overflow
  -Wno-error=reorder
  -Wno-error=sign-compare
  -DQ_DONT_USE_THREADS=1
)


set(cxx_flags
  -fno-exceptions
  -fasm
  -finline
  -finline-functions-called-once
  -fshort-enums
  -fno-move-loop-invariants
  -fno-unwind-tables
  -fno-rtti
  -fasm
  -Wno-register
)

set(gnu_cxx_flags -Werror -Wno-attributes -Wno-missing-attributes)

target_compile_options(${TARGET} PUBLIC
  $<$<CONFIG:Debug>:-Og>
  $<$<CONFIG:Release>:-O3>
  $<$<CONFIG:MinSizeRel>:-Os>
  $<$<CONFIG:Release,MinSizeRel,RelWithDebInfo>:-flto>
  $<$<CONFIG:Debug,RelWithDebInfo>:-ggdb3>
  $<$<COMPILE_LANGUAGE:C>:${c_flags}>
  $<$<COMPILE_LANGUAGE:CXX>:${cxx_flags}>
  $<$<CXX_COMPILER_ID:GNU>:${gnu_cxx_flags}>
)