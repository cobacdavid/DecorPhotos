# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010
#

set f .f
labelframe $f -text Param\u00e8tres

checkbutton $f.r -text "G\u00e9n\u00e9rer le fichier dphoto.txt dans le r\u00e9pertoire\
de sortie" -variable gui:genF -anchor w \
    -command [list callback:genF $f.ed $f.el $f.eds $f.es $f.et $f.ep $f.lcc $f.br]
button $f.br -text "G\u00e9n\u00e9rer" -command [list callback:genereFicTextes $f.ed $f.eds $f.et]\
    -state disabled
set w 50
label  $f.ld -text "R\u00e9pertoire des images"
entry  $f.ed -width $w
affValeurEntry $f.ed $(user:dImages)
button $f.bd -text ... -command [list callback:choixRep $f.ed (user:dImages)]
label  $f.ll -text "Chemin vers le logo"
entry  $f.el
affValeurEntry $f.el $(user:fLogo)
button $f.bl -text ... -command [list callback:choixLog $f.el]
label  $f.lds -text "Nom du sous-r\u00e9pertoire de sortie"
entry  $f.eds
affValeurEntry $f.eds $(user:dOut)
# seul moyen de récupérer une modif de l'utilisateur sur cette entry
bind   $f.eds <KeyRelease> [list callback:choixRepS $f.eds]
label  $f.ls -text "Nom des fichiers en sortie"
entry  $f.es
affValeurEntry $f.es $(user:fOut)
label  $f.lt -text "Lignes de texte"
entry  $f.et
affValeurEntry $f.et $(user:lignes)
label  $f.lc -text "Couleur du texte"
label  $f.lcc -relief ridge -borderwidth 3 -bg $(user:couleur)\
    -text "Cliquer pour choisir la couleur"
bind   $f.lcc <1> [list callback:choixCoul $f.lcc]

# label  $f.lp -text "Fichier TTF de police"
# entry  $f.ep 
# button $f.bp -text ... -command [list callback:choixPol $f.ep]
# affValeurEntry $f.ep $(user:fPolice)
label  $f.lp -text "Police du texte"
menubutton $f.ep -menu $f.ep.m -textvar (user:fPolice) -relief groove
menu $f.ep.m -tearoff 0
foreach gendarme [magick fonts] {
    $f.ep.m add command -label $gendarme -command [list set (user:fPolice) $gendarme]
}

label $f.ltp -text "Taille de police"
entry $f.etp
affValeurEntry $f.etp $(user:tPolice)
label  $f.lh -text Th\u00e8mes
menubutton  $f.eh -relief ridge
nomTheme $f.eh

set row 1

grid $f.r  -row $row -column 1 -columnspan 2 -sticky news
grid $f.br -row $row -column 3
incr row

grid $f.ld -row $row -column 1
grid $f.ed -row $row -column 2
grid $f.bd -row $row -column 3
incr row

grid $f.ll -row $row -column 1
grid $f.el -row $row -column 2 -sticky news
grid $f.bl -row $row -column 3
incr row

grid $f.lds -row $row -column 1
grid $f.eds -row $row -column 2  -columnspan 2 -sticky news
incr row

grid $f.ls -row $row -column 1
grid $f.es -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lt -row $row -column 1
grid $f.et -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lc -row $row -column 1
grid $f.lcc -row $row -column 2 -columnspan 2 -sticky news
incr row

grid $f.lp -row $row -column 1
grid $f.ep -row $row -column 2 -sticky news
#grid $f.bp -row $row -column 3
incr row

grid $f.ltp -row $row -column 1
grid $f.etp -row $row -column 2 -sticky news
incr row

grid $f.lh -row $row -column 1
grid $f.eh -row $row -column 2  -columnspan 2 -sticky news

###

set h .h

labelframe $h -text "Visualisation sur un exemple"
button $h.b -text "Test sur une des photos du r\u00e9pertoire"\
    -command [list callback:okay $f.ed $f.el $f.eds $f.es $f.et $f.etp $h.b 1]
set format [expr {4/3.}]
set L 600
set l [expr {int($L/$format)}]
canvas $h.c -width $L -height $l -relief ridge

pack $h.b -fill x
pack $h.c

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
set g .g
labelframe $g -text "Traitement g\u00e9n\u00e9ral"

button $g.ok   -text "Traitement complet" \
    -command [list callback:okay $f.ed $f.el $f.eds $f.es $f.et $f.etp $g.ok]
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
