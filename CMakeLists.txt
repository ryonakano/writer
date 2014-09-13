project (writer)
cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.6)

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala)

enable_testing ()

set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/writer")
set (GETTEXT_PACKAGE "writer")
set (RELEASE_NAME "Writer")
set (VERSION "0.1")
set (VERSION_INFO "Release")
set (CMAKE_C_FLAGS "-ggdb")
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DOLLAR "$")

list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Some configuration
configure_file (${CMAKE_SOURCE_DIR}/src/config.vala.cmake ${CMAKE_SOURCE_DIR}/src/config.vala)
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")

# Vala
find_package (Vala REQUIRED)
include (ValaVersion)
ensure_vala_version ("0.22" MINIMUM)
include (ValaPrecompile)

# Add 'make dist' command for creating release tarball
set (CPACK_PACKAGE_VERSION ${VERSION})
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;~$;${CPACK_SOURCE_IGNORE_FILES}")

include (CPack)
add_custom_target (dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED granite gtk+-3.0)

add_definitions(${DEPS_CFLAGS})

link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.18.0" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C
    src/Utils/Document.vala
    src/Utils/Editor.vala
    src/Utils/FileChooser.vala
    src/Utils/TextRange.vala
    src/Utils/ZeitgeistLogger.vala
    src/Widgets/ButtonGroup.vala
    src/Widgets/EditorToolBar.vala
    src/Widgets/EditorView.vala
    src/Widgets/ImageToolBar.vala
    src/Widgets/TableChooser.vala
    src/Widgets/TableToolBar.vala
    src/Widgets/TitleBar.vala
    src/Widgets/ToolBar.vala
    src/Widgets/WelcomeView.vala
    src/config.vala
    src/Writer.vala
    src/MainWindow.vala
PACKAGES
    gtk+-3.0
    granite
OPTIONS
    --thread
    --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
)

add_subdirectory (data)
add_subdirectory (po)

add_executable (writer ${VALA_C})

install (TARGETS writer RUNTIME DESTINATION bin)

install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/writer.desktop DESTINATION share/applications)
IF (EXISTS (${CMAKE_CURRENT_SOURCE_DIR}/data/writer.svg))
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/writer.svg DESTINATION share/icons/hicolor/48x48/apps)
ENDIF ()