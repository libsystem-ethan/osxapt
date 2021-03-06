### This file is just a script to use install_name_tool to stop executables from depending on libraries with absolute paths.
### Maybe someday this will be fixed in the actual build system, but I can't be bothered for now.

set -e

if [ `basename $PWD` != "bin" ]; then
    cd bin
fi

mkdir -p ../lib     # Move .dylib(s) to ../lib

### We have 3 problem dylibs here, libapt-pkg, libapt-inst and libapt-private. We need to use install_name_tool to get the
### executable to load them relative to the executable's own path.

PRIVATE_MAJ="0.0"
PRIVATE_MIN="0"
INST_MAJ="1.5"
INST_MIN="0"
PKG_MAJ="4.12"
PKG_MIN="0"

PRIVATE=$PRIVATE_MAJ.$PRIVATE_MIN
INST=$INST_MAJ.$INST_MIN
PKG=$PKG_MAJ.$PKG_MIN

mv libapt-private.$PRIVATE.dylib ../lib/libapt-private-$PRIVATE.dylib # This breaks symlinks but ah well.
mv libapt-inst.$INST.dylib ../lib/libapt-inst-$INST.dylib             #
mv libapt-pkg.$PKG.dylib ../lib/libapt-pkg-$PKG.dylib                 #

rm -rf *.dylib

ln -s ../lib/libapt-private-$PRIVATE.dylib ../lib/libapt-private-$PRIVATE_MAJ.dylib
ln -s ../lib/libapt-private-$PRIVATE_MAJ.dylib ../lib/libapt-private.dylib

ln -s ../lib/libapt-inst-$INST.dylib ../lib/libapt-inst-$INST_MAJ.dylib
ln -s ../lib/libapt-inst-$INST_MAJ.dylib ../lib/libapt-inst.dylib

ln -s ../lib/libapt-pkg-$PKG.dylib ../lib/libapt-pkg-$PKG_MAJ.dylib
ln -s ../lib/libapt-pkg-$PKG_MAJ.dylib ../lib/libapt-pkg.dylib

### First executable: apt. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt\033[0m\n"
install_name_tool -change `otool -L apt | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt
install_name_tool -change `otool -L apt | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt


### 2nd executable: apt-cache. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt-cache\033[0m\n"
install_name_tool -change `otool -L apt-cache | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-cache
install_name_tool -change `otool -L apt-cache | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt-cache

### 3rd executable: apt-cdrom. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt-cdrom\033[0m\n"
install_name_tool -change `otool -L apt-cdrom | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-cdrom
install_name_tool -change `otool -L apt-cdrom | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt-cdrom

### 4th executable: apt-config. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt-config\033[0m\n"
install_name_tool -change `otool -L apt-config | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-config
install_name_tool -change `otool -L apt-config | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt-config

### 5th executable: apt-dump-solver. Depends on: libapt-pkg.dylib only
printf "\033[32;1mPatching apt-dump-solver\033[0m\n"
install_name_tool -change `otool -L apt-dump-solver | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-dump-solver

### 6th executable: apt-extracttemplates. Depends on: libapt-pkg.dylib and libapt-inst.dylib
printf "\033[32;1mPatching apt-extracttemplates\033[0m\n"
install_name_tool -change `otool -L apt-extracttemplates | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-extracttemplates
install_name_tool -change `otool -L apt-extracttemplates | grep libapt-inst | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-inst-$INST.dylib apt-extracttemplates

### 7th executable: apt-get. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt-get\033[0m\n"
install_name_tool -change `otool -L apt-get | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-get
install_name_tool -change `otool -L apt-get | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt-get

### 8th executable: apt-helper. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt-helper\033[0m\n"
install_name_tool -change `otool -L apt-helper | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-helper
install_name_tool -change `otool -L apt-helper | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt-helper

### 9th executable: apt-internal-solver. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt-internal-solver\033[0m\n"
install_name_tool -change `otool -L apt-internal-solver | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-internal-solver
install_name_tool -change `otool -L apt-internal-solver | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt-internal-solver

### 10th executable: apt-mark. Depends on: libapt-pkg.dylib and libapt-private.dylib
printf "\033[32;1mPatching apt-mark\033[0m\n"
install_name_tool -change `otool -L apt-mark | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-mark
install_name_tool -change `otool -L apt-mark | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib apt-mark

### 11th executable: apt-sortpkgs. Depends on: libapt-pkg.dylib only
printf "\033[32;1mPatching apt-sortpkg\033[0m\n"
install_name_tool -change `otool -L apt-sortpkgs | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../lib/libapt-pkg-$PKG.dylib apt-sortpkgs


### Now onto methods :(

mv methods/ ../lib/

cd ../lib/methods

for i in ./*; do
  printf "\033[32;1mPatching "`basename $i`"\033[0m\n"
  install_name_tool -change `otool -L $i | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g'` @executable_path/../libapt-pkg-$PKG.dylib $i
done

### Now libraries :(((((( CRRYYYYY

cd ../

for i in ./*.dylib; do
  if [ ! -h $i ]; then
    printf "\033[32;1mPatching "`basename $i`"\033[0m\n"
    if [[ `otool -L $i | grep libapt- | sed 's/\t//g;s/\.dylib.*)/.dylib/g;s/.\/.*.dylib://g'` == *"libapt-pkg"* ]]; then
      install_name_tool -change `otool -L $i | grep libapt-pkg | sed 's/\t//g;s/\.dylib.*)/.dylib/g;s/.\/.*.dylib://g'` @executable_path/../lib/libapt-pkg-$PKG.dylib $i
      printf "\033[32;1m"`basename $i`" patched for libapt-pkg\033[0m\n"
    fi
    if [[ `otool -L $i | grep libapt- | sed 's/\t//g;s/\.dylib.*)/.dylib/g;s/.\/.*.dylib://g'` == *"libapt-private"* ]]; then
      install_name_tool -change `otool -L $i | grep libapt-private | sed 's/\t//g;s/\.dylib.*)/.dylib/g;s/.\/.*.dylib://g'` @executable_path/../lib/libapt-private-$PRIVATE.dylib $i
      printf "\033[32;1m"`basename $i`" patched for libapt-private\033[0m\n"
    fi
    if [[ `otool -L $i | grep libapt- | sed 's/\t//g;s/\.dylib.*)/.dylib/g;s/.\/.*.dylib://g'` == *"libapt-inst"* ]]; then
      install_name_tool -change `otool -L $i | grep libapt-inst | sed 's/\t//g;s/\.dylib.*)/.dylib/g;s/.\/.*.dylib://g'` @executable_path/../lib/libapt-inst-$INST.dylib $i
      printf "\033[32;1m"`basename $i`" patched for libapt-inst\033[0m\n"
    fi
  fi
done
