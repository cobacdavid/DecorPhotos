set theme(0) {
    # le logo 
    #pixane scale p logo -to $fa $fa -width $wL -height $hL -quality 9
    # ligne horizontale basse
    #pixane line p $fa $Y [expr {$minX-$fa}] $Y -width $(user:tLine)
    # ligne verticale gauche
    #pixane line p $fa [expr {2*$fa + $hL}] $fa $Y -width $(user:tLine)
    # ligne verticale droite
    #pixane line p [expr {$w-$Xoff}] $Y [expr {$w-$Xoff}] $minY -width $(user:tLine)
}
set docTheme(0) {logo en haut à gauche + lignes verticale et horizontale + lignes de textes}

set theme(1) {
    # le logo 
    #pixane scale p logo -to $fa $fa -width $wL -height $hL -quality 9
}
set docTheme(1) {logo seul en haut à gauche + lignes de textes}

set theme(2) {
}
set docTheme(2) {lignes de textes seules}
