# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010 -- 05/05/2014

# obligation du starkit
package require starkit
starkit::startup
set ::topdir [file dirname [info script]]
lappend auto_path [file join $::topdir lib]
# les fichiers à sourcer
set dLibDP  [file join $::topdir lib app-dphoto]
set fDPhoto [file join $dLibDP decPhoto_tclmagick.tcl]
set fGUI    [file join $dLibDP gui.tcl]
set fThemes [file join $dLibDP themes_tclmagick.tcl]
# on commence avec les thèmes
source $fThemes
# les dépendances embarquées
package require Tk
package require jpeg
package require TclMagick
package require TkMagick
package require app-dphoto
