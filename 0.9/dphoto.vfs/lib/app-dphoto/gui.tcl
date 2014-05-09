# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010
# rev    : 05/05/2014

## Processus de création des widgets
# on crée les conteneurs harcodés toplevel/frames
# puis chaque widget est placé dans un conteneur
# en renseignant la variable ::dphoto::gui::widgets
# du chemin complet par une clé 'path', par exemple
# monwidget {key1 .... path .f.ff.bN}
##
#
# ATTENTION
# dans ce tableau TOUT est lié à la variable ::dphoto::userDefault !!!
#
array set ::dphoto::gui::widgets {
    fontName {key1 font key2 name parent .font name fN type listbox options {-height 5 -width 45 -exportselection 0}}
    fontSize {key1 font key2 size parent .font name fS type entry options {-width 3}}
    fontFg   {key1 font key2 fg   parent .font name fF type label options {-relief ridge -borderwidth 3 -text "Couleur"}}
    fontBg   {key1 font key2 bg   parent .font name fB type label options {-relief ridge -borderwidth 3 -text "Couleur fond"}}
    themeChoice {key1 theme key2 choice parent .theme name tC  type menubutton  options {-relief ridge}}
    themeMulti  {key1 theme key2 multi  parent .theme name tM  type checkbutton options {-text "Appliquer plusieurs thèmes (ex : 1 3 4)" -variable ::dphoto::gui::multithemes -anchor w}}
    themeMultiT {key1 theme key2 multiT parent .theme name tMT type entry       options {}}
    lineFg    {key1 line key2 fg    parent .line name lF type label options {}}
    lineBg    {key1 line key2 bg    parent .line name lB type label options {}}
    lineWidth {key1 line key2 width parent .line name lW type entry options {-width 3}}
    textLignes {key1 text key2 lignes parent .text name tL type entry options {}}
    logoPath {key1 logo key2 path parent .logo name lP type entry      options {}}
    logoSize {key1 logo key2 size parent .logo name lS type entry      options {-width 3}}
    logoMode {key1 logo key2 mode parent .logo name lM type menubutton options {-relief ridge}}
    imagesInpath          {key1 images key2 path            parent .images name iI type entry options {}}
    imagesRelativeoutpath {key1 images key2 relativeoutpath parent .images name iR type entry options {}}
    imagesPrefixout       {key1 images key2 prefixout       parent .images name iP type entry options {}}
    generateDphoto {key1 generate key2 dphoto parent .generate name gD type checkbutton options { -text "G\u00e9n\u00e9rer le fichier dphoto.txt dans le r\u00e9pertoire de sortie" -anchor w -variable ::dphoto::gui::generateDphoto}}
}
#
#
#
# utilisé pour centrer la photo sur le canvas
proc dphoto::gui::centrage {wCV hCV wWand hWand} {
    set x [expr { ($wCV - $wWand ) / 2}]
    set y [expr { ($hCV - $hWand ) / 2}]
    return [list $x $y]
}

# w widget entry à compléter
# namet nom du tableau concerné  FQN
# namek nom de la clé à modifier
proc dphoto::gui::setDir {w namet namek} {
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
    set dir [file normalize [file dirname [dict get [set $namet] $namek]]]
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
	$w configure -bg $c
    }
}


# namew nom que porte le widget
# (derniers caractères après le dernier point)
proc dphoto::gui::getWidgetPath { namew } {
    variable ::dphoto::gui::widgets

    return [dict get $::dphoto::gui::widgets($namew) path]
}

# namew nom que porte le widget entry
# (derniers caractères après le dernier point)
proc dphoto::gui::getEntry { namew } {
    set w [::dphoto::gui::getWidgetPath $namew]
    return [$w get]
}


proc dphoto::gui::getAllEntries {} {
    variable ::dphoto::user
    #
    dict set ::dphoto::user(font) \
	size            [::dphoto::gui::getEntry fontSize]
    dict set ::dphoto::user(theme) \
	multiT          [::dphoto::gui::getEntry themeMultiT]
    dict set ::dphoto::user(line) \
	width           [::dphoto::gui::getEntry lineWidth]
    dict set ::dphoto::user(text) \
	lignes          [::dphoto::gui::getEntry textLignes]
    dict set ::dphoto::user(logo) \
	size            [::dphoto::gui::getEntry logoSize]
    dict set ::dphoto::user(logo) \
	path            [::dphoto::gui::getEntry logoPath]
    dict set ::dphoto::user(images) \
	relativeoutpath [::dphoto::gui::getEntry imagesRelativeoutpath]
    dict set ::dphoto::user(images) \
	prefixout       [::dphoto::gui::getEntry imagesPrefixout]
    dict set ::dphoto::user(images) \
	inpath          [::dphoto::gui::getEntry imagesInpath]
    ### vérifications avant traitement
    ### cela reste à compléter !
    if {[dict get $::dphoto::user(images) inpath] == "" || \
	    [dict get $::dphoto::user(images) prefixout] == ""}   {return}
    if {![file exists [dict get $::dphoto::user(images) inpath]]} {return}
    if {![file exists [dict get $::dphoto::user(logo)   path  ]]} {return}
}


# test booléen si on ne teste que sur une photo
proc dphoto::gui::okay {test} {
    variable ::dphoto::user
    variable ::dphoto::files

    ::dphoto::gui::getAllEntries
    ###
    cd [dict get $::dphoto::user(images) inpath]
    # à compléter avec des .png
    set listeJPG [glob -nocomplain *.jpg]
    ### mode test : une seule image, la première
    if {$test eq 1} {
	set listeJPG [lindex $listeJPG 0]
    }
    ###
    set nbFic [llength $listeJPG]
    if { $nbFic eq 0} {
	tk_messageBox -icon info -message "Pas de fichiers images trouv\u00e9s.
V\u00e9rifier que le r\u00e9pertoire choisi contienne bien ce type de fichiers."
	return
    }
    ####
    # si un fichier dphoto.txt existe -> on le prend en compte
    set f [file join [dict get $::dphoto::user(images) inpath] \
	       [dict get $::dphoto::user(images) relativeoutpath] dphoto.txt] 
    # on ne le fait pas pour les tests
    if {[file exists $f] & $test eq 0} {
	set hf [open $f r]
	while {![eof $hf]} {
	    gets $hf ligne
	    # chaque ligne est  associé à une image et un texte particuliers
	    if {$ligne ne ""} {
		regexp {(.*)\t(.*)} $ligne -> f l
		set inFile $f
		dict set ::dphoto::user(text) lignes [string trim $l \{\}]
		::dphoto::traitement::setExifInfo $inFile
		source $::dphoto::files(decphoto)
	    }
	}
	close $hf
    } else {
	# sans fichier dphoto.txt on applique
	# le même traitement à toutes les images
	foreach inFile $listeJPG {
	    ::dphoto::traitement::setExifInfo $inFile
	    source $::dphoto::files(decphoto)
	}
    }
}

# callback gui
proc dphoto::gui::fermeture {} {
    ::dphoto::config::enregistrement
    exit
}

# w widget contenant le nom du thème sélectionné
# n indice du thème sélectionné dans le tableau de thèmes
## Normalement w est dict get $::dphoto::gui::widgets(themeChoice) path
proc dphoto::gui::theme {w n} {
    variable ::dphoto::user
    variable ::dphoto::theme

    dict set ::dphoto::user(theme) choice $n
    $w configure -text [lindex [set ::dphoto::theme($n)] 0]
}

# w nom du menubutton
# Normalement w est $::dphoto::gui::widgets(themeChoice) path
# construction du menubutton Thème
proc dphoto::gui::nomTheme {w} {
    variable ::dphoto::user
    variable ::dphoto::theme
    
    set m $w.m  
    menu $m -tearoff 0
    $w configure -menu $m 

    for {set i 0} {$i<[array size ::dphoto::theme]} {incr i} {
	set texteTheme [lindex $::dphoto::theme($i) 0]
	$m add command -label "Thème $i : $texteTheme" \
	    -command [list ::dphoto::gui::theme $w $i]
    }
    #
    set indice [dict get $::dphoto::user(theme) choice]
    $w configure -text [lindex $::dphoto::theme($indice) 0]
}

# w widget button qui permet de générer le fichier dphoto.txt
proc dphoto::gui::genF {w args} {
    #variable ::dphoto::user
    variable ::dphoto::gui::generateDphoto
    #variable ::dphoto::gui::widgets

    if {$::dphoto::gui::generateDphoto eq 0} {
	foreach x $args {
	    $x configure -state normal
	}
	$w configure -state disabled
    } else {
	foreach x $args {
	    $x configure -state disabled
	}
	$w configure -state normal
    }
}

#callback gui
proc dphoto::gui::genereFicTextes {} {
    variable ::dphoto::user
    variable ::dphoto::gui::widgets

    ::dphoto::gui::getAllEntries
    cd [dict get $::dphoto::user(images) inpath]
    # à compléter avec des .png    
    set listeJPG [glob -nocomplain *.jpg]
    if {[llength $listeJPG] eq 0} {
	tk_messageBox -icon info -message "Pas de fichiers images trouv\u00e9s.
V\u00e9rifier que le r\u00e9pertoire choisi contienne bien ce type de fichiers."
	return
    }
    #
    #file mkdir $(user:dOut)
    #cd $(user:dOut)
    set out [dict get $::dphoto::user(images) relativeoutpath]
    file mkdir $out
    cd $out
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
	    set texte [dict get $::dphoto::user(text) lignes]
	    puts $h "$inFile\t[list $texte]"
	}
    }
    close $h
}

# w widget entry à compléter
# v string valeur à mettre
## Normalement w est dict get $::dphoto::gui::widgets(__entry__) path
proc dphoto::gui::affValeurEntry {w v} {
    $w delete 0 end
    $w insert end $v
}
# w widget menubutton
## Normalement w est dict get $::dphoto::gui::widgets(logoMode) path
proc dphoto::gui::nommodeLogo {w} {
    variable ::dphoto::user

    set m $w.m  
    menu $m -tearoff 0
    $w configure -menu $m 
    set modes [list "undefined"  "over"  "in"  "out"  "atop"  "xor"  "plus"  "minus"  "add"  "subtract"  "difference"  "multiply"  "bumpmap"  "copy"  "copyred"  "copygreen"  "copyblue"  "copyopacity"  "clear"  "dissolve"  "displace"  "modulate"  "threshold"  "no"  "darken"  "lighten"  "hue"  "saturate"  "colorize"  "luminize"  "screen"  "overlay"  "copycyan"  "copymagenta"  "copyyellow"  "copyblack"  "replace"]
    
    foreach mode $modes {
	$m add command -label $mode \
	    -command "$w configure -text $mode
                      dict set ::dphoto::user(logo) mode $mode"
    }
    # on sélectionne le premier thème au démarrage
    $w configure -text [dict get $::dphoto::user(logo) mode]
}

proc dphoto::traitement::setExifInfo {f} {
    variable ::dphoto::traitement::exif
    
    foreach {k v} [jpeg::formatExif [jpeg::getExif $f]] {
	# on récupère tout de toutes façons...pour l'avoir et
	# pour éventuellement l'utiliser dans le texte !!
	# Il faudrait penser pouvoir récupérer tout cela
	# dans l'interface graphique
	set ::dphoto::traitement::exif($k) $v
	# priorité : on récupère date et heure
	if {$k eq "DateTimeOriginal"} {
	    regexp {([0-9]{4}):([0-9]+):([0-9]+)\
			([0-9]+):([0-9]+):([0-9]+)} $v -> y m d H M S
	    set ::dphoto::traitement::exif(date)  "$d/$m/$y"
	    set ::dphoto::traitement::exif(heure) "${H}:${M}:${S}"
	    # l'option locale n'est pas forcément prise ne compte
	    # cela dépend de la version de Tcl
	    set ::dphoto::traitement::exif(mois) \
		[clock format [clock scan "$y$m$d $::dphoto::traitement::exif(heure)"] -format %B -locale fr]
	    set ::dphoto::traitement::exif(Mois) \
		[string toupper $::dphoto::traitement::exif(mois) 0 0]
	    # on récupère ensuite l'orientation
	    # pour pouvior la changer
	} elseif {$k eq "Orientation"} {
	    set ::dphoto::traitement::exif(normal) [string equal $v "normal"]
	    if [string equal $v "90 degrees cw"] {
		set ::dphoto::traitement::exif(angle) 90
	    } elseif [string equal $v "90 degrees ccw"] {
		set ::dphoto::traitement::exif(angle) -90
	    }
	}
    }
    array set ::exif [array get ::dphoto::traitement::exif]
}
######################################################################################""
# name clé dans la variable ::dphoto::gui::widgets
# pathparent chemin complet du conteneur
## le nom complet du widget est renvoyé par la procédure
## et est stocké dans la variable ::dphoto::gui::widgets
proc dphoto::gui::creeWidget { name pathparent args} {
    variable ::dphoto::gui::widgets

    set w [dict create {*}$::dphoto::gui::widgets($name)]
    set path $pathparent.[dict get $w name]
    eval [dict get $w type] $path [dict get $w options] $args
    dict set ::dphoto::gui::widgets($name) path $path
    return $path
}
##

set f .f
set fT $f.fTexte
set g .g
set h .h
##
labelframe $f -text Param\u00e8tres
#
dphoto::gui::creeWidget generateDphoto $f -command [list ::dphoto::gui:::genF $f.bgenF]
button $f.bgenF -text "G\u00e9n\u00e9rer" -command [list dphoto::gui::genereFicTextes] -state disabled
#
label  $f.ldImages -text "R\u00e9pertoire des images"
set w [::dphoto::gui::creeWidget imagesInpath $f -width 50]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(images) inpath]
button $f.bdImages -text ... -command [list ::dphoto::gui::setDir $w ::dphoto::user(images) inpath]
#
label  $f.lfLogo -text "Chemin vers le logo"
set w [::dphoto::gui::creeWidget logoPath $f]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(logo) path]
button $f.bfLogo -text ... -command [list ::dphoto::gui::setFile $w ::dphoto::user(logo) path]
#
label  $f.ldOut -text "Nom du sous-r\u00e9pertoire de sortie"
set w [::dphoto::gui::creeWidget imagesRelativeoutpath $f] 
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(images) relativeoutpath]
bind $w <KeyRelease> [list ::dphoto::gui::setDir $w ::dphoto::user(images) relativeoutpath]
#
label  $f.lfOut -text "Nom des fichiers en sortie"
set w [::dphoto::gui::creeWidget imagesPrefixout .f]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(images) prefixout]
#
label  $f.llignes -text "Lignes de texte"
set w [::dphoto::gui::creeWidget textLignes $f]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(text) lignes]
##
label  $f.lTexte -text "Texte"
frame $fT
set w [::dphoto::gui::creeWidget fontName $fT]
scrollbar $fT.sbfPolice -orient vertical
$w configure -yscrollcommand [list $fT.sbfPolice set]
$fT.sbfPolice configure -command [list $w yview]
set gendarmes  [magick fonts]
set indice [lsearch -exact $gendarmes  [dict get $::dphoto::user(font) name]]
eval $w insert 0 $gendarmes
$w selection set $indice
$w see $indice
bind $w <<ListboxSelect>> {dict set ::dphoto::user(font) name [%W get [%W curselection]]; $f.lTexte configure -font  [%W get [%W curselection]]}
#
set w [::dphoto::gui::creeWidget fontFg $fT -bg [dict get $::dphoto::user(font) fg]]
bind $w <1> [list ::dphoto::gui::setCoul $w ::dphoto::user(font) fg]
#
set w [::dphoto::gui::creeWidget fontBg $fT -bg [dict get $::dphoto::user(font) bg]]
bind $w <1> [list ::dphoto::gui::setCoul $w ::dphoto::user(font) bg]
#
set w [::dphoto::gui::creeWidget fontSize $fT]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(font) size]
#
set w [::dphoto::gui::creeWidget lineWidth $fT]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(line) width]
pack [dict get $::dphoto::gui::widgets(fontName) path] -side left -fill x
pack $fT.sbfPolice -side left -fill y
pack [dict get $::dphoto::gui::widgets(fontFg) path]\
    [dict get $::dphoto::gui::widgets(fontBg) path]\
    [dict get $::dphoto::gui::widgets(fontSize) path]\
    [dict get $::dphoto::gui::widgets(lineWidth) path]\
    -fill x
#
# Thèmes
label  $f.lTheme -text Th\u00e8mes
set w [::dphoto::gui::creeWidget themeChoice $f]
::dphoto::gui::nomTheme $w
#
label $f.lmodeLogo -text "Mode Logo"
set w [::dphoto::gui::creeWidget logoMode $f]
::dphoto::gui::nommodeLogo $w
#
set w [::dphoto::gui::creeWidget logoSize $f]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(logo) size]
#
::dphoto::gui::creeWidget themeMulti $f
set w [::dphoto::gui::creeWidget themeMultiT $f]
::dphoto::gui::affValeurEntry $w [dict get $::dphoto::user(theme) multiT]
##
##
set row 1
grid [dict get $::dphoto::gui::widgets(generateDphoto) path] -row $row -column 1 -columnspan 2 -sticky news
grid $f.bgenF -row $row -column 3 -sticky news
incr row

grid $f.ldImages -row $row -column 1 -sticky e
grid [dict get $::dphoto::gui::widgets(imagesInpath) path] -row $row -column 2 -sticky news
grid $f.bdImages -row $row -column 3 -sticky news
incr row

grid $f.lfLogo -row $row -column 1 -sticky e
grid [dict get $::dphoto::gui::widgets(logoPath) path] -row $row -column 2 -sticky news
grid $f.bfLogo -row $row -column 3 -sticky news
incr row

grid $f.ldOut -row $row -column 1 -sticky e
grid [dict get $::dphoto::gui::widgets(imagesRelativeoutpath) path] -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lfOut -row $row -column 1 -sticky e
grid [dict get $::dphoto::gui::widgets(imagesPrefixout) path] -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.llignes -row $row -column 1 -sticky e
grid [dict get $::dphoto::gui::widgets(textLignes) path] -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lTexte -row $row -column 1 -sticky e
grid $f.fTexte -row $row -column 2 -columnspan 2 -sticky news
incr row

grid [dict get $::dphoto::gui::widgets(themeMulti)  path] -row $row -column 2  -sticky w
grid [dict get $::dphoto::gui::widgets(themeMultiT) path] -row $row -column 3  -sticky news
incr row

grid $f.lTheme  -row $row -column 1 -sticky e
grid [dict get $::dphoto::gui::widgets(themeChoice) path] -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lmodeLogo  -row $row -column 1 -sticky e
grid [dict get $::dphoto::gui::widgets(logoMode) path] -row $row -column 2 -sticky news
grid [dict get $::dphoto::gui::widgets(logoSize) path] -row $row -column 3 -sticky news
###
###

labelframe $h -text "Visualisation sur un exemple"
button $h.b -text "Test sur une des photos du r\u00e9pertoire"\
    -command [list ::dphoto::gui::okay 1]
#set format [expr {4/3.}]
set L 600
#set l [expr {int($L/$format)}]
canvas $h.c -width $L -height $L -relief ridge -bg white
#bind $h.c <Configure> { actualisecv %W %w %h}
focus $h.c
#
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
    -command [list ::dphoto::gui::okay 0]
button $g.def  -text "Config par d\u00e9faut" -command [list ::dphoto::config::defaut]
button $g.exit  -text Fermer -command ::dphoto::gui::fermeture
pack $g.ok $g.exit $g.def -side left -fill x -expand 1

###
pack $f $h -padx 5 -pady 5 -ipadx 5 -ipady 5 -fill both
pack .moi -side right -padx 5
pack $g  -padx 5 -pady 5  -ipadx 5 -ipady 5 -fill x

###
wm resizable . 0 0
wm title . "D\u00e9cor de photos"
bind . <Control-q> [list ::dphoto::gui::fermeture]
bind . <Control-w> [list ::dphoto::gui::fermeture]
