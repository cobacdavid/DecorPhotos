# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010 -- 05/05/2014

package require starkit
starkit::startup

#ces deux lignes pour les tests
set ::topdir [file dirname [info script]]
lappend auto_path [file join $::topdir lib]
##
set dLibDP [file join $::topdir lib app-dphoto]
set fDPhoto [file join $dLibDP decPhoto_tclmagick.tcl]
set fGUI    [file join $dLibDP gui.tcl]
set fThemes [file join $dLibDP themes_tclmagick.tcl]

source $fThemes

###
package require Tk
package require jpeg
package require TclMagick
package require TkMagick
package require app-dphoto
