##
set docTheme(0) {logo en haut à gauche + lignes verticale et horizontale + lignes de textes}
set docTheme(1) {logo seul en haut à gauche + lignes de textes}
set docTheme(2) {lignes de textes seules en bas à droite}
##
##
##
set theme(0) {
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
}
##
set theme(1) {
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
}
##
set theme(2) {
    for {set i 0} {$i<$nbLignes} {incr i} {
	set t  [lindex $infoTexte $i]
	set laLigne  [lindex $t 0]
	set x0 [expr { $w - $Xoff - [lindex $t 1] }]
	set y0 [expr { $h - ($nbLignes - $i) * $hLigne }]
	$draw annotation [expr {$x0+2}] [expr {$y0-2}] $laLigne
	$draw annotation $x0 $y0 $laLigne
    }
}
##

