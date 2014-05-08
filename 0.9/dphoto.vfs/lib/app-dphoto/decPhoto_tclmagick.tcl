# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 04/05/2014
#
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
# rotation si image en portrait
if {$exif(normal) eq 0} {
    $wand RotateImage $black $exif(angle)
}
# les dimensions des images
set w     [$wand width]
set h     [$wand height]
set wLogo [$logo width]
set hLogo [$logo height]
# 
set lignes   [split [subst $(user:lignes)] \n]
set nbLignes [llength $lignes]
set minX     $w
set minY     $h
# on installe la police utilisée dans la zone de dessin
$draw font          $police
$draw fontsize      $(user:tPolice)
$draw strokewidth   $(user:tLine)
$draw strokecolor   $userFg
$draw fillcolor     $userBg
$draw textantialias 1
### Calculs des distances pour le texte
## infoTexte { {{ligne0 à insérer} largeur} {{ligne1 à insérer} largeur} etc. }
## variables globales :
## largeurMax : largeur maximale
## Xoff : dimension d'un caractère de police typiquement $(user:tpolice)
## hLigne : hauteur d'une ligne
set largeurMax 0
set infoTexte {}
for {set i 0} {$i<$nbLignes} {incr i} {
    set texte [lindex $lignes $i]
    foreach { cw ch fa fd fw fh ha } [$wand queryfontmetrics $draw $texte] break
    set largeurMax [expr {max($largeurMax,$fw)}]
    set infoTexte [lappend infoTexte [list $texte $fw]]
}
# Xoff joue aussi le rôle de Yoff...
# faudra différencier ou utiliser off tout simplement
set Xoff $cw
set hLigne [expr {$fa-$fd}]
# dimensions logo
set wL   $(user:tLogo)
set hL   [expr {$wL*$hLogo/$wLogo}]
$logo resize $wL $hL 
# exécution du thème choisi
if {${gui:multiThemes} == 1 } {
    foreach t $(user:multiT) {
	eval [lindex [set Theme($t)] 1]
    }
} else {
    eval [lindex [set Theme($(user:choixTheme))] 1]
}
# insertion du dessin dans l'image
$wand draw $draw
# sauvegarde 
if {$test eq 0} {
    file mkdir $(user:dOut) 
    eval $wand write [file join $(user:dOut) $(user:fOut)]
} else {
    # affichage dans le canvas
    set canvas .h.c
    $canvas delete all
    set wcv [winfo width $canvas]
    set hcv [winfo height $canvas]
    set cv [image create photo]
    #
    set rapportWand [expr {1. * $w / $h}]
    set rapportCV   [expr {1. * $wcv / $hcv}]
    if {$rapportWand > $rapportCV} {
	set rapport [expr {1. * $wcv / $w}]
	set ww $wcv
	set hw [expr {int($h * $rapport)}]
    } else {
	set rapport [expr {1. * $hcv / $h}]
	set ww [expr {int($w * $rapport)}]
	set hw $hcv
    }
    $wand resize $ww $hw
    #
    magicktophoto $wand $cv 
    eval .h.c create image [canvas:centrage $wcv $hcv $ww $hw] -image $cv -anchor nw
}
# nettoyage
magick delete $draw
magick delete $wand
magick delete $logo
magick delete $pixel
magick delete $black
magick delete $userBg
magick delete $userFg
