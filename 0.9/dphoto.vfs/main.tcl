# auteur : david cobac [string map {# @} david.cobac#free.fr]
# date   : 18/05/2010 -- 08/05/2014

# TclMagick compilé avec : ubuntu 14.04 amd64 / tcl et tk 8.5
# tclkit : tclkit-linux-x86_64 (tclkit 8.5b1)

# obligation du starkit
package require starkit
starkit::startup
set ::topdir [file dirname [info script]]
lappend auto_path [file join $::topdir lib]
# les dépendances embarquées
package require Tk
package require jpeg
package require TclMagick
package require TkMagick
package require app-dphoto
