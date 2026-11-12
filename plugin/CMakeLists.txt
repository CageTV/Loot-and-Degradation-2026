cmake_minimum_required(VERSION 3.21)

# LootandDegradation.dll built on the vcpkg CommonLibSSE-NG (one DLL for SE, AE and VR). The 1.7.x build uses ng.cmake instead.
project(LootandDegradation VERSION 0.1.0 LANGUAGES CXX)

find_package(CommonLibSSE CONFIG REQUIRED)

add_commonlibsse_plugin(${PROJECT_NAME} NAME "LootandDegradation" AUTHOR "CageTV" SOURCES
    src/main.cpp
    src/Settings.cpp
    src/Materials.cpp
    src/Gear.cpp
    src/Degrade.cpp
    src/Menu.cpp
    src/Kit.cpp
    src/Widget.cpp
    src/NpcGear.cpp
)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
target_include_directories(${PROJECT_NAME} PRIVATE src include)
target_precompile_headers(${PROJECT_NAME} PRIVATE src/PCH.h)
target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:Release>:/Z7>)
target_link_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:Release>:/DEBUG /OPT:REF /OPT:ICF>)
