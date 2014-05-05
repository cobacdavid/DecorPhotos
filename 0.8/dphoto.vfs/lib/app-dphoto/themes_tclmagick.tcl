#
# utilisation de j et incrj pour éviter tout classement hardcodé
# ici il suffit de couper/coller les thèmes pour changer l'ordre
#
##
set j -1
#
set Theme([incr j]) [list {Noir et Blanc} \
			 {
			     $wand imagetype grayscale
			 }]
set Theme([incr j]) [list {lignes de textes seules en haut à gauche} \
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

set Theme([incr j]) [list {lignes de textes seules en haut à droite} \
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

set Theme([incr j]) [list {lignes de textes seules en bas à gauche} \
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

set Theme([incr j]) [list {lignes de textes seules en bas à droite} \
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

set Theme([incr j]) [list {logo seul en haut à gauche + lignes de textes} \
			 {
			     for {set i 0} {$i<$nbLignes} {incr i} {
				 set t  [lindex $infoTexte $i]
				 set laLigne  [lindex $t 0]
				 set x0 [expr { $w - $Xoff - [lindex $t 1] }]
				 set y0 [expr { $h - ($nbLignes - $i) * $hLigne }]
				 $draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
				 $draw annotation $x0 $y0 $laLigne
			     }
			     # insertion logo
			     $wand composite $logo over [expr {int($fa)}] [expr {int($fa)}]
			 }]

set Theme([incr j]) [list {logo en haut à gauche + lignes vert. et horiz. + lignes de textes} \
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
			     $wand composite $logo over [expr {int($Xoff)}] [expr {int($Xoff)}]
			     # les lignes 
			     $draw strokewidth $(user:tLine)
			     $draw strokecolor $userBg
			     $draw line $Xoff [expr {2*$fa + $hL}] $Xoff [expr { $h - $hLigne }]
			     $draw line $Xoff [expr { $h - $hLigne }] \
				 [expr { $w - $largeurMax - $Xoff - .5*$Xoff}] [expr { $h - $hLigne }] 
			     $draw line $xmax $ymax $xmax [expr { $ymax - $hLigne * $nbLignes }]
			 }]

set Theme([incr j]) [list {Encadrement simple} \
			 {
			     $draw strokewidth $(user:tLine)
			     $draw strokecolor $userBg
			     $draw line $Xoff $Xoff $Xoff [expr { $h - $Xoff}]
			     $draw line $Xoff [expr { $h - $Xoff}]\
				 [expr { $w - $Xoff}] [expr { $h - $Xoff }]
			     $draw line [expr { $w - $Xoff}] [expr { $h - $Xoff }]\
				 [expr { $w - $Xoff}] $Xoff
			     $draw line [expr { $w - $Xoff}] $Xoff\
				 $Xoff $Xoff
			 }]

##
