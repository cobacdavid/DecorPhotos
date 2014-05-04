#!/bin/sh
# -*-Tcl-*-
# The next line restarts using tclsh \
exec tclsh8.5 "$0" -- ${1+"$@"}


# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 04/05/2014

# création des outils
set wand  [magick create wand]
set logo  [magick create wand]
set draw  [magick create draw]
set pixel [magick create pixel]
set black [magick create pixel]
$black color black
set userFg  [magick create pixel]
$userFg color $(user:couleurf)
set userBg  [magick create pixel]
$userBg color $(user:couleur)
set police $(user:fPolice)
# chargement de l'image
$wand ReadImage $inFile
# chargement du logo
$logo ReadImage $(user:fLogo)
# récupération des infos de l'image
foreach {k v} [jpeg::formatExif [jpeg::getExif $inFile]] {
    if {$k eq "DateTimeOriginal"} {
	regexp {([0-9]{4}):([0-9]+):([0-9]+)\
		    ([0-9]+):([0-9]+):([0-9]+)} $v -> y m d H M S
	set date  "$d/$m/$y"
	set heure ${H}:${M}:${S}
	set mois [clock format [clock scan "$y$m$d $heure"]\
		      -format %B -locale fr]
	set Mois [string toupper $mois 0 0]
    } elseif {$k eq "Orientation"} {
	set normal [string equal $v "normal"]
	if [string equal $v "90 degrees cw"] {
	    set angle 90
	} elseif [string equal $v "90 degrees ccw"] {
	    set angle -90
	}
    }
}
if {![info exists date] || ![info exists heure]} {
	tk_messageBox -icon error -message "Erreur de récupération\
de l'heure et/ou de la date
Plusieurs causes sont possibles..."
    return
}
# rotation si image en portrait
if {$normal eq 0} {
    $wand RotateImage $black $angle
}
set w     [$wand width]
set h     [$wand height]
set wLogo [$logo width]
set hLogo [$logo height]
# 
set lignes [split [subst $(user:lignes)] \n]
set nbLignes [llength $lignes]
set minX $w
set minY $h
# on installe la police utilisée dans la zone de dessin
$draw font     $police
$draw fontsize $(user:tPolice)
$draw strokecolor $userFg
$draw fillcolor   $userBg
$draw textantialias 1
# traitement du texte
for {set i 0} {$i<$nbLignes} {incr i} {
    set texte [lindex $lignes $i]
    foreach { cw ch fa fd fw fh ha } [$wand queryfontmetrics $draw $texte] break
    set Xoff $cw
    set X [expr {$w-$fw-1*$Xoff}]
    # ATTENTION $fd est négatif !
    # ou encore pour la ligne suivante : set Y [expr {$h-($nbLignes-$i)*(-$fd+$fa)}]
    set Y [expr {$h-($nbLignes-$i)*($fa)}]
    $draw annotation $X $Y $texte
    if { $X < $minX } {set minX $X}
    if { $Y < $minY } {set minY $Y}
}
$wand draw $draw
# insertion logo
set wL   $(user:tLogo)
set hL   [expr {$wL*$hLogo/$wLogo}] 
set minY [expr {$minY - $fa}]
# exécution du thème choisi
eval $theme($(user:choixTheme))
# sauvegarde 
if {$test eq 0} {
    file mkdir $(user:dOut) 
    eval $wand write [file join $(user:dOut) $(user:fOut)]
} else {
    # set format [expr {4/3.}]
    set canvas .h.c
    set wcv [$canvas cget -width]
    set hcv [$canvas cget -height]
    set cv [image create photo]
    $wand resize $wcv $hcv
    magicktophoto $wand $cv    
    .h.c create image 0 0 -image $cv -anchor nw
}
#
magick delete $draw
magick delete $wand
magick delete $logo
magick delete $pixel
magick delete $black
magick delete $userBg
magick delete $userFg
