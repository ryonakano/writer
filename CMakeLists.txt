project (writer)
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.6)

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share/writer")
set (PKGDATADIR "${DATADIR}/writer")
set (GETTEXT_PACKAGE "writer")
set (RELEASE_NAME "Writer")
set (VERSION "0.1")
set (VERSION_INFO "Release")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

file(GLOB_RECURSE sources src/*.vala)

# Some configuration
configure_file (${CMAKE_SOURCE_DIR}/src/config.vala.cmake ${CMAKE_SOURCE_DIR}/src/config.vala)

# Vala
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.18" MINIMUM)
include (ValaPrecompile)

# Definitions
add_definitions (-DGETTEXT_PACKAGE="writer")

find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED granite gtk+-3.0 gthread-2.0)
add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.16.0" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C
    src/Writer.vala
    src/MainWindow.vala
    src/Widgets/TitleBar.vala
    src/Widgets/WelcomeView.vala
    src/config.vala
PACKAGES
    gtk+-3.0
    granite
OPTIONS
    --thread
)

add_subdirectory (po)

add_executable(writer ${VALA_C})

install (TARGETS writer RUNTIME DESTINATION bin)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/writer.desktop DESTINATION share/applications)
IF (EXISTS (${CMAKE_CURRENT_SOURCE_DIR}/data/writer.svg))
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/writer.svg DESTINATION share/icons/hicolor/48x48/apps)
ENDIF ()
