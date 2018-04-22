project(plasma-workspace)
set(PROJECT_VERSION "5.12.3")
set(PROJECT_VERSION_MAJOR 5)

cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

set(QT_MIN_VERSION "5.9.0")
set(KF5_MIN_VERSION "5.42.0")

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED COMPONENTS
    Core
    DBus
)

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS
    Widgets
    Quick
    QuickWidgets
    Concurrent
    Test
    Script
    Network
)
find_package(ECM 1.8.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMPackageConfigHelpers)
include(ECMMarkNonGuiExecutable)
include(CMakePackageConfigHelpers)
include(WriteBasicConfigVersionFile)
include(CheckIncludeFiles)
include(FeatureSummary)
include(ECMOptionalAddSubdirectory)
include(ECMQtDeclareLoggingCategory)
include(KDEPackageAppTemplates)

find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS
    Plasma
    DocTools
    Runner
    JsEmbed
    NotifyConfig
    Su
    NewStuff
    Wallet
    KCMUtils
    IdleTime
    Declarative
    TextWidgets
    KDELibs4Support
    Crash
    GlobalAccel
    DBusAddons
    Wayland
    CoreAddons
)

# WARNING PlasmaQuick provides unversioned CMake config
find_package(KF5 REQUIRED COMPONENTS PlasmaQuick)

find_package(KF5Activities ${KF5_MIN_VERSION})
set_package_properties(KF5Activities PROPERTIES DESCRIPTION "management of Plasma activities"
                       TYPE OPTIONAL
                       PURPOSE "Needed by activity related plasmoids."
                      )

find_package(X11)
set_package_properties(X11 PROPERTIES DESCRIPTION "X11 libraries"
                        URL "http://www.x.org"
                        TYPE OPTIONAL
                        PURPOSE "Required for building the X11 based workspace")

if(X11_FOUND)
  find_package(XCB MODULE REQUIRED COMPONENTS XCB RANDR)
  set_package_properties(XCB PROPERTIES TYPE REQUIRED)
  if(NOT X11_SM_FOUND)
    message(FATAL_ERROR "\nThe X11 Session Management (SM) development package could not be found.\nPlease install libSM.\n")
  endif(NOT X11_SM_FOUND)

  find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS X11Extras)
endif()

if(X11_FOUND AND XCB_XCB_FOUND)
  set(HAVE_X11 1)
endif()


include(ConfigureChecks.cmake)

include_directories("${CMAKE_CURRENT_BINARY_DIR}")

configure_file(config-X11.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config-X11.h)

add_definitions(-DQT_NO_URL_CAST_FROM_STRING)


add_subdirectory(libdbusmenuqt)




set(appmenuapplet_SRCS
    appmenumodel.cpp
    appmenuplugin.cpp
)

add_library(localmenuplugin SHARED ${appmenuapplet_SRCS})
target_link_libraries(localmenuplugin
                      Qt5::Core
                      Qt5::Widgets
                      Qt5::Quick
                      KF5::Plasma
                      KF5::WindowSystem
                      dbusmenuqt)

if(HAVE_X11)
    target_link_libraries(localmenuplugin Qt5::X11Extras XCB::XCB)
endif()

install(TARGETS localmenuplugin DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/localmenu)

install(FILES qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/plasma/private/localmenu)

