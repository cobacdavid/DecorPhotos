# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010
# rev    : 05/05/2014

#
# ATTENTION
# dans ce tableau TOUT est lié à la variable ::dphoto::userDefault !!!
#
array set ::dphoto::gui::widgets {
    fontName {key1 font key2 name parent .font name fN type entry options {}}
    fontSize {key1 font key2 size parent .font name fS type entry options {-width 3}}
    fontFg   {key1 font key2 fg   parent .font name fF type label options {-text "Couleur"}}
    fontBg   {key1 font key2 bg   parent .font name fB type label options {-text "Couleur fond"}}
    #
    themeChoice {key1 theme key2 choice parent .theme name tC  type menubutton  options {}}
    themeMulti  {key1 theme key2 multi  parent .theme name tM  type checkbutton options {}}
    themeMultiT {key1 theme key2 multiT parent .theme name tMT type entry       options {}}
    #
    lineFg    {key1 line key2 fg    parent .line name lF type label options {}}
    lineBg    {key1 line key2 bg    parent .line name lB type label options {}}
    lineWidth {key1 line key2 width parent .line name lW type entry options {-width 3}}
    #
    textLignes {key1 text key2 lignes parent .text name tL type entry options {}}
    #
    logoPath {key1 logo key2 path parent .logo name lP type entry      options {}}
    logoSize {key1 logo key2 size parent .logo name lS type entry      options {-width 3}}
    logoMode {key1 logo key2 mode parent .logo name lM type menubutton options {}}
    #
    
}




# utilisé pour centrer la photo sur le canvas
proc dphoto::gui::centrage {wCV hCV wWand hWand} {
    set x [expr { ($wCV - $wWand ) / 2}]
    set y [expr { ($hCV - $hWand ) / 2}]
    return [list $x $y]
}

# w widget entry à compléter
# namet nom du tableau concerné  FQN
# namek nom de la clé à modifier
proc dphoto::gui:setDir {w namet namek} {
    variable ::dphoto::user
    
    set dir [tk_chooseDirectory -parent . -title "Choisir le r\u00e9pertoire"]
    if {[file isdirectory $dir]} {
	$w delete 0 end
	$w insert end $dir
	dict set $namet $namek [list $dir]
    }
}

# w widget entry à récupérer
# namet nom du tableau concerné  FQN
# namek nom de la clé à modifier
# (normalement ici namet est ::dphoto::user(images)
# et namek est relativeoutpath)
proc dphoto::gui::getDir {w namet namek} {
    variable ::dphoto::user
    
    dict set $namet $namek [$w get]
}

# w widget entry à compléter
# namet nom du tableau concerné FQN
# namek nom de la clé à modifier
# (normalement ici namet est ::dphoto::user(logo)
# et namek est path)
proc dphoto::gui::setFile {w namet namek} {
    variable ::dphoto::user

    set type {
	{{Fichier images} {.jpg .png}} {{Tous les fichiers} {.*}}
    }
    set dir [file normalize [file dirname [dict get [set $namet] namek]]]
    set f [tk_getOpenFile -initialdir $dir -filetypes $type]
    if {[file exists $f]} {
	$w delete 0 end
	$w insert end $f
	dict set $namet $namek [list $f]
    }
}

# w widget label à modifier
# namet nom du tableau concerné FQN
# namek nom de la clé à modifier
proc dphoto::gui::setCoul {w namet namek} {
    variable ::dphoto::user
    
    set c [tk_chooseColor -initialcolor [dict get [set $namet] $namek]]
    if {$c ne ""} {
	dict set $namet $namek $c
	$wlabel configure -bg $c
    }
}

# test booléen si on ne teste que sur une photo
proc dphoto::gui::okay {test} {
    variable ::dphoto::user
    variable ::dphoto::gui::

    #set (user:dImages) [$wdImages get]
    dict set ::dphoto::user(images) inpath [$wUserImages get]
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
proc dphoto::gui::exit {} {
    config:enregistrement
    exit
}

# callback gui
proc dphoto::gui::defaut {} {
    config:defaut
    config:enregistrement
    tk_messageBox -icon info -message "L'application va se fermer.
Veuillez red\u00e9marrer pour prendre en compte l'action."
    exit
}

# callback gui
proc dphoto::gui::theme {wmenubutton n} {
    global {} Theme

    set (user:choixTheme) $n
    $wmenubutton configure -text [lindex [set Theme($n)] 0]
}

# callback gui
proc dphoto::gui::genF {wB args} {
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
proc dphoto::gui::genereFicTextes {wentryRep wentryRepS wentryL} {
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
# proc verif:existRep {d} {
#     return [file isdirectory $d]
# }

# rafraîchissement de l'affichage des entry
proc dphoto::gui::affValeurEntry {wentry valeur} {
    global {}

    $wentry delete 0 end
    $wentry insert end $valeur
}

# construction du menubutton Thème
proc dphoto::gui::nomTheme {wmenubutton} {
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

proc dphoto::gui::nommodeLogo {wmenubutton} {
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

proc dphoto::traitement::setExifInfo {f} {
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
######################################################################################""


set f .f
set fT $f.fTexte
set g .g
set h .h
labelframe $f -text Param\u00e8tres
#
checkbutton $f.cbgenF -text "G\u00e9n\u00e9rer le fichier dphoto.txt dans le r\u00e9pertoire\
de sortie" -variable gui:genF -anchor w \
    -command [list callback:genF $f.bgenF $f.efLogo $f.efOut $fT.lcouleur $fT.lcouleurf $f.mbTheme $h.b $g.ok]
button $f.bgenF -text "G\u00e9n\u00e9rer" -command [list callback:genereFicTextes $f.edImages $f.edOut $f.elignes]\
    -state disabled
set w 50
#
label  $f.ldImages -text "R\u00e9pertoire des images"
entry  $f.edImages -width 50
affValeurEntry $f.edImages $(user:dImages)
button $f.bdImages -text ... -command [list callback:choixRep $f.edImages (user:dImages)]
#
label  $f.lfLogo -text "Chemin vers le logo"
entry  $f.efLogo
affValeurEntry $f.efLogo $(user:fLogo)
button $f.bfLogo -text ... -command [list callback:choixLog $f.efLogo]
#
label  $f.ldOut -text "Nom du sous-r\u00e9pertoire de sortie"
entry  $f.edOut
affValeurEntry $f.edOut $(user:dOut)
bind   $f.edOut <KeyRelease> [list callback:choixRepS $f.edOut]
#
label  $f.lfOut -text "Nom des fichiers en sortie"
entry  $f.efOut
affValeurEntry $f.efOut $(user:fOut)
#
label  $f.llignes -text "Lignes de texte"
entry  $f.elignes
affValeurEntry $f.elignes $(user:lignes)
##
label  $f.lTexte -text "Texte"
frame $fT
listbox $fT.lbfPolice -height 5 -width 45 -exportselection 0
scrollbar $fT.sbfPolice -orient vertical
$fT.lbfPolice configure -yscrollcommand [list $fT.sbfPolice set]
$fT.sbfPolice configure -command [list $fT.lbfPolice yview]
set gendarmes  [magick fonts]
set indice [lsearch -exact $gendarmes $(user:fPolice)]
eval $fT.lbfPolice insert 0 $gendarmes
$fT.lbfPolice selection set $indice
$fT.lbfPolice see $indice
bind $fT.lbfPolice <<ListboxSelect>> {set (user:fPolice) [$fT.lbfPolice get [$fT.lbfPolice curselection]]}
#
label  $fT.lcouleur -relief ridge -borderwidth 3 -bg $(user:couleur)\
    -text "Couleur texte"
bind   $fT.lcouleur <1> [list callback:choixCoul $fT.lcouleur (user:couleur)]
label  $fT.lcouleurf -relief ridge -borderwidth 3 -bg $(user:couleurf)\
    -text "Couleur détourage"
bind   $fT.lcouleurf <1> [list callback:choixCoul $fT.lcouleurf (user:couleurf)]
entry $fT.etPolice -width 3
affValeurEntry $fT.etPolice $(user:tPolice)
entry $fT.etLine -width 3
affValeurEntry $fT.etLine $(user:tLine)
pack $fT.lbfPolice -side left -fill x
pack $fT.sbfPolice -side left -fill y
pack $fT.lcouleur $fT.lcouleurf $fT.etPolice $fT.etLine -fill x
#
# Thèmes
label  $f.lTheme -text Th\u00e8mes
menubutton  $f.mbTheme -relief ridge
nomTheme $f.mbTheme
#
label $f.lmodeLogo -text "Mode Logo"
menubutton $f.mbmodeLogo -relief ridge
nommodeLogo $f.mbmodeLogo
entry      $f.etLogo -width 3
affValeurEntry $f.etLogo $(user:tLogo)
#
checkbutton $f.cbmultiThemes -text "Appliquer plusieurs thèmes (ex : 1 3 4)"\
    -variable gui:multiThemes -anchor w
entry $f.emultiT
affValeurEntry $f.emultiT $(user:multiT)
set row 1
##
##
grid $f.cbgenF  -row $row -column 1 -columnspan 2 -sticky news
grid $f.bgenF -row $row -column 3 -sticky news
incr row

grid $f.ldImages -row $row -column 1 -sticky e
grid $f.edImages -row $row -column 2 -sticky news
grid $f.bdImages -row $row -column 3 -sticky news
incr row

grid $f.lfLogo -row $row -column 1 -sticky e
grid $f.efLogo -row $row -column 2 -sticky news
grid $f.bfLogo -row $row -column 3 -sticky news
incr row

grid $f.ldOut -row $row -column 1 -sticky e
grid $f.edOut -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lfOut -row $row -column 1 -sticky e
grid $f.efOut -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.llignes -row $row -column 1 -sticky e
grid $f.elignes -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lTexte -row $row -column 1 -sticky e
grid $f.fTexte -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.cbmultiThemes -row $row -column 2  -sticky w
grid $f.emultiT       -row $row -column 3  -sticky news
incr row

grid $f.lTheme  -row $row -column 1 -sticky e
grid $f.mbTheme -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lmodeLogo  -row $row -column 1 -sticky e
grid $f.mbmodeLogo -row $row -column 2 -sticky news
grid $f.etLogo     -row $row -column 3 -sticky news
###

labelframe $h -text "Visualisation sur un exemple"
button $h.b -text "Test sur une des photos du r\u00e9pertoire"\
    -command [list callback:okay $f.edImages $f.efLogo $f.edOut $f.efOut $f.elignes $fT.etPolice $fT.etLine $f.etLogo $f.emultiT $h.b 1]
#set format [expr {4/3.}]
set L 600
#set l [expr {int($L/$format)}]
canvas $h.c -width $L -height $L -relief ridge -bg white
#bind $h.c <Configure> { actualisecv %W %w %h}


pack $h.b -fill x
pack $h.c -fill both

###
canvas .moi  -relief groove -width 20 -height 30
set mafonte {Times 14 bold}
set logo {
    2 1 D {-anchor nw}
    4 2 C {-anchor nw  -font $mafonte -fill red}
}
foreach {x y t opt} $logo {
    eval .moi create text $x $y -text $t $opt
}
bind .moi <1> {tk_messageBox -message \
		   "David Cobac david.cobac@gmail.com\nMade In Angers (49)\nAvril 2010-Mai 2014"\
		   -title information -type ok}

###
labelframe $g -text "Traitement g\u00e9n\u00e9ral"

button $g.ok   -text "Traitement complet" \
    -command [list callback:okay $f.edImages $f.efLogo $f.edOut $f.efOut $f.elignes $fT.etPolice $fT.etLine $f.etLogo $f.emultiT $h.b]
button $g.def  -text "Config par d\u00e9faut" -command [list callback:defaut]
button $g.exit  -text Fermer -command [list callback:exit]
pack $g.ok $g.exit $g.def -side left -fill x -expand 1

###
pack $f $h -padx 5 -pady 5 -ipadx 5 -ipady 5 -fill both
pack .moi -side right -padx 5
pack $g  -padx 5 -pady 5  -ipadx 5 -ipady 5 -fill x

###
wm resizable . 0 0
wm title . "D\u00e9cor de photos"
bind . <Control-q> [list callback:exit]
bind . <Control-x> [list callback:exit]
