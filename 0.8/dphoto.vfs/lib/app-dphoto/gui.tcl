# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010
# rev    : 05/05/2014

# Remarque : joli bazar, à vouloir faire simple
# j'en suis venu à faire crade :(
# Faudra que je change tout cela pour la version 1.0 ...

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
