cmake_minimum_required(VERSION 3.14)

project(gis-polygons VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt5 REQUIRED COMPONENTS Core Quick Positioning)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Positioning )

set(PROJECT_SOURCES
        main.cpp
        qml.qrc
        CoordinatesDataModel.cpp
        CoordinatesDataModel.h
)


add_executable(gis-polygons
  ${PROJECT_SOURCES}
)

target_compile_definitions(gis-polygons
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(gis-polygons
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Positioning)

set_target_properties(gis-polygons PROPERTIES
    WIN32_EXECUTABLE TRUE
)
