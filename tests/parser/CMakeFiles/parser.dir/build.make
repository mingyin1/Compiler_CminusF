# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /labs

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /labs/2022fall-compiler_cminus

# Include any dependencies generated for this target.
include tests/parser/CMakeFiles/parser.dir/depend.make

# Include the progress variables for this target.
include tests/parser/CMakeFiles/parser.dir/progress.make

# Include the compile flags for this target's objects.
include tests/parser/CMakeFiles/parser.dir/flags.make

tests/parser/CMakeFiles/parser.dir/parser.c.o: tests/parser/CMakeFiles/parser.dir/flags.make
tests/parser/CMakeFiles/parser.dir/parser.c.o: ../tests/parser/parser.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/labs/2022fall-compiler_cminus/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object tests/parser/CMakeFiles/parser.dir/parser.c.o"
	cd /labs/2022fall-compiler_cminus/tests/parser && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/parser.dir/parser.c.o   -c /labs/tests/parser/parser.c

tests/parser/CMakeFiles/parser.dir/parser.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/parser.dir/parser.c.i"
	cd /labs/2022fall-compiler_cminus/tests/parser && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /labs/tests/parser/parser.c > CMakeFiles/parser.dir/parser.c.i

tests/parser/CMakeFiles/parser.dir/parser.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/parser.dir/parser.c.s"
	cd /labs/2022fall-compiler_cminus/tests/parser && /usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /labs/tests/parser/parser.c -o CMakeFiles/parser.dir/parser.c.s

# Object files for target parser
parser_OBJECTS = \
"CMakeFiles/parser.dir/parser.c.o"

# External object files for target parser
parser_EXTERNAL_OBJECTS =

parser: tests/parser/CMakeFiles/parser.dir/parser.c.o
parser: tests/parser/CMakeFiles/parser.dir/build.make
parser: libsyntax.a
parser: libcommon.a
parser: tests/parser/CMakeFiles/parser.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/labs/2022fall-compiler_cminus/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../parser"
	cd /labs/2022fall-compiler_cminus/tests/parser && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/parser.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/parser/CMakeFiles/parser.dir/build: parser

.PHONY : tests/parser/CMakeFiles/parser.dir/build

tests/parser/CMakeFiles/parser.dir/clean:
	cd /labs/2022fall-compiler_cminus/tests/parser && $(CMAKE_COMMAND) -P CMakeFiles/parser.dir/cmake_clean.cmake
.PHONY : tests/parser/CMakeFiles/parser.dir/clean

tests/parser/CMakeFiles/parser.dir/depend:
	cd /labs/2022fall-compiler_cminus && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /labs /labs/tests/parser /labs/2022fall-compiler_cminus /labs/2022fall-compiler_cminus/tests/parser /labs/2022fall-compiler_cminus/tests/parser/CMakeFiles/parser.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/parser/CMakeFiles/parser.dir/depend

