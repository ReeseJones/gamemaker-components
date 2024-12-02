cmake_minimum_required(VERSION 3.6)

project(gamemaker-components)
set_directory_properties(PROPERTIES VS_STARTUP_PROJECT gamemaker-components)

set(projectRoot "D:/_/gamemaker-components/gamemaker-components")

set(source ${CMAKE_CURRENT_SOURCE_DIR}/source.rsp)

message("${source}")

# Load the script list, and remove the tildes from event scripts We need to
# check for UTF-16LE first for certain formattings and then fall back to utf8
# (default) if file was unable to parse
file(STRINGS ${source} scriptList ENCODING UTF-16LE)
if(NOT scriptList)
  file(STRINGS ${source} scriptList)
endif()

list(TRANSFORM scriptList REPLACE "~" "" OUTPUT_VARIABLE scriptPaths)

# Add the source list and each of the scripts to the project, so they appear in
# the IDE
add_custom_target(gamemaker-components ALL SOURCES ${source} ${scriptPaths})

# This could be replaced with source_group(TREE ...) if we assume all scripts to
# be under the same directory
foreach(scriptPath ${scriptPaths})
  message("${scriptPath}")
  get_filename_component(scriptDirectory "${scriptPath}" DIRECTORY)
  cmake_path(RELATIVE_PATH scriptDirectory BASE_DIRECTORY "${projectRoot}"
             OUTPUT_VARIABLE relPath)
  # Remove the "../" from the beginning of the relative path
  string(REPLACE "../" "" filterPath "${relPath}")
  source_group("${filterPath}" FILES "${scriptPath}")
endforeach()

set_target_properties(
  "gamemaker-components"
  PROPERTIES VS_DEBUGGER_COMMAND "${CMAKE_CURRENT_BINARY_DIR}/gamemaker-components")

set_target_properties("gamemaker-components" PROPERTIES OUTPUT_NAME
                                                           "gamemaker-components")

# set_target_properties(gamemaker-components PROPERTIES
# VS_DEBUGGER_COMMAND_ARGUMENTS
# --wad="${CMAKE_CURRENT_BINARY_DIR}/gamemaker-components0.wad")

# FIXME :: Erin find_package(YYTools REQUIRED)

# separate_arguments(GMC_ARGS)

if(DEBUG_TOOLCHAIN)
  add_custom_command(
    TARGET "gamemaker-components"
    COMMAND
      "${YY_DEBUG_TOOLS_DIR}/gmcd" $<$<BOOL:${DEBUG_SCRIPTS}>:-g> -rtdebug -di
      -execution-mode=${SCRIPT_EXECUTION_MODE}
      -bd="${CMAKE_CURRENT_BINARY_DIR}/out" "${USE_CUSTOM_INTERPRETER}"
      "${GMC_ARGS}" -t ${TRIPLE_NAME} ${COMPILE_MODE_FLAGS} @${source} -l
      "${YY_DEBUG_LIBS_DIR}/${TRIPLE_NAME}" -l "${CMAKE_CURRENT_SOURCE_DIR}" -o
      "${CMAKE_CURRENT_BINARY_DIR}/gamemaker-components"
    COMMENT "Building Executable")
else()
  add_custom_command(
    TARGET "gamemaker-components"
    COMMAND
      "${YY_RELEASE_TOOLS_DIR}/gmc" $<$<BOOL:${DEBUG_SCRIPTS}>:-g> -di
      -execution-mode=${SCRIPT_EXECUTION_MODE}
      -bd="${CMAKE_CURRENT_BINARY_DIR}/out" "${USE_CUSTOM_INTERPRETER}"
      "${GMC_ARGS}" -t ${TRIPLE_NAME} ${COMPILE_MODE_FLAGS} @${source} -l
      "${YY_RELEASE_LIBS_DIR}/${TRIPLE_NAME}" -l "${CMAKE_CURRENT_SOURCE_DIR}"
      -o "${CMAKE_CURRENT_BINARY_DIR}/gamemaker-components"
    COMMENT "Building Executable")
endif()
