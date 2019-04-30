# Test creating static and dynamic libraries simultaneously

## Build using hand crafted Makefile
```
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs (master)
$ make
cc -c -o main.o main.c
cc -c -o s1.o s1.c
cc -c -o s2.o s2.c
cc -o main main.o s1.o s2.o
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs (master)
$ ./main
s1:+
s1:-
s2:+
s2:-
```

## Build using with static library `libs.a` cmake and ninja
```
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs
$ mkdir build ; cd build
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ cmake .. -G Ninja
-- The C compiler identification is GNU 8.3.0
-- The CXX compiler identification is GNU 8.3.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /home/wink/prgs/llvm/shared-and-static-libs/build
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ninja
[0/1] Re-running CMake...
-- Configuring done
-- Generating done
-- Build files have been written to: /home/wink/prgs/llvm/shared-and-static-libs/build
[5/5] Linking C executable main
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ldd main
	linux-vdso.so.1 (0x00007ffdc85da000)
	libc.so.6 => /usr/lib/libc.so.6 (0x00007fd3ffb6e000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007fd3ffd73000)
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ./main 
s1:+
s1:-
s2:+
s2:-
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ls
build.ninja  CMakeCache.txt  CMakeFiles  cmake_install.cmake  libs.a  main  rules.ninja
```

## Build main_shared and main_static with \*.o only build once
```
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs
$ mkdir build ; cd build
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ cmake .. -G Ninja
-- The C compiler identification is GNU 8.3.0
-- The CXX compiler identification is GNU 8.3.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /home/wink/prgs/llvm/shared-and-static-libs/build
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ninja
[0/1] Re-running CMake...
-- Configuring done
-- Generating done
-- Build files have been written to: /home/wink/prgs/llvm/shared-and-static-libs/build
[7/7] Linking C executable main_static
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ninja
ninja: no work to do.
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ./main_shared 
s1:+
s1:-
s2:+
s2:-
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ldd main_shared
	linux-vdso.so.1 (0x00007fff97b3c000)
	libs_shared.so => /home/wink/prgs/llvm/shared-and-static-libs/build/libs_shared.so (0x00007fb55f847000)
	libc.so.6 => /usr/lib/libc.so.6 (0x00007fb55f649000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007fb55f853000)
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ./main_static
s1:+
s1:-
s2:+
s2:-
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ldd main_static
	not a dynamic executable
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ tree -h ..
..
├── [4.0K]  build
│   ├── [ 11K]  build.ninja
│   ├── [ 13K]  CMakeCache.txt
│   ├── [4.0K]  CMakeFiles
│   │   ├── [4.0K]  3.14.3
│   │   │   ├── [2.3K]  CMakeCCompiler.cmake
│   │   │   ├── [5.0K]  CMakeCXXCompiler.cmake
│   │   │   ├── [ 16K]  CMakeDetermineCompilerABI_C.bin
│   │   │   ├── [ 16K]  CMakeDetermineCompilerABI_CXX.bin
│   │   │   ├── [ 410]  CMakeSystem.cmake
│   │   │   ├── [4.0K]  CompilerIdC
│   │   │   │   ├── [ 16K]  a.out
│   │   │   │   ├── [ 20K]  CMakeCCompilerId.c
│   │   │   │   └── [4.0K]  tmp
│   │   │   └── [4.0K]  CompilerIdCXX
│   │   │       ├── [ 16K]  a.out
│   │   │       ├── [ 19K]  CMakeCXXCompilerId.cpp
│   │   │       └── [4.0K]  tmp
│   │   ├── [  85]  cmake.check_cache
│   │   ├── [ 53K]  CMakeOutput.log
│   │   ├── [4.0K]  CMakeTmp
│   │   ├── [ 16K]  feature_tests.bin
│   │   ├── [ 688]  feature_tests.c
│   │   ├── [9.8K]  feature_tests.cxx
│   │   ├── [4.0K]  main_shared.dir
│   │   ├── [4.0K]  main_static.dir
│   │   ├── [4.0K]  m_obj.dir
│   │   │   └── [1.4K]  main.c.o
│   │   ├── [4.0K]  s_objs.dir
│   │   │   ├── [1.5K]  s1.c.o
│   │   │   └── [1.5K]  s2.c.o
│   │   ├── [4.0K]  s_shared.dir
│   │   ├── [4.0K]  s_static.dir
│   │   └── [ 600]  TargetDirectories.txt
│   ├── [1.5K]  cmake_install.cmake
│   ├── [ 16K]  libs_shared.so
│   ├── [3.3K]  libs_static.a
│   ├── [ 16K]  main_shared
│   ├── [747K]  main_static
│   └── [3.1K]  rules.ninja
├── [ 858]  CMakeLists.txt
├── [1.2K]  LICENSE
├── [  99]  main.c
├── [ 217]  Makefile
├── [6.1K]  README.md
├── [  78]  s1.c
├── [  68]  s1.h
├── [  78]  s2.c
└── [  68]  s2.h

14 directories, 35 files
```
