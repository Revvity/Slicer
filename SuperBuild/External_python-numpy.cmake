set(proj python-numpy)

# Set dependency list
set(${proj}_DEPENDENCIES
  python
  python-pip
  python-setuptools
  )

if(NOT DEFINED Slicer_USE_SYSTEM_${proj})
  set(Slicer_USE_SYSTEM_${proj} ${Slicer_USE_SYSTEM_python})
endif()

# Include dependent projects if any
ExternalProject_Include_Dependencies(${proj} PROJECT_VAR proj DEPENDS_VAR ${proj}_DEPENDENCIES)

if(Slicer_USE_SYSTEM_${proj})
  foreach(module_name IN ITEMS
    nose
    numpy
    )
    ExternalProject_FindPythonPackage(
      MODULE_NAME "${module_name}"
      REQUIRED
      )
  endforeach()
endif()

if(NOT Slicer_USE_SYSTEM_${proj})
  set(requirements_file ${CMAKE_BINARY_DIR}/${proj}-requirements.txt)
  file(WRITE ${requirements_file} [===[
  # [nose]
  nose==1.3.7 --hash=sha256:9ff7c6cc443f8c51994b34a667bbcf45afd6d945be7477b52e97516fd17c53ac  # needed for NumPy unit tests
  # [/nose]
  # [numpy]
  # Hashes correspond to the following packages:
  #  - numpy-1.24.4-cp39-cp39-macosx_10_9_x86_64.whl
  #  - numpy-1.24.4-cp39-cp39-macosx_11_0_arm64.whl
  #  - numpy-1.24.4-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
  #  - numpy-1.24.4-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl
  #  - numpy-1.24.4-cp39-cp39-win_amd64.whl
  numpy==1.24.4 --hash=sha256:2541312fbf09977f3b3ad449c4e5f4bb55d0dbf79226d7724211acc905049400 \
                --hash=sha256:9667575fb6d13c95f1b36aca12c5ee3356bf001b714fc354eb5465ce1609e62f \
                --hash=sha256:f3a86ed21e4f87050382c7bc96571755193c4c1392490744ac73d660e8f564a9 \
                --hash=sha256:d11efb4dbecbdf22508d55e48d9c8384db795e1b7b51ea735289ff96613ff74d \
                --hash=sha256:befe2bf740fd8373cf56149a5c23a0f601e82869598d41f8e188a0e9869926f8
  # [/numpy]
  ]===])

  ExternalProject_Add(${proj}
    ${${proj}_EP_ARGS}
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ${PYTHON_EXECUTABLE} -m pip install --require-hashes -r ${requirements_file}
    LOG_INSTALL 1
    DEPENDS
      ${${proj}_DEPENDENCIES}
    )

  ExternalProject_GenerateProjectDescription_Step(${proj}
    VERSION ${_version}
    )

  #-----------------------------------------------------------------------------
  # Sanity checks

  foreach(varname IN ITEMS
      python_DIR
      PYTHON_SITE_PACKAGES_SUBDIR
      )
    if("${${varname}}" STREQUAL "")
      message(FATAL_ERROR "${varname} CMake variable is expected to be set")
    endif()
  endforeach()

  #-----------------------------------------------------------------------------
  # Launcher setting specific to build tree

  set(${proj}_LIBRARY_PATHS_LAUNCHER_BUILD
    ${python_DIR}/${PYTHON_SITE_PACKAGES_SUBDIR}/numpy/core
    ${python_DIR}/${PYTHON_SITE_PACKAGES_SUBDIR}/numpy/lib
    )
  mark_as_superbuild(
    VARS ${proj}_LIBRARY_PATHS_LAUNCHER_BUILD
    LABELS "LIBRARY_PATHS_LAUNCHER_BUILD"
    )

  #-----------------------------------------------------------------------------
  # Launcher setting specific to install tree

  set(${proj}_LIBRARY_PATHS_LAUNCHER_INSTALLED
    <APPLAUNCHER_SETTINGS_DIR>/../lib/Python/${PYTHON_SITE_PACKAGES_SUBDIR}/numpy/core
    <APPLAUNCHER_SETTINGS_DIR>/../lib/Python/${PYTHON_SITE_PACKAGES_SUBDIR}/numpy/lib
    )
  mark_as_superbuild(
    VARS ${proj}_LIBRARY_PATHS_LAUNCHER_INSTALLED
    LABELS "LIBRARY_PATHS_LAUNCHER_INSTALLED"
    )

else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${${proj}_DEPENDENCIES})
endif()

