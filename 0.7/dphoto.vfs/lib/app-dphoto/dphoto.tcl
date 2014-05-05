package provide app-dphoto 1.0

#!/bin/sh
# -*-Tcl-*-
# The next line restarts using tclsh \
exec etcl "$0" -- ${1+"$@"}


# auteur : david cobac [string map {# @} david.cobac#gmail.com]
# date   : 29/04/2010
# rev    : 14/05/2010

###

proc config:copie {} {
    global {}

    foreach {k v} [array get {}] {
	set (user:${k}) $v
    }
}

proc config:defaut {} {
    global {}

    foreach {k v} [array get {}] {
	if {![regexp {user:(.*)} $k -> l]} continue
	set (${k}) [set (${l})]
    }
}

proc config:lecture {} {
    global {}
    
    if {[file exists $(user:fRc)]} {
	uplevel #0 source $(user:fRc)
    }
}

proc config:enregistrement {} {
    global {}
    
    set h [open $(user:fRc) w+]
    foreach {k v} [array get {} user:*] {
	puts $h "set (${k})\t\t[list $v]"
    }
    close $h
}


###
proc callback:choixRep {wentry v} {
    global {}
    
    set dir [tk_chooseDirectory -parent . -title "Choisir le r\u00e9pertoire"]
    if {[file isdirectory $dir]} {
	$wentry delete 0 end
	$wentry insert end $dir
	set [set v] $dir
    }
}

proc callback:choixRepS {wentry} {
    global {}
    set (user:dOut) [$wentry get]
}

proc callback:choixLog {wentry} {
    global r {}

    set type {
	{{Fichier jpg} {.jpg}} {{Tous les fichiers} {.*}}
    }
    set f [tk_getOpenFile -initialdir $r -filetypes $type]
    if {[file exists $f]} {
	$wentry delete 0 end
	$wentry insert end $f
	set (user:fLogo) $f
    }
}

proc callback:choixCoul {wlabel} {
    global {}
    
    set c [tk_chooseColor -initialcolor $(user:couleur)]
    if {$c ne ""} {
	set (user:couleur) $c
    }
    $wlabel configure -bg $(user:couleur)
}

# proc callback:choixPol {wentry} {
#     global {}

#     set type {
# 	{{Fichier ttf} {.ttf}}
# 	{{Tous les fichiers} {.*}}
#     }
#     set p [tk_getOpenFile -initialdir [file dirname $(user:fPolice)] -filetypes $type]
#     if {$p ne ""} {
# 	set (user:fPolice) $p
# 	$wentry delete 0 end
# 	$wentry insert end $p
#     }
# }

proc callback:okay {wentryRep wentryLog wentryRepS wentryOut wentryLin wentryTPol wbutton {test 0}} {
    global {} Theme fDPhoto
    
    set (user:dImages) [$wentryRep get]
    set (user:fLogo)    [$wentryLog get]
    set (user:dOut)    [$wentryRepS get]
    set (user:fOut)    [$wentryOut get]
    set (user:lignes)  [$wentryLin get]
    #set (user:fPolice) [$wentryPol get]
    set (user:tPolice) [$wentryTPol get]
    
    ### vérifications avant traitement
    if {$(user:dImages) eq "" || $(user:fOut) eq ""} {return}
    if {![file exists $(user:dImages)]} {return}
    if {![file exists $(user:fLogo)]} {return}
    #if {![file exists $(user:fPolice)]} {return}
    ###
    cd $(user:dImages)
    set listeJPG [glob -nocomplain *.jpg]
    # mode test : une seule image, la première
    if {$test eq 1} {
	set listeJPG [lindex $listeJPG 0]
    }
    #
    set nbFic [llength $listeJPG]
    if { $nbFic eq 0} {
	tk_messageBox -icon info -message "Pas de fichiers jpg trouv\u00e9s.
V\u00e9rifier que le r\u00e9pertoire choisi contienne bien ce type de fichiers."
	return
    }

    # si un fichier dphoto.txt existe -> on le prend en compte
    set f [file join $(user:dImages) $(user:dOut) dphoto.txt]
    # on ne le fait pas pour les tests
    if {[file exists $f] & $test eq 0} {
	set hf [open $f r]
	while {![eof $hf]} {
	    gets $hf ligne
	    if {$ligne ne ""} {
		regexp {(.*)\t(.*)} $ligne -> f l
		set inFile $f
		set (user:lignes) [string trim $l \{\}]
		source $fDPhoto
	    }
	}
	close $hf
    } else {
	#set nbFicTraites 0
	foreach inFile $listeJPG {
	    #incr nbFicTraites
	    #$wbutton configure -text "$nbFicTraites traites sur $nbFic"
	    #update
	    source $fDPhoto
	}
    }
    #$wbutton configure -text "Traitement complet"
}

proc callback:exit {} {
    config:enregistrement
    exit
}

proc callback:defaut {} {
    config:defaut
    config:enregistrement
    tk_messageBox -icon info -message "L'application va se fermer.
Veuillez red\u00e9marrer pour prendre en compte l'action."
    exit
}

proc callback:theme {wmenubutton n} {
    global {} Theme

    set (user:choixTheme) $n
    $wmenubutton configure -text [lindex [set Theme($n)] 0]
}

proc callback:genF {wentryRep wentryLog wentryRepS wentryOut wentryLin wentryPol wlabelPol wbuttonGen} {
    global {} gui:genF

    if {${gui:genF} eq 0} {
	foreach w [list $wentryLog $wentryOut $wentryPol $wlabelPol] {
	    $w configure -state normal
	}
	$wbuttonGen configure -state disabled
    } else {
	foreach w [list $wentryLog $wentryOut $wentryPol $wlabelPol] {
	    $w configure -state disabled
	}
	$wbuttonGen configure -state normal
    }
}

proc callback:genereFicTextes {wentryRep wentryRepS wentryL} {
    global {}

    set (user:dImages) [$wentryRep get]
    set (user:dOut)    [$wentryRepS get]
    set (user:lignes)  [$wentryL get]
    if {$(user:dImages) eq ""} {return}
    
    cd $(user:dImages)
    set listeJPG [glob -nocomplain *.jpg]
    if {[llength $listeJPG] eq 0} {
	tk_messageBox -icon info -message "Pas de fichiers jpg trouv\u00e9s.
V\u00e9rifier que le r\u00e9pertoire choisi contienne bien ce type de fichiers."
	return
    }

    file mkdir $(user:dOut)
    cd $(user:dOut)
    if {[file exists dphoto.txt]} {
	set hf [open dphoto.txt r]
	while {![eof $hf]} {
	    gets $hf ligne
	    if {$ligne ne ""} {
		regexp {(.*)\t(.*)} $ligne -> f l
		set fic($f) [string trim $l \{\}]
	    }
	}
	close $hf
    }
    set h [open dphoto.txt w+]
    foreach inFile $listeJPG {
	if {[info exists fic($inFile)]} {
	    puts $h "$inFile\t[list $fic($inFile)]"
	} else {
	    puts $h "$inFile\t[list $(user:lignes)]"
	}
    }
    close $h
}

###

proc verif:existRep {d} {
    return [file isdirectory $d]
}

###
proc affValeurEntry {wentry valeur} {
    global {}

    $wentry delete 0 end
    $wentry insert end $valeur
}

proc nomTheme {wmenubutton} {
    global {} Theme

    set m $wmenubutton.m  
    menu $m -tearoff 0
    $wmenubutton configure -menu $m 

    for {set i 0} {$i<[array size Theme]} {incr i} {
	$m add command -label [lindex [set Theme($i)] 0] -command [list callback:theme $wmenubutton $i]
    }
    set (user:choixTheme) 0
    $wmenubutton configure -text [lindex $Theme(0) 0]
}


##################################################################
##################################################################

# set r [file normalize [file dirname [info script]]]
# set r [file normalize [file join $::etcl::topdir ..]]
set r [file normalize [file dirname [info nameofexecutable]]]
set h [file normalize $::env(HOME)]
# valeurs par défaut
array set {} "
    couleur    white
    couleurf   black
    choixTheme 0
    lignes     {le \$date \u00e0 \$heure\\nAngers}
    dImages    $r
    dOut       dphoto
    tLogo      200
    tLine      6
    tPolice    60
    fOut       perso_\$inFile
    fLogo      [file join $r logo.jpg]
    fPolice    Courier
    fRc        [file join $h decorphoto.rc]
"

config:copie
config:lecture

###
source $fGUI
###
