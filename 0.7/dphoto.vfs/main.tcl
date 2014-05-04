# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010 -- 04/05/2014

# Création de l'exécutable dans le réperoire de la version
# construite e.g. 0.7 avec la commande :
# etcl -applet wrap -runtime /opt/etcl/bin/etcl dphoto.vfs/

## http://wfr.tcl.tk/1594
# Initialisation eTclKit :
# if {![info exists ::etcl::topdir]} {
#     set ::etcl::topdir [file join [::etcl::etcl vfspath] main]
#     set oldpath $::auto_path
#     set ::auto_path {}
#     foreach p $oldpath {
# 	if {[string first [info name] $p] != -1} {lappend ::auto_path $p}
#     }
#     unset oldpath p
#     if {[file isdirectory [file join $::etcl::topdir lib]]} {
# 	if {[lsearch -exact $::auto_path [file join $::etcl::topdir lib]] < 0} {
# 	    set ::auto_path [linsert $::auto_path 0 [file join $::etcl::topdir lib]]
# 	}
#     }
# }


package require starkit
starkit::startup

#ces deux lignes pour les tests
set ::topdir [file dirname [info script]]
lappend auto_path [file join $::topdir lib]
##
##
set dLibDP [file join $::topdir lib app-dphoto]
## set fDPhoto [file join $dLibDP decPhoto_pixane.tcl]
set fDPhoto [file join $dLibDP decPhoto_tclmagick.tcl]
set fGUI    [file join $dLibDP gui.tcl]
##s et fThemes [file join $dLibDP themes_pixane.tcl]
set fThemes [file join $dLibDP themes_tclmagick.tcl]

source $fThemes

###
package require Tk
package require jpeg
#package require AMappedProgressBar
package require app-dphoto
