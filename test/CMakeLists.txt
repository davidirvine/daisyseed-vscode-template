cmake_minimum_required(VERSION 3.31)
project(test)


include_directories( 
    ../src
    ../thirdparty
)

set(TESTS_SOUCES
    main.cpp
)

add_executable(tests 
  ${TESTS_SOUCES}
)

set_target_properties(tests PROPERTIES
  CXX_STANDARD 14
  CXX_STANDARD_REQUIRED YES
  C_STANDARD 11
  C_STANDARD_REQUIRED YES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
)

target_compile_options(tests PRIVATE -g)

add_test(NAME tests COMMAND tests)
enable_testing()