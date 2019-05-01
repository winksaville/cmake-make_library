# Explore cmake make_library

`make_library` allows the creation of static or shared that
can be made One At A Time simultaneously. It can also make
OBJECT libraries to separate compilation and linking.

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

## Build main_shared and main_static building the libraries one at a time

This takes 9 steps because we compile s1.c and s2.c twice once without PIC
for creating the static library and once with PIC for shared library.

Note **-DOAAT=true**

```
$ rm -rf * .ninja_* ; cmake .. -G Ninja -DOAAT=true && ninja -v && tree .. -h && ./main_shared && ./main_static && ldd main_s*
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
[1/9] /usr/bin/cc    -MD -MT CMakeFiles/s_STATIC_objlib.dir/s2.c.o -MF CMakeFiles/s_STATIC_objlib.dir/s2.c.o.d -o CMakeFiles/s_STATIC_objlib.dir/s2.c.o   -c ../s2.c
[2/9] /usr/bin/cc   -fPIC -MD -MT CMakeFiles/s_SHARED_objlib.dir/s1.c.o -MF CMakeFiles/s_SHARED_objlib.dir/s1.c.o.d -o CMakeFiles/s_SHARED_objlib.dir/s1.c.o   -c ../s1.c
[3/9] /usr/bin/cc   -fPIC -MD -MT CMakeFiles/s_SHARED_objlib.dir/s2.c.o -MF CMakeFiles/s_SHARED_objlib.dir/s2.c.o.d -o CMakeFiles/s_SHARED_objlib.dir/s2.c.o   -c ../s2.c
[4/9] /usr/bin/cc    -MD -MT CMakeFiles/s_STATIC_objlib.dir/s1.c.o -MF CMakeFiles/s_STATIC_objlib.dir/s1.c.o.d -o CMakeFiles/s_STATIC_objlib.dir/s1.c.o   -c ../s1.c
[5/9] /usr/bin/cc   -fPIC -MD -MT CMakeFiles/m_obj.dir/main.c.o -MF CMakeFiles/m_obj.dir/main.c.o.d -o CMakeFiles/m_obj.dir/main.c.o   -c ../main.c
[6/9] : && /usr/bin/cc -fPIC    -shared -Wl,-soname,libs.so -o libs.so CMakeFiles/s_SHARED_objlib.dir/s1.c.o CMakeFiles/s_SHARED_objlib.dir/s2.c.o   && :
[7/9] : && /usr/bin/cc   -rdynamic CMakeFiles/m_obj.dir/main.c.o  -o main_shared  -Wl,-rpath,/home/wink/prgs/llvm/shared-and-static-libs/build libs.so && :
[8/9] : && /usr/bin/cmake -E remove libs.a && /usr/bin/ar qc libs.a  CMakeFiles/s_STATIC_objlib.dir/s1.c.o CMakeFiles/s_STATIC_objlib.dir/s2.c.o && /usr/bin/ranlib libs.a && :
[9/9] : && /usr/bin/cc   -rdynamic CMakeFiles/m_obj.dir/main.c.o  -o main_static  -static libs.a && :
..
├── [4.0K]  build
│   ├── [ 21K]  build.ninja
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
│   │   ├── [4.0K]  s_shared.dir
│   │   ├── [4.0K]  s_SHARED_objlib.dir
│   │   │   ├── [1.5K]  s1.c.o
│   │   │   └── [1.5K]  s2.c.o
│   │   ├── [4.0K]  s_static.dir
│   │   ├── [4.0K]  s_STATIC_objlib.dir
│   │   │   ├── [1.5K]  s1.c.o
│   │   │   └── [1.5K]  s2.c.o
│   │   └── [ 690]  TargetDirectories.txt
│   ├── [1.5K]  cmake_install.cmake
│   ├── [3.3K]  libs.a
│   ├── [ 16K]  libs.so
│   ├── [ 16K]  main_shared
│   ├── [747K]  main_static
│   └── [3.4K]  rules.ninja
├── [ 901]  CMakeLists.txt
├── [1.2K]  LICENSE
├── [  99]  main.c
├── [ 217]  Makefile
├── [2.2K]  make_library.cmake
├── [4.2K]  README.md
├── [  78]  s1.c
├── [  68]  s1.h
├── [  78]  s2.c
└── [  68]  s2.h

15 directories, 38 files
s1:+
s1:-
s2:+
s2:-
s1:+
s1:-
s2:+
s2:-
main_shared:
	linux-vdso.so.1 (0x00007fff977fc000)
	libs.so => /home/wink/prgs/llvm/shared-and-static-libs/build/libs.so (0x00007f88dfcc8000)
	libc.so.6 => /usr/lib/libc.so.6 (0x00007f88dfaca000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f88dfcd4000)
main_static:
	not a dynamic executable
```

## Build main_shared and main_static building the libraries simultaneously

This takes 7 steps instead of 9 when doing OAAT because we compile s1.c and s2.c
just once each with PIC.

Note: **-DOAAT** is absent

```
$ rm -rf * .ninja_* ; cmake .. -G Ninja && ninja -v && tree .. -h && ./main_shared && ./main_static && ldd main_s*
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
[1/7] /usr/bin/cc   -fPIC -MD -MT CMakeFiles/s_SHARED_objlib.dir/s1.c.o -MF CMakeFiles/s_SHARED_objlib.dir/s1.c.o.d -o CMakeFiles/s_SHARED_objlib.dir/s1.c.o   -c ../s1.c
[2/7] /usr/bin/cc   -fPIC -MD -MT CMakeFiles/m_obj.dir/main.c.o -MF CMakeFiles/m_obj.dir/main.c.o.d -o CMakeFiles/m_obj.dir/main.c.o   -c ../main.c
[3/7] /usr/bin/cc   -fPIC -MD -MT CMakeFiles/s_SHARED_objlib.dir/s2.c.o -MF CMakeFiles/s_SHARED_objlib.dir/s2.c.o.d -o CMakeFiles/s_SHARED_objlib.dir/s2.c.o   -c ../s2.c
[4/7] : && /usr/bin/cc -fPIC    -shared -Wl,-soname,libs.so -o libs.so CMakeFiles/s_SHARED_objlib.dir/s1.c.o CMakeFiles/s_SHARED_objlib.dir/s2.c.o   && :
[5/7] : && /usr/bin/cc   -rdynamic CMakeFiles/m_obj.dir/main.c.o  -o main_shared  -Wl,-rpath,/home/wink/prgs/llvm/shared-and-static-libs/build libs.so && :
[6/7] : && /usr/bin/cmake -E remove libs.a && /usr/bin/ar qc libs.a  CMakeFiles/s_SHARED_objlib.dir/s1.c.o CMakeFiles/s_SHARED_objlib.dir/s2.c.o && /usr/bin/ranlib libs.a && :
[7/7] : && /usr/bin/cc   -rdynamic CMakeFiles/m_obj.dir/main.c.o  -o main_static  -static libs.a && :
..
├── [4.0K]  build
│   ├── [ 20K]  build.ninja
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
│   │   ├── [4.0K]  s_shared.dir
│   │   ├── [4.0K]  s_SHARED_objlib.dir
│   │   │   ├── [1.5K]  s1.c.o
│   │   │   └── [1.5K]  s2.c.o
│   │   ├── [4.0K]  s_static.dir
│   │   └── [ 609]  TargetDirectories.txt
│   ├── [1.5K]  cmake_install.cmake
│   ├── [3.3K]  libs.a
│   ├── [ 16K]  libs.so
│   ├── [ 16K]  main_shared
│   ├── [747K]  main_static
│   └── [3.1K]  rules.ninja
├── [ 901]  CMakeLists.txt
├── [1.2K]  LICENSE
├── [  99]  main.c
├── [ 217]  Makefile
├── [2.2K]  make_library.cmake
├── [5.4K]  README.md
├── [  78]  s1.c
├── [  68]  s1.h
├── [  78]  s2.c
└── [  68]  s2.h

14 directories, 36 files
s1:+
s1:-
s2:+
s2:-
s1:+
s1:-
s2:+
s2:-
main_shared:
	linux-vdso.so.1 (0x00007fffa4afe000)
	libs.so => /home/wink/prgs/llvm/shared-and-static-libs/build/libs.so (0x00007f880d7b7000)
	libc.so.6 => /usr/lib/libc.so.6 (0x00007f880d5b9000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f880d7c3000)
main_static:
	not a dynamic executable
```
