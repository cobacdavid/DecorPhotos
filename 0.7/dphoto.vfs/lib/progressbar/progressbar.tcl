if {[info exists mprogress::version]} { return }

  namespace eval mprogress \
  {
  # ####################################
  #
  #   mprogress widget
  #
  #   a mapped progress bar
  #
    variable version 1.0
  #
  #   ulis, (C) 2005
  #   NOL Licence
  #
  # ------------------------------------
  # ####################################

    # ==========================
    #
    # package
    #
    # ==========================

    package provide AMappedProgressBar $version

    # package require Tk

    # ====================
    #
    # entry point
    #
    # ====================

    namespace export mprogress

    # ====================
    #
    #   global variables
    #
    # ====================
    variable {}
    array set {} \
    {
      -bg       white
      -coef     1.0
      -fg       #a0ff90
      -height   11
      -percent  0
      -width    100
      -xkeep    8
      -ykeep    1
      -bmap
      {
        00
        d67d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7dd6
        61ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff61
        61ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff61
        61ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff61
        61efefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefefef61
        61d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d3d361
        61b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b7b761
        61cececececececececececececececececececececececececececececececececececececececececececececececece61
        61dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd61
        61eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee61
        d6616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161d6
      }
      -fmap
      {
        00
        d67d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7d7dd6
        f3d6cbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbcbd6ff
        d6fdfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdd6
        c4ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc4
        c4fff5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5f5ffc4
        c4776a7a86818a909298a2a8aeb6bcc4c8d0d6dadee1e4e9eeeeefeae5e0dbd6d0c8c4bcb6aea8a29892908a81867a6a77c4
        c4716362676c7075777c838b91989ea3a6aaabaaaeadafb2b5b5b6b3b0afababaaa7a39e98928b847c7775706c67626371c4
        c4ab9d9091888280838385918e8e8a8785868687868a878b9393948e8d8887868685878a8e8e9185838380828891909dabc4
        c7d7e3e4e5e6e7e8e9eaeaebebebebebebebebebebebebebebebebebebebebebebebebebebebebeaeae9e8e7e6e5e4e3d6c7
        eac1b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3c1ff
        d6616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161616161d6
      }
    }

    # ====================
    #
    #   mprogress proc
    #
    # ====================

    proc mprogress {args} \
    {
      #puts "mprogress $args"
      set cmd [lindex $args 0]
      set rc [catch \
      {
        switch -glob -- $cmd \
        {
          cre*    { uplevel 1 mprogress::mprogress:create $args }
          get     { uplevel 1 mprogress::mprogress:get $args }
          set     { uplevel 1 mprogress::mprogress:set $args }
          default { uplevel 1 mprogress::mprogress:create create $args }
        }
      } msg]
      if {$rc == 1} { return -code error $msg } \
      else { return $msg }
    }

    # ====================
    #
    #   get proc
    #
    # ====================

    proc mprogress:get {get args} \
    {
      #puts "mprogress:get $get $args"
      variable {}
      set count [llength $args]
      if {$count == 0} \
      {
        set result [list]
        foreach name [lsort [array names {} -*]] \
        { lappend result $name }
        return $result
      }
      if {$count != 1} \
      { error "use is 'mprogress get ?-option?'" }
      set key [lindex $args 0]
      switch -glob -- $key \
      {
        -bac*     -
        -bg       { set (-bg) }
        -bma*     { set (-bmap) }
        -coe*     { set (-coef) }
        -for*     -
        -fg       { set (-fg) }
        -fma*     { set (-fmap) }
        -hei*     { set (-height) }
        -per*     { set (-percent) }
        -wid*     { set (-width) }
        -xke*     { set (-xkeep) }
        -yke*     { set (-ykeep) }
        default \
        { error "unknown mprogress default '$key'" }
      }
    }

    # ====================
    #
    #   set proc
    #
    # ====================

    proc mprogress:set {set args} \
    {
      #puts "mprogress:set $set $args"
      variable {}
      set count [llength $args]
      if {$count == 0} \
      {
        set result [list]
        foreach name [lsort [array names {} -*]] \
        { lappend result $name $($name) }
        return $result
      }
      if {$count % 2 != 0} \
      { error "use is 'mprogress set ?-option value?...'" }
      foreach {key value} $args \
      {
        switch -glob -- $key \
        {
          -bac*     -
          -bg       { set (-bg) $value }
          -bma*     { set (-bmap) $value }
          -coef     { set (-coef) $value }
          -for*     -
          -fg       { set (-fg) $value }
          -fma*     { set (-fmap) $value }
          -hei*     { set (-height) $value }
          -per*     { set (-percent) $value }
          -wid*     { set (-width) $value }
          -xke*     { set (-xkeep) $value }
          -yke*     { set (-ykeep) $value }
          default \
          { error "unknown progress default '$key'" }
        }
      }
    }

    # ====================
    #
    #   create proc
    #
    # ====================

    proc mprogress:create {create w args} \
    {
      #puts "mprogress:create $create $w $args"
      variable {}
      # set default values
      set default [list]
      foreach key [array names {}] \
      {
        set ($w:$key) $($key)
        lappend default $key $($key)
      }
      # create progress bar
      set ($w:-image) [image create photo]
      label $w -image $($w:-image) -bd 0 -highlightt 0
      # create reference
      rename $w mprogress::_$w
      interp alias {} ::$w {} mprogress::mprogress:dispatch $w
      # init options
      set ($w:current) 0
      set ($w:init) 1
      eval mprogress:config $w config $default
      if {$args != ""} { eval mprogress:config $w config $args }
      # return reference
      return $w
    }

    # ====================
    #
    #   dispatch proc
    #
    # ====================

    proc mprogress:dispatch {w args} \
    {
      #puts "mprogress:dispatch $w $args"
      set cmd [lindex $args 0]
      set rc [catch \
      {
        switch -glob -- $cmd \
        {
          cge*    { uplevel 1 mprogress::mprogress:cget $w $args }
          con*    { uplevel 1 mprogress::mprogress:config $w $args }
          default \
          { error "unknown mprogress operation '$cmd'" }
        }
      } msg]
      if {$rc == 1} { return -code error $msg } \
      else { return $msg }
    }

    # ====================
    #
    #   cget proc
    #
    # ====================

    proc mprogress:cget {w cget args} \
    {
      #puts "mprogress:cget $cget $w $args"
      variable {}
      set count [llength $args]
      if {$count == 0} \
      {
        set result [list]
        foreach name [lsort [array names {} $w:-*]] \
        { lappend result $name }
        return $result
      }
      if {$count != 1} \
      { error "use is 'path cget ?-option?'" }
      set key [lindex $args 0]
      switch -glob -- $key \
      {
        -bac*     -
        -bg       { set ($w:-bg) }
        -bma*     { set ($w:-bmap) }
        -coe*     { set ($w:-coef) }
        -for*     -
        -fg       { set ($w:-fg) }
        -fma*     { set ($w:-fmap) }
        -hei*     { set ($w:-height) }
        -ima*     -
        -img      { set ($w:-image) }
        -per*     { set ($w:-percent) }
        -wid*     { set ($w:-width) }
        -xke*     { set ($w:-xkeep) }
        -yke*     { set ($w:-ykeep) }
        default   { mprogress::_$w cget $key }
      }
    }

    # ====================
    #
    #   config proc
    #
    # ====================

    proc mprogress:config {w config args} \
    {
      #puts "mprogress:config $config $w $args"
      variable {}
      set count [llength $args]
      if {$count == 0} \
      {
        set result [list]
        foreach name [lsort [array names {} $w:-*]] \
        { lappend result $name $($name) }
        return $result
      }
      if {$count % 2 != 0} \
      { error "use is 'path config ?-option value?...'" }
      set _w mprogress::_$w
      set mflag 0
      if {$($w:init)} { set mflag 1; set ($w:init) 0 }
      set fflag 0
      set miflag 0
      set fiflag 0
      foreach {key value} $args \
      {
        switch -glob -- $key \
        {
          -bac*     -
          -bg       { set ($w:-bg) $value; set miflag 1 }
          -bma*     { set ($w:-bmap) $value; set iflag 1 }
          -coef     { set ($w:-coef) $value; set iflag 1 }
          -for*     -
          -fg       { set ($w:-fg) $value; set fiflag 1 }
          -fma*     { set ($w:-fmap) $value; set fflag 1 }
          -hei*     { set ($w:-height) $value; set mflag 1 }
          -ima*     -
          -img      { set ($w:-image) $value }
          -per*     { set ($w:-percent) $value; set fiflag 1 }
          -wid*     { set ($w:-width) $value; set mflag 1 }
          -xke*     { set ($w:-xkeep) $value }
          -yke*     { set ($w:-ykeep) $value }
          default   { mprogress::_$w config $key $value }
        }
      }
      if {$mflag} \
      {
        set miflag 1
        set bmap $($w:-bmap)
        set fmap $($w:-fmap)
        # change background map width
        set bwidth [string length [lindex $bmap 1]]
        if {$bwidth != $($w:-width) * 2} \
        { set ($w:-bmap) [xsizemap $bmap $($w:-width) $($w:-xkeep)] }
        # change background map height
        set bheight [llength $bmap]; incr bheight -1
        if {$bheight != $($w:-height)} \
        { set ($w:-bmap) [ysizemap $($w:-bmap) $($w:-height) $($w:-ykeep)] }
        # change foreground map height
        set fheight [llength $fmap]; incr fheight -1
        if {$fheight != $($w:-height)} \
        { set ($w:-fmap) [ysizemap $fmap $($w:-height) $($w:-ykeep)] }
      }
      if {$miflag} \
      {
        set fiflag 1
        # update background image
        set img $($w:-image)
        $img config -width $($w:-width) -height $($w:-height)
        set bimg [map2img $($w:-bmap) $($w:-bg) $($w:-fg) $($w:-coef)]
        $img copy $bimg
        image delete $bimg
      }
      if {$fflag && !$mflag} \
      {
        set fiflag 1
        # change foreground map height
        set fmap $($w:-fmap)
        set height [llength $fmap]; incr height -1
        if {$height != $($w:-height)} \
        { set ($w:-fmap) [ysizemap $fmap $($w:-height) $($w:-ykeep)] }
      }
      if {$fiflag} \
      {
        # update foreground image
        set fwidth $($w:current)
        set iwidth [expr {round($($w:-width) * $($w:-percent) / 100.0)}]
        if {$fwidth != $iwidth} \
        {
          set ($w:current) $iwidth
          set fmap [xsizemap $($w:-fmap) $iwidth $($w:-xkeep)]
          set fimg [map2img $fmap $($w:-fg) $($w:-fg) $($w:-coef)]
          $($w:-image) copy $fimg
          image delete $fimg
        }
      }
    }

    # -----------------
    #
    # create a photo from a map
    #
    # -----------------

    proc map2img {map {bg white} {fg gray} {coef 1.0}} \
    {
      # v 2.3
      # get data
      set data [list]
      set line0 [lindex $map 0]
      set td [string range $line0 0 1]
      set fd [string range $line0 2 3]
      if {$fd != "" && $fd != $td} \
      {
        foreach {r g b} [winfo rgb . $fg] break
        foreach c {r g b} \
        {
          set v [set $c]
          set $c [expr {$v / 256}]
        }
        set fg [format #%2.2x%2.2x%2.2x $r $g $b]
      }
      foreach {R G B} [winfo rgb . $bg] break
      foreach C {R G B} \
      {
        set v [set $C]
        set $C [expr {$v / 256.0}]
      }
      # create pixels map & register transparency
      set data [list]
      set trlist [list]
      set map [lrange $map 1 end]
      set y 0
      foreach line $map \
      {
        set x 0
        set row [list]
        foreach {pix1 pix2} [split $line {}] \
        {
          switch -exact -- $pix1$pix2 \
            $td     { set color #000000; lappend trlist $x $y } \
            $fd     { set color $fg }  \
            default \
            {
              set m [expr 0x$pix1$pix2 * $coef / 255.0]
              set nsl [list]
              set sv 0
              foreach C {R G B} c {r g b} \
              {
                set v [set $C]
                set v [expr {round($v * $m)}]
                if {$v > 255} \
                { incr sv $v; incr sv -255; set v 255 } \
                else { lappend nsl $c }
                set $c $v
              }
              set nsl [list]
              if {[llength $nsl] == 2} \
              {
                set nsl2 [list]
                set sv2 0
                foreach c $nsl \
                {
                  set v [set $c]
                  set v [expr {int($v + $sv * 0.75)}]
                  if {$v > 255} \
                  { incr sv2 $v; incr sv2 -255; set v 255 } \
                  else { lappend nsl2 $c }
                  set $c $v
                }
                set nsl $nsl2
                set sv $sv2
              }
              if {[llength $nsl] == 1} \
              {
                set c [lindex $nsl 0]
                set v [set $c]
                incr v [expr {int($sv * 0.75)}]
                if {$v > 255} { set v 255 }
                set $c $v
              }
              set color [format #%2.2x%2.2x%2.2x $r $g $b]
            }
          lappend row $color
          incr x
        }
        lappend data $row
        incr y
      }
      # create photo
      set photo [image create photo]
      $photo put $data
      # set transparency
      foreach {x y} $trlist \
      { $photo transparency set $x $y 1 }
      # return photo
      return $photo
    }

    # -----------------
    #
    # x-size a map
    #
    # -----------------

    proc xsizemap {map width {keep 4}} \
    {
      #puts "xsizemap map $width $keep"
      set map2 [lrange $map 0 0]
      if {$width > 0} \
      {
        # computation
        set maxy [llength $map]; incr maxy -1
        set maxx_2 [string length [lindex $map 1]]
        set maxx [expr {$maxx_2 / 2}]
        # check wanted against owned
        if {$width < $maxx} \
        {
          # shrink
          if {$width < 2 * $keep} \
          {
            # xtrem shrink
            set keep1 [expr {$width / 2}]
            set keep2 [expr {$width - $keep1}]
            set keep1_2 [expr {($keep1 * 2) - 1}]
            set keep2_2 [expr {($keep2 * 2) - 1}]
            for {set i 1} {$i <= $maxy} {incr i} \
            {
              # keep only first & last
              set line [lindex $map $i]
              set line2 [string range $line 0 $keep1_2]
              append line2 [string range $line end-$keep2_2 end]
              lappend map2 $line2
            }
          } \
          else \
          {
            # normal shrink
            set keep1 [expr {$keep * 2 - 1}]
            set step [expr {double($maxx - 2 * $keep) / ($maxx - $width + 1)}]
            set list [list 0 $keep1]
            set ip $keep
            set p $keep
            # suppress chars between line[keep] & line[end-keep]
            while {($p + $step + 1 - $maxx + $keep) < 1.e-5} \
            {
              set iq [expr {int(ceil($p + $step - 1))}]
              lappend list [expr {round($ip) * 2}] [expr {1 + round($iq) * 2}]
              while {($p + $step - $iq - 1) < 1.e-5} \
              {
                lappend list del -
                set p [expr {$p + $step}]
              }
              set ip [incr iq]
            }
            lappend list [expr {round($ip) * 2}] end
            for {set i 1} {$i <= $maxy} {incr i} \
            {
              set line [lindex $map $i]
              set line2 ""
              foreach {i1 i2} $list \
              {
                if {$i1 == "del"} { set line2 [string range $line2 0 end-2] } \
                else              { append line2 [string range $line $i1 $i2] }
              }
              lappend map2 $line2
            }
          }
        } \
        elseif {$width == $maxx} \
        {
          # copy
          set map2 $map
        } \
        else \
        {
          # extend
          set keep1 [expr {$keep * 2 - 1}]
          set map2 [lindex $map 0]
          set step [expr {double($maxx - 2 * $keep) / ($width - $maxx)}]
          set list [list 0 $keep1]
          set ip $keep
          set p $keep
          # intersperse new chars between line[$keep] & line[end-$keep]
          while {($p + $step - $maxx + $keep) < 1.e-5} \
          {
            set iq [expr {int(ceil($p + $step - 1))}]
            lappend list [expr {round($ip) * 2}] [expr {1 + round($iq) * 2}]
            while {($p + $step - $iq - 1) < 1.e-5} \
            {
              lappend list dup -
              set p [expr {$p + $step}]
            }
            set ip [incr iq]
          }
          lappend list [expr {round($ip) * 2}] end
          for {set i 1} {$i <= $maxy} {incr i} \
          {
            set line [lindex $map $i]
            set line2 ""
            foreach {i1 i2} $list \
            {
              if {$i1 == "dup"} { append line2 [string range $line2 end-1 end] } \
              else              { append line2 [string range $line $i1 $i2] }
            }
            lappend map2 $line2
          }
        }
      }
      return $map2
    }

    # -----------------
    #
    # y-size a map
    #
    # -----------------

    proc ysizemap {map height {keep 4}} \
    {
      set map2 [lrange $map 0 0]
      if {$height > 0} \
      {
        # computation
        set maxy [llength $map]; incr maxy -1
        # check wanted against owned
        if {$height < $maxy} \
        {
          # shrink
          if {$height < 2 * $keep} \
          {
            # xtrem shrink
            set keep1 [expr {$width / 2}]
            set keep2 [expr {$width - $keep1}]
            # keep only first & last
            lappend map2 [lrange $map 0 $keep1]
            lappend map2 [lrange $map end-$keep2 end]
          } \
          else \
          {
            # normal shrink
            set map2 [concat $map2 [lrange $map 1 $keep]]
            set keep1 [expr {$keep + 1}]
            set step [expr {double($maxy - 2 * $keep) / ($maxy - $height + 1)}]
            set ip $keep1
            set p $keep1
            # intersperse new lines between [lindex $map $keep] & [lindex $map end-$keep1]
            while {($p + $step - $maxy + $keep) < 1.e-5} \
            {
              set iq [expr {int(ceil($p + $step - 1))}]
              set map2 [concat $map2 [lrange $map $ip $iq]]
              while {($p + $step - $iq - 1) < 1.e-5} \
              {
                set map2 [lrange $map2 0 end-1]
                set p [expr {$p + $step}]
              }
              set ip [incr iq]
            }
            set map2 [concat $map2 [lrange $map $ip end]]
          }
        } \
        elseif {$height == $maxy} \
        {
          # copy
          set map2 $map
        } \
        elseif {$height > $maxy} \
        {
          # extend
          set map2 [concat $map2 [lrange $map 1 $keep]]
          set keep1 [expr {$keep + 1}]
          set step [expr {double($maxy - 2 * $keep) / ($height - $maxy)}]
          set ip $keep1
          set p $keep1
          # intersperse new lines between map[keep] & map[end-keep]
          while {($p + $step - 1 - $maxy + $keep) < 1.e-5} \
          {
            set iq [expr {int(ceil($p + $step - 1))}]
            set map2 [concat $map2 [lrange $map $ip $iq]]
            while {($p + $step - $iq - 1) < 1.e-5} \
            {
              lappend map2 [lindex $map2 end]
              set p [expr {$p + $step}]
            }
            set ip [incr iq]
          }
          set map2 [concat $map2 [lrange $map $ip end]]
        }
      }
      return $map2
    }

  }

  namespace import mprogress::mprogress
