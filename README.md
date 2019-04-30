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

## build using with shared library `libs.so` cmake and ninja
```
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs
$ mkdir build ; cd build
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ rm -rf *
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ cmake .. -G Ninja -DBUILD_SHARED_LIBS:BOOL=ON
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
	linux-vdso.so.1 (0x00007ffc833ac000)
	libs.so => /home/wink/prgs/llvm/shared-and-static-libs/build/libs.so (0x00007f7daa49e000)
	libc.so.6 => /usr/lib/libc.so.6 (0x00007f7daa2a0000)
	/lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f7daa4aa000)
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ./main
s1:+
s1:-
s2:+
s2:-
wink@wink-desktop:~/prgs/llvm/shared-and-static-libs/build
$ ls
build.ninja  CMakeCache.txt  CMakeFiles  cmake_install.cmake  libs.so  main  rules.ninja
