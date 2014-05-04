#!/bin/sh
# -*-Tcl-*-
# The next line restarts using tclsh \
exec etcl "$0" -- ${1+"$@"}


# auteur : david cobac [string map {# @} david.cobac#gmail.com]
# date   : 15/04/2010
# rev    : 05/06/2010

package require pixane

#set police [pixfont create -builtin arial]
set police [pixfont create -file $(user:fPolice)]

catch {pixane delete p}
pixane create p
pixane load p -file $inFile
catch {pixane delete logo}
pixane create logo
pixane load logo -file $(user:fLogo)

 #if {[regexp {(\$date)|(\$heure)} $(user:lignes) ]} {
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
		set angle 1.5707963267948966
	    } elseif [string equal $v "90 degrees ccw"] {
		set angle -1.5707963267948966
	    }
	}
    }
    ## vérification de la récupération des variables
    if {![info exists date] || ![info exists heure]} {
	tk_messageBox -icon error -message "Erreur de récupération\
de l'heure et/ou de la date
Plusieurs causes sont possibles..."
	return
    }
    ##
#}

set w [pixane width p]
set h [pixane height p]
##
if {$normal eq 0} {
    pixane create np
    pixane resize np $h $w
    pixane blank np
    pixane scale np p -angle $angle
    pixane delete p
    pixane create p
    pixane resize p $h $w
    pixane blank p
    pixane copy p np
    pixane delete np
    set wt $w
    set w $h
    set h $wt
}
##
set wLogo [pixane width logo]
set hLogo [pixane height logo]

set lignes [split [subst $(user:lignes)] \n]
# on supprime les lignes vides
#while {[set ind [lsearch $lignes ""]] ne -1} {
#    set lignes [lreplace $lignes $ind $ind]
#}
set nbLignes [llength $lignes]
set minX $w
set minY $h
## erreur de segmentation sur cette commande !!
foreach {fa fd} [pixfont metrics $police $(user:tPolice)] break

for {set i 0} {$i<$nbLignes} {incr i} {
    set texte [lindex $lignes $i]
    foreach {fw n n} [pixfont measure $police $(user:tPolice) $texte] break
    set Xoff $fa
    set X [expr {$w-$fw-2*$Xoff}]
    set Y [expr {$h-($nbLignes-$i)*($fd+$fa)}]
    pixane color p $(user:couleurf)
    pixane text p [expr {$X+2}] [expr {$Y-2}] -font $police -size $(user:tPolice) -text $texte -align left
    pixane color p $(user:couleur)
    pixane text p $X $Y -font $police -size $(user:tPolice) -text $texte -align left
    #
    if { $X < $minX } {set minX $X}
    if { $Y < $minY } {set minY $Y}
}

set wL $(user:tLogo)
set hL [expr {$wL*$hLogo/$wLogo}] 
set minY [expr {$minY - $fa}]

# exécution des commandes du thème choisi
eval $theme($(user:choixTheme))

if {$test eq 0} {
    file mkdir $(user:dOut)
    eval pixane save p -file [file join $(user:dOut) $(user:fOut)] -format jpeg
} else {
    set format [expr {4/3.}]
    set canvas .h.c
    set wcv [$canvas cget -width]
    set hcv [$canvas cget -height]
    catch {pixane delete q}
    pixane create q
    if {$w > $h} {
	pixane resize q $wcv $hcv
	pixane blank q
	pixane scale q p -to 0 0 -width $wcv 
    } else {
	pixane resize q $wcv $hcv
	pixane blank q
	pixane scale q p -to 0 0 -height $hcv -width [expr {int($hcv/$format)}]
    }
    image create photo cv
    pixcopy q cv
    # hardcoding sur le canvas :(
    .h.c create image 0 0 -image cv -anchor nw
}

pixane delete logo
pixane delete p
