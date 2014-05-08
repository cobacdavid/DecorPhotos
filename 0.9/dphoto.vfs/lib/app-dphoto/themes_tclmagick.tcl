#
# utilisation de j et incr j pour éviter tout classement hardcodé
# ici il suffit de couper/coller les thèmes pour changer l'ordre
#
##
set j -1
#
set ::dphoto::theme([incr j]) [list {lignes de textes seules en haut à gauche} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 $Xoff
				 set y0 [expr { $Xoff + ( $i + 1 ) * $hLigne }]
				 $draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
				 $draw annotation $x0 $y0 $laLigne
			     }
			 }]

set ::dphoto::theme([incr j]) [list {lignes de textes seules en haut à droite} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 [expr { $w - $Xoff - [lindex $t 1] }]
				 set y0 [expr { $Xoff + ( $i + 1 ) * $hLigne }]
				 $draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
				 $draw annotation $x0 $y0 $laLigne
			     }
			 }]

set ::dphoto::theme([incr j]) [list {lignes de textes seules en bas à gauche} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 $Xoff
				 set y0 [expr { $h - ($nbLignes - $i) * $hLigne }]
				 $draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
				 $draw annotation $x0 $y0 $laLigne
			     }
			 }]

set ::dphoto::theme([incr j]) [list {lignes de textes seules en bas à droite} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 [expr { $w - $Xoff - [lindex $t 1] }]
				 set y0 [expr { $h - ($nbLignes - $i) * $hLigne }]
				 $draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
				 $draw annotation $x0 $y0 $laLigne
			     }
			 }]

set ::dphoto::theme([incr j]) [list {lignes de textes seules centrées en bas } \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 [expr { ($w  - [lindex $t 1]) / 2 }]
				 set y0 [expr { $h - ($nbLignes - $i) * $hLigne }]
				 $draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
				 $draw annotation $x0 $y0 $laLigne
			     }
			 }]

set ::dphoto::theme([incr j]) [list {logo seul en haut à gauche} \
			 {
			     $wand composite $logo $(user:modeLogo) [expr {int($fa)}] [expr {int($fa)}]
			 }]

set ::dphoto::theme([incr j]) [list {logo seul en haut à droite} \
			 {
			     $wand composite $logo $(user:modeLogo) [expr { $w - $wL - int($fa) }] [expr {int($fa)}]
			 }]

set ::dphoto::theme([incr j]) [list {logo seul en bas à gauche} \
			 {
			     $wand composite $logo $(user:modeLogo) [expr { int($fa) }] [expr { $h - $hL - int($fa) }]
			 }]

set ::dphoto::theme([incr j]) [list {logo seul en bas à droite} \
			 {
			     $wand composite $logo $(user:modeLogo) [expr { $w - $wL - int($fa) }] [expr { $h - $hL - int($fa) }]
			 }]

set ::dphoto::theme([incr j]) [list {test composite avec logo} \
			 {
			     $wand composite $logo $(user:modeLogo) [expr { $w - $wL - int($fa) }] [expr { $h - $hL - int($fa) }]
			 }]
set ::dphoto::theme([incr j]) [list {logo en haut à gauche + lignes vert. et horiz. + lignes de textes} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 [expr { $w - $Xoff - [lindex $t 1] }]
				 set y0 [expr { $h - ($nbLignes - $i) * $hLigne }]
				 $draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
				 $draw annotation $x0 $y0 $laLigne
			     }
			     set ymax [expr { $y0 + abs($fd) }]
			     set xmax [expr { $w - .5*$Xoff }]
			     # insertion logo
			     $wand composite $logo $(user:modeLogo) [expr {int($Xoff)}] [expr {int($Xoff)}]
			     # les lignes 
			     $draw strokewidth $(user:tLine)
			     $draw strokecolor $userBg
			     $draw line $Xoff [expr {2*$fa + $hL}] $Xoff [expr { $h - $hLigne }]
			     $draw line $Xoff [expr { $h - $hLigne }] \
				 [expr { $w - $largeurMax - $Xoff - .5*$Xoff}] [expr { $h - $hLigne }] 
			     $draw line $xmax $ymax $xmax [expr { $ymax - $hLigne * $nbLignes }]
			 }]

set ::dphoto::theme([incr j]) [list {Encadrement simple} \
			 {
			     $draw strokewidth $(user:tLine)
			     $draw strokecolor $userBg
			     set theme_Xoff [expr { 0.5 * $Xoff }]
			     $draw line $theme_Xoff $theme_Xoff $theme_Xoff [expr { $h - $theme_Xoff}]
			     $draw line $theme_Xoff [expr { $h - $theme_Xoff}]\
				 [expr { $w - $theme_Xoff}] [expr { $h - $theme_Xoff }]
			     $draw line [expr { $w - $theme_Xoff}] [expr { $h - $theme_Xoff }]\
				 [expr { $w - $theme_Xoff}] $theme_Xoff
			     $draw line [expr { $w - $theme_Xoff}] $theme_Xoff\
				 $theme_Xoff $theme_Xoff
			 }]

set ::dphoto::theme([incr j]) [list {Noir et Blanc} \
			 {
			     $wand imagetype grayscale
			 }]

set ::dphoto::theme([incr j]) [list {Rotation 90° du texte} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 $Xoff
				 set y0 [expr { $h - $hLigne }]
				 $draw translate $x0 $y0
				 $draw rotate -90
				 $draw translate 0 [expr {($i+1) * $hLigne}]
				 $draw annotation 2 -2 $laLigne
				 $draw annotation 0 0 $laLigne
				 $draw translate 0 [expr { - ($i+1) * $hLigne}]
				 $draw rotate 90
				 $draw translate [expr {-$x0}] [expr {-$y0}]
			     }
			 }]

set ::dphoto::theme([incr j]) [list {Rotation -90° du texte} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 [expr {$w - $Xoff }]
				 set y0 $Xoff
				 $draw translate $x0 $y0
				 $draw rotate 90
				 $draw translate 0 [expr {($i+1) * $hLigne}]
				 $draw annotation 2 -2 $laLigne
				 $draw annotation 0 0 $laLigne
				 $draw translate 0 [expr {-($i+1) * $hLigne}]
				 $draw rotate -90
				 $draw translate [expr {-$x0}] [expr {-$y0}]
			     }
			 }]
##
unset j
