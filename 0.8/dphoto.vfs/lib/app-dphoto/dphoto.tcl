package provide app-dphoto 1.0

# auteur : david cobac [string map {# @} david.cobac#gmail.com]
# date   : 29/04/2010
# rev    : 05/05/2014

# fake namespaces as this was not meant to be published...
# version 1.0 will need to fix this !

# utilisé pour centrer la photo sur le canvas
proc canvas:centrage {wCV hCV wWand hWand} {
    set x [expr { ($wCV - $wWand ) / 2}]
    set y [expr { ($hCV - $hWand ) / 2}]
    return [list $x $y]
}

# utilisé pour attribuer à la variable 'user' les valeurs par défaut
proc config:copie {} {
    global {}

    foreach {k v} [array get {}] {
	set (user:${k}) $v
    }
}

# utilisé pour revenir aux valeurs par défaut
proc config:defaut {} {
    global {}

    foreach {k v} [array get {}] {
	if {![regexp {user:(.*)} $k -> l]} continue
	set (${k}) [set (${l})]
    }
}

# lecture du fichier de configuration
proc config:lecture {} {
    global {}
    
    if {[file exists $(user:fRc)]} {
	uplevel #0 source $(user:fRc)
    }
}

# enregistrement des valeurs de la variable 'user'
proc config:enregistrement {} {
    global {}
    
    set h [open $(user:fRc) w+]
    foreach {k v} [array get {} user:*] {
	puts $h "set (${k})\t\t[list $v]"
    }
    close $h
}

##
##

# callback gui 
proc callback:choixRep {wentry v} {
    global {}
    
    set dir [tk_chooseDirectory -parent . -title "Choisir le r\u00e9pertoire"]
    if {[file isdirectory $dir]} {
	$wentry delete 0 end
	$wentry insert end $dir
	set [set v] $dir
    }
}

# callback gui
proc callback:choixRepS {wentry} {
    global {}
    set (user:dOut) [$wentry get]
}

# callback gui
proc callback:choixLog {wentry} {
    global {}

    set type {
	{{Fichier jpg} {.jpg}} {{Fichier png} {.png}} {{Tous les fichiers} {.*}}
    }
    set dir [file normalize [file dirname $(user:fLogo)]]
    set f [tk_getOpenFile -initialdir $dir -filetypes $type]
    if {[file exists $f]} {
	$wentry delete 0 end
	$wentry insert end $f
	set (user:fLogo) $f
    }
}

# callback gui
proc callback:choixCoul {wlabel var} {
    global {}
    
    set c [tk_chooseColor -initialcolor [set $var]]
    if {$c ne ""} {
	set $var $c
    }
    $wlabel configure -bg [set $var]
}

# callback gui
# lance l'application des changements sur une image ou sur une collection
proc callback:okay {wdImages wfLogo wdOut wfOut wlignes wtPolice wtLine wtLogo wmultiT wbutton {test 0}} {
    global {} Theme fDPhoto gui:multiThemes exif
    
    set (user:dImages) [$wdImages get]
    set (user:fLogo)   [$wfLogo   get]
    set (user:dOut)    [$wdOut    get]
    set (user:fOut)    [$wfOut    get]
    set (user:lignes)  [$wlignes  get]
    set (user:tPolice) [$wtPolice get]
    set (user:tLine)   [$wtLine   get]
    set (user:tLogo)   [$wtLogo   get]
    set (user:multiT)  [$wmultiT  get]

    ### vérifications avant traitement
    if {$(user:dImages) eq "" || $(user:fOut) eq ""} {return}
    if {![file exists $(user:dImages)]} {return}
    if {![file exists $(user:fLogo)]} {return}
    ###
    cd $(user:dImages)
    set listeJPG [glob -nocomplain *.jpg]
    ### mode test : une seule image, la première
    if {$test eq 1} {
	set listeJPG [lindex $listeJPG 0]
    }
    ###
    set nbFic [llength $listeJPG]
    if { $nbFic eq 0} {
	tk_messageBox -icon info -message "Pas de fichiers jpg trouv\u00e9s.
V\u00e9rifier que le r\u00e9pertoire choisi contienne bien ce type de fichiers."
	return
    }
    ####
    # si un fichier dphoto.txt existe -> on le prend en compte
    set f [file join $(user:dImages) $(user:dOut) dphoto.txt]
    # on ne le fait pas pour les tests
    if {[file exists $f] & $test eq 0} {
	set hf [open $f r]
	while {![eof $hf]} {
	    gets $hf ligne
	    # chaque ligne est  associé à une image et un texte particuliers
	    if {$ligne ne ""} {
		regexp {(.*)\t(.*)} $ligne -> f l
		set inFile $f
		set (user:lignes) [string trim $l \{\}]
		setExifInfo $inFile
		source $fDPhoto
	    }
	}
	close $hf
    } else {
	# sans fichier dphoto.txt on applique
	# le même traitement à toutes les images
	foreach inFile $listeJPG {
	    setExifInfo $inFile
	    source $fDPhoto
	}
    }
}

# callback gui
proc callback:exit {} {
    config:enregistrement
    exit
}

# callback gui
proc callback:defaut {} {
    config:defaut
    config:enregistrement
    tk_messageBox -icon info -message "L'application va se fermer.
Veuillez red\u00e9marrer pour prendre en compte l'action."
    exit
}

# callback gui
proc callback:theme {wmenubutton n} {
    global {} Theme

    set (user:choixTheme) $n
    $wmenubutton configure -text [lindex [set Theme($n)] 0]
}

# callback gui
proc callback:genF {wB args} {
    global {} gui:genF

    if {${gui:genF} eq 0} {
	foreach w $args {
	    $w configure -state normal
	}
	$wB configure -state disabled
    } else {
	foreach w $args {
	    $w configure -state disabled
	}
	$wB configure -state normal
    }
}

#callback gui
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
    # lecture du fichier s'il existe
    # on récupère les données, on ne les écrasera pas
    # par l'écriture...
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
    # écriture du fichier
    # seules les nouvelles images (si dphoto.txt existait)
    # prennent le texte de l'interface
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
###

# procédure utilisée ??? à vérifier
proc verif:existRep {d} {
    return [file isdirectory $d]
}

# rafraîchissement de l'affichage des entry
proc affValeurEntry {wentry valeur} {
    global {}

    $wentry delete 0 end
    $wentry insert end $valeur
}

# construction du menubutton Thème
proc nomTheme {wmenubutton} {
    global {} Theme

    set m $wmenubutton.m  
    menu $m -tearoff 0
    $wmenubutton configure -menu $m 

    for {set i 0} {$i<[array size Theme]} {incr i} {
	$m add command -label "Thème $i : [lindex [set Theme($i)] 0]" -command [list callback:theme $wmenubutton $i]
    }
    # on sélectionne le premier thème au démarrage
    $wmenubutton configure -text [lindex $Theme($(user:choixTheme)) 0]
}

proc nommodeLogo {wmenubutton} {
    global {}
    set m $wmenubutton.m  
    menu $m -tearoff 0
    $wmenubutton configure -menu $m 
    set modes [list "undefined"  "over"  "in"  "out"  "atop"  "xor"  "plus"  "minus"  "add"  "subtract"  "difference"  "multiply"  "bumpmap"  "copy"  "copyred"  "copygreen"  "copyblue"  "copyopacity"  "clear"  "dissolve"  "displace"  "modulate"  "threshold"  "no"  "darken"  "lighten"  "hue"  "saturate"  "colorize"  "luminize"  "screen"  "overlay"  "copycyan"  "copymagenta"  "copyyellow"  "copyblack"  "replace"]
    
    foreach mode $modes {
	$m add command -label $mode -command "$wmenubutton configure -text $mode;set (user:modeLogo) $mode"
    }
    # on sélectionne le premier thème au démarrage
    $wmenubutton configure -text $(user:modeLogo)
}

proc setExifInfo {f} {
    global exif
    foreach {k v} [jpeg::formatExif [jpeg::getExif $f]] {
	# on récupère tout de toutes façons...pour l'avoir et
	# pour éventuellement l'utiliser dans le texte !!
	# Il faudrait penser pouvoir récupérer tout cela
	# dans l'interface graphique
	set exif($k) $v
	# priorité : on récupère date et heure
	if {$k eq "DateTimeOriginal"} {
	    regexp {([0-9]{4}):([0-9]+):([0-9]+)\
			([0-9]+):([0-9]+):([0-9]+)} $v -> y m d H M S
	    set exif(date)  "$d/$m/$y"
	    set exif(heure) ${H}:${M}:${S}
	    # l'option locale n'est pas forcément prise ne compte
	    # cela dépend de la version de Tcl
	    set exif(mois) [clock format [clock scan "$y$m$d $exif(heure)"]\
				-format %B -locale fr]
	    set exif(Mois) [string toupper $exif(mois) 0 0]
	    # on récupère ensuite l'orientation
	    # pour pouvior la changer
	} elseif {$k eq "Orientation"} {
	    set exif(normal) [string equal $v "normal"]
	    if [string equal $v "90 degrees cw"] {
		set exif(angle) 90
	    } elseif [string equal $v "90 degrees ccw"] {
		set exif(angle) -90
	    }
	}
    }
}

##################################################################
##################################################################

set r [file normalize [file dirname [info nameofexecutable]]]
set h [file normalize $::env(HOME)]
# valeurs par défaut
array set {} "
    couleur    white
    couleurf   black
    choixTheme 0
    lignes     {le \$exif(date) \u00e0 \$exif(heure)\\n\u00a9 http://github.com/cobacdavid}
    dImages    $r
    dOut       dphoto
    tLogo      200
    tLine      2
    tPolice    60*
    fOut       perso_\$inFile
    fLogo      [file join $r logo.jpg]
    fPolice    Courier
    fRc        [file join $h decorphoto.rc]
    multiT     {}
    modeLogo   over
"
# on attribue ces valeurs à la variable 'user'
config:copie
# on lit les valeurs enregistrées dans le fichier RC
config:lecture
############
source $fGUI
############
