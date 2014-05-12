# auteur : david cobac [string map {# @} david.cobac#gmail.com]
# date   : 10/05/2014
#

# ici un peu de POO ne serait pas du luxe !!
package provide luaqrencode 1.0

namespace eval ::luaqrencode {
    file copy -force [file join $::topdir lib qrencode qrencode.lua] /tmp
    file copy -force [file join $::topdir lib qrencode luaqrencode.lua] /tmp
    variable qrText
    variable qrCode
    variable qrDim
}

proc ::luaqrencode::qrEncode {} {
    variable qrText
    variable qrCode
    variable qrDim

    set qrCode [split [exec lua [file join /tmp luaqrencode.lua] $qrText] \n]
    set qrDim [string length [lindex $qrCode 0]]
    return $qrCode
}

proc ::luaqrencode::setText { texte } {
    variable qrText
    variable qrDim
    variable qrCode

    set qrCode ""
    set qrDim    0
    set qrText   $texte
    return $qrText
}

proc ::luaqrencode::getDim { } {
    variable qrDim

    return $qrDim
}

proc ::luaqrencode::qrcode2bitmap {  } {
    variable qrDim
    variable qrCode

    set name dphotoqrcode
    set list [list]
    foreach line $qrCode \
    {
      while {$line ne ""} \
      {
        # decoupage par groupe de 8
        set bits [string range $line 0 7]
        set line [string range $line 8 end]
        # digit2hexa
        set hexa 0
        while {$bits ne ""} \
        {
          set bit [string index $bits end]
          set bits [string range $bits 0 end-1]
          incr hexa $hexa ;# multiplication par deux
          incr hexa $bit ;# ajout du bit
        }
        lappend list 0x[format %2.2x $hexa]
      }
    }
    # mise en forme
    set result ""
    append result "#define ${name}_width $qrDim\n"
    append result "#define ${name}_height $qrDim\n"
    append result "static unsigned char ${name}_bits\[] = {\n"
    append result [join $list ", "]
    append result "};"
    return $result
}

