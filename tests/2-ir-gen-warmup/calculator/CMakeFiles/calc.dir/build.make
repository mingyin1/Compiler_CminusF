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
include tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/depend.make

# Include the progress variables for this target.
include tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/progress.make

# Include the compile flags for this target's objects.
include tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/flags.make

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc.cpp.o: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/flags.make
tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc.cpp.o: ../tests/2-ir-gen-warmup/calculator/calc.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/labs/2022fall-compiler_cminus/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc.cpp.o"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/calc.dir/calc.cpp.o -c /labs/tests/2-ir-gen-warmup/calculator/calc.cpp

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/calc.dir/calc.cpp.i"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /labs/tests/2-ir-gen-warmup/calculator/calc.cpp > CMakeFiles/calc.dir/calc.cpp.i

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/calc.dir/calc.cpp.s"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /labs/tests/2-ir-gen-warmup/calculator/calc.cpp -o CMakeFiles/calc.dir/calc.cpp.s

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_ast.cpp.o: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/flags.make
tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_ast.cpp.o: ../tests/2-ir-gen-warmup/calculator/calc_ast.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/labs/2022fall-compiler_cminus/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_ast.cpp.o"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/calc.dir/calc_ast.cpp.o -c /labs/tests/2-ir-gen-warmup/calculator/calc_ast.cpp

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_ast.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/calc.dir/calc_ast.cpp.i"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /labs/tests/2-ir-gen-warmup/calculator/calc_ast.cpp > CMakeFiles/calc.dir/calc_ast.cpp.i

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_ast.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/calc.dir/calc_ast.cpp.s"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /labs/tests/2-ir-gen-warmup/calculator/calc_ast.cpp -o CMakeFiles/calc.dir/calc_ast.cpp.s

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_builder.cpp.o: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/flags.make
tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_builder.cpp.o: ../tests/2-ir-gen-warmup/calculator/calc_builder.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/labs/2022fall-compiler_cminus/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_builder.cpp.o"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/calc.dir/calc_builder.cpp.o -c /labs/tests/2-ir-gen-warmup/calculator/calc_builder.cpp

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_builder.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/calc.dir/calc_builder.cpp.i"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /labs/tests/2-ir-gen-warmup/calculator/calc_builder.cpp > CMakeFiles/calc.dir/calc_builder.cpp.i

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_builder.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/calc.dir/calc_builder.cpp.s"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /labs/tests/2-ir-gen-warmup/calculator/calc_builder.cpp -o CMakeFiles/calc.dir/calc_builder.cpp.s

# Object files for target calc
calc_OBJECTS = \
"CMakeFiles/calc.dir/calc.cpp.o" \
"CMakeFiles/calc.dir/calc_ast.cpp.o" \
"CMakeFiles/calc.dir/calc_builder.cpp.o"

# External object files for target calc
calc_EXTERNAL_OBJECTS =

calc: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc.cpp.o
calc: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_ast.cpp.o
calc: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/calc_builder.cpp.o
calc: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/build.make
calc: libIR_lib.a
calc: libcalc_syntax.a
calc: libcommon.a
calc: /llvm/lib/libLLVMSupport.a
calc: /llvm/lib/libLLVMDemangle.a
calc: tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/labs/2022fall-compiler_cminus/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX executable ../../../calc"
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/calc.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/build: calc

.PHONY : tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/build

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/clean:
	cd /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator && $(CMAKE_COMMAND) -P CMakeFiles/calc.dir/cmake_clean.cmake
.PHONY : tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/clean

tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/depend:
	cd /labs/2022fall-compiler_cminus && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /labs /labs/tests/2-ir-gen-warmup/calculator /labs/2022fall-compiler_cminus /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator /labs/2022fall-compiler_cminus/tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : tests/2-ir-gen-warmup/calculator/CMakeFiles/calc.dir/depend

