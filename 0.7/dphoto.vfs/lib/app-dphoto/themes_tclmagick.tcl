set theme(0) {
    # le logo
    $logo resize $wL $hL 
    $wand composite $logo over [expr {int($fa)}] [expr {int($fa)}]
    # ligne horizontale basse
    $draw strokewidth $(user:tLine)
    $draw strokecolor $userBg
    # $draw strokelinecap butt
    $draw line $fa $Y [expr {$minX-$fa}] $Y 
    # ligne verticale gauche
    $draw line $fa [expr {2*$fa + $hL}] $fa $Y
    # ligne verticale droite
    $draw line [expr {$w-.5*$Xoff}] [expr {$Y-$fd}] [expr {$w-.5*$Xoff}] $minY
}
set docTheme(0) {logo en haut à gauche + lignes verticale et horizontale + lignes de textes}

set theme(1) {
    # le logo 
    #pixane scale p logo -to $fa $fa -width $wL -height $hL -quality 9
    $logo resize $wL $hL 
    $wand composite $logo over [expr {int($fa)}] [expr {int($fa)}]
}
set docTheme(1) {logo seul en haut à gauche + lignes de textes}

set theme(2) {
}
set docTheme(2) {lignes de textes seules}
