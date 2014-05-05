package provide app-dphoto 1.0

# auteur : david cobac [string map {# @} david.cobac#gmail.com]
# date   : 29/04/2010
# rev    : 05/05/2014

# fake namespaces as this was not meant to be published...
# version 1.0 will need to fix this !

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

# callback gui
proc callback:choixCoul {wlabel} {
    global {}
    
    set c [tk_chooseColor -initialcolor $(user:couleur)]
    if {$c ne ""} {
	set (user:couleur) $c
    }
    $wlabel configure -bg $(user:couleur)
}

# callback gui
# lance l'application des changements sur une image ou sur une collection
proc callback:okay {wentryRep wentryLog wentryRepS wentryOut wentryLin wentryTPol wbutton {test 0}} {
    global {} Theme fDPhoto
    
    set (user:dImages) [$wentryRep get]
    set (user:fLogo)   [$wentryLog get]
    set (user:dOut)    [$wentryRepS get]
    set (user:fOut)    [$wentryOut get]
    set (user:lignes)  [$wentryLin get]
    set (user:tPolice) [$wentryTPol get]
    
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
		source $fDPhoto
	    }
	}
	close $hf
    } else {
	# sans fichier dphoto.txt on applique
	# le même traitement à toutes les images
	foreach inFile $listeJPG {
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
proc callback:genF {wEL wES wEPL wETP wEH wLCC wBR wBT wBTC} {
    global {} gui:genF

    if {${gui:genF} eq 0} {
	foreach w [list $wEL $wES $wEPL $wETP $wEH $wLCC $wBT $wBTC] {
	    $w configure -state normal
	}
	$wBR configure -state disabled
    } else {
	foreach w [list $wEL $wES $wEPL $wETP $wEH $wLCC $wBT $wBTC] {
	    $w configure -state disabled
	}
	$wBR configure -state normal
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
    set (user:choixTheme) 0
    $wmenubutton configure -text [lindex $Theme(0) 0]
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
    lignes     {le \$date \u00e0 \$heure\\n\u00a9 http://github.com/cobdav}
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
# on attribue ces valeurs à la variable 'user'
config:copie
# on lit les valeurs enregistrées dans le fichier RC
config:lecture
############
source $fGUI
############
