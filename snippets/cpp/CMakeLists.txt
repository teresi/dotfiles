cmake_minimum_required(VERSION 3.20)

project(my-project
    VERSION 0.1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Application library
add_library(my-project-lib
    src/my_lib.cpp
)

target_include_directories(my-project-lib
    PUBLIC include
)

# Main executable
add_executable(my-project
    src/main.cpp
)

target_link_libraries(my-project
    PRIVATE my-project-lib
)

# Testing
include(CTest)

if(BUILD_TESTING)
    include(FetchContent)

    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.17.0
    )

    FetchContent_MakeAvailable(googletest)

    add_executable(my-project-tests
        tests/my_lib_test.cpp
    )

    target_link_libraries(my-project-tests
        PRIVATE
            my-project-lib
            GTest::gtest_main
    )

    include(GoogleTest)
    gtest_discover_tests(my-project-tests)
endif()
