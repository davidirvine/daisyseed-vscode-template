#
#   some of the included cmake files depend on TARGET being defined
#
set(TARGET daisyvscodetemplate)

add_executable(${TARGET} 
    main.cpp 
)


# Link libraries
target_link_libraries(${TARGET} ${DAISYSP_DIR}/build/libdaisysp.a)
target_link_libraries(${TARGET} ${LIBDAISY_DIR}/build/libdaisy.a)


# Include directories
target_include_directories(${TARGET} PRIVATE
    ${DAISYSP_DIR}/Source
    ${LIBDAISY_DIR}/src/
    ${LIBDAISY_DIR}/src/sys
    ${LIBDAISY_DIR}/src/usbh
    ${LIBDAISY_DIR}/src/Drivers/STM32H7xx_HAL_Driver/Inc
    ${LIBDAISY_DIR}/Middlewares/ST/STM32_USB_Host_Library/Core/Inc
    ${LIBDAISY_DIR}/Middlewares/Third_Party/FatFs/src
    ${LIBDAISY_DIR}/Drivers/CMSIS_5/CMSIS/Core/Include
    ${LIBDAISY_DIR}/Drivers/CMSIS-Device/ST/STM32H7xx/Include
    ${LIBDAISY_DIR}/Drivers/STM32H7xx_HAL_Driver/Inc
    ${LIBDAISY_DIR}/Drivers/STM32H7xx_HAL_Driver/Inc/Legacy
)

include(compiler_linker_options)  
include(post_build_commands)
include(program_commands)