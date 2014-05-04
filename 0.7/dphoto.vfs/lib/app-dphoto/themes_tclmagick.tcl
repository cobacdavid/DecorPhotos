set theme(0) {
     for {set i 0} {$i<$nbLignes} {incr i} {
	set texte [lindex $lignes $i]
	foreach { cw ch fa fd fw fh ha } [$wand queryfontmetrics $draw $texte] break
	set Xoff $cw
	set X [expr {$w-$fw-1*$Xoff}]
	# ATTENTION $fd est négatif !
	# ou encore pour la ligne suivante : set Y [expr {$h-($nbLignes-$i)*(-$fd+$fa)}]
	set Y [expr {$h-($nbLignes-$i)*($fa)}]
	$draw annotation [expr {$X+2}] [expr {$Y-2}] $texte
	$draw annotation $X $Y $texte
	if { $X < $minX } {set minX $X}
	if { $Y < $minY } {set minY $Y}
    }
    # insertion logo
    set wL   $(user:tLogo)
    set hL   [expr {$wL*$hLogo/$wLogo}] 
    set minY [expr {$minY - $fa}]
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
    for {set i 0} {$i<$nbLignes} {incr i} {
	set texte [lindex $lignes $i]
	foreach { cw ch fa fd fw fh ha } [$wand queryfontmetrics $draw $texte] break
	set Xoff $cw
	set X [expr {$w-$fw-1*$Xoff}]
	# ATTENTION $fd est négatif !
	# ou encore pour la ligne suivante : set Y [expr {$h-($nbLignes-$i)*(-$fd+$fa)}]
	set Y [expr {$h-($nbLignes-$i)*($fa)}]
	$draw annotation [expr {$X+2}] [expr {$Y-2}] $texte
	$draw annotation $X $Y $texte
	if { $X < $minX } {set minX $X}
	if { $Y < $minY } {set minY $Y}
    }
    # insertion logo
    set wL   $(user:tLogo)
    set hL   [expr {$wL*$hLogo/$wLogo}] 
    set minY [expr {$minY - $fa}]
    # le logo
    $logo resize $wL $hL 
    $wand composite $logo over [expr {int($fa)}] [expr {int($fa)}]
}
set docTheme(1) {logo seul en haut à gauche + lignes de textes}

set theme(2) {
    for {set i 0} {$i<$nbLignes} {incr i} {
	set texte [lindex $lignes $i]
	foreach { cw ch fa fd fw fh ha } [$wand queryfontmetrics $draw $texte] break
	set Xoff $cw
	set X [expr {$w-$fw-1*$Xoff}]
	# ATTENTION $fd est négatif !
	# ou encore pour la ligne suivante : set Y [expr {$h-($nbLignes-$i)*(-$fd+$fa)}]
	set Y [expr {$h-($nbLignes-$i)*($fa)}]
	$draw annotation [expr {$X+2}] [expr {$Y-2}] $texte
	$draw annotation $X $Y $texte
	if { $X < $minX } {set minX $X}
	if { $Y < $minY } {set minY $Y}
    }
}
set docTheme(2) {lignes de textes seules en bas à droite}
