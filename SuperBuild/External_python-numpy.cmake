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
  #  - numpy-1.21.6-cp39-cp39-macosx_10_9_universal2.whl
  #  - numpy-1.21.6-cp39-cp39-macosx_10_9_x86_64.whl
  #  - numpy-1.21.6-cp39-cp39-macosx_11_0_arm64.whl
  #  - numpy-1.21.6-cp39-cp39-manylinux_2_12_x86_64.manylinux2010_x86_64.whl
  #  - numpy-1.21.6-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
  #  - numpy-1.21.6-cp39-cp39-win_amd64.whl
  numpy==1.21.6 --hash=sha256:4391bd07606be175aafd267ef9bea87cf1b8210c787666ce82073b05f202add1 \
                --hash=sha256:67f21981ba2f9d7ba9ade60c9e8cbaa8cf8e9ae51673934480e45cf55e953673 \
                --hash=sha256:ee5ec40fdd06d62fe5d4084bef4fd50fd4bb6bfd2bf519365f569dc470163ab0 \
                --hash=sha256:d9caa9d5e682102453d96a0ee10c7241b72859b01a941a397fd965f23b3e016b \
                --hash=sha256:58459d3bad03343ac4b1b42ed14d571b8743dc80ccbf27444f266729df1d6f5b \
                --hash=sha256:e31f0bb5928b793169b87e3d1e070f2342b22d5245c755e2b81caa29756246c3
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

