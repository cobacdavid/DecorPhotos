# Generic pkgIndex.tcl to automatically determine which dynamic library
# to load according to platform.
switch -glob $::tcl_platform(machine)-$::tcl_platform(os) {
  "x86_64-Linux" {
    # Linux x86_64
    if {[file exists [file join $dir x86_64-linux libpixane.so]]} {
      package ifneeded pixane 0.7 [list load [file join $dir x86_64-linux libpixane.so]]
    }
  }
  "i*86-Linux" {
    # Linux x86
    if {[file exists [file join $dir i686-linux libpixane.so]]} {
      package ifneeded pixane 0.7 [list load [file join $dir i686-linux libpixane.so]]
    }
  }
  "arm*-Linux" {
    # Linux arm
    if {[file exists [file join $dir arm-linux libpixane.so]]} {
      package ifneeded pixane 0.7 [list load [file join $dir arm-linux libpixane.so]]
    }
  }
  "ppc-Linux" -
  "ppc64-Linux" {
    # Linux powerpc
    if {[file exists [file join $dir ppc-linux libpixane.so]]} {
      package ifneeded pixane 0.7 [list load [file join $dir ppc-linux libpixane.so]]
    }
  }
  "mips-Linux" {
    # Linux mipsel
    if {[file exists [file join $dir mipsel-linux libpixane.so]]} {
      package ifneeded pixane 0.7 [list load [file join $dir mipsel-linux libpixane.so]]
    }
  }
  "*-Darwin" {
    if {[file exists [file join $dir darwin libpixane.dylib]]} {
      # Mac OS X (Universal binary)
      package ifneeded pixane 0.7 [list load [file join $dir darwin libpixane.dylib]]
    } else {
      switch -glob -- $::tcl_platform(machine) {
	"ppc" -
	"Power*" {
	  # Mac OS X PowerPC    
	  if {[file exists [file join $dir ppc-darwin libpixane.dylib]]} {
	    package ifneeded pixane 0.7 [list load [file join $dir ppc-darwin libpixane.dylib]]
	  }
	}
	"i*86" {
	  # Mac OS X x86 
	  if {[file exists [file join $dir i686-darwin libpixane.dylib]]} {
	    package ifneeded pixane 0.7 [list load [file join $dir i686-darwin libpixane.dylib]]
	  }
	}
      }
    }      
  }
  "arm-Windows CE" {
    # Windows Mobile
    if {$::tcl_platform(osVersion)<4.0} {
      if {[file exists [file join $dir arm-wce3 libpixane.dll]]} {
	package ifneeded pixane 0.7 [list load [file join $dir arm-wce3 libpixane.dll]]
      }
    } else {
      if {[file exists [file join $dir arm-wince libpixane.dll]]} {
	package ifneeded pixane 0.7 [list load [file join $dir arm-wince libpixane.dll]]
      }
    }
  }
  "intel-Windows*" {
    # MSWin (98, 2k, XP, Vista, ...)
    if {[file exists [file join $dir i686-win32 libpixane.dll]]} {
      package ifneeded pixane 0.7 [list load [file join $dir i686-win32 libpixane.dll]]
    }
  }
  default {
    # Not supported
  }
}

