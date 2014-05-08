package provide app-dphoto 1.0
##
# auteur : david cobac [string map {# @} david.cobac#gmail.com]
# date   : 29/04/2010
# rev    : 08/05/2014
##
##
set r [file normalize [file dirname [info nameofexecutable]]]
set h [file normalize $::env(HOME)]
##
##
##################################################################
##################################################################
namespace eval dphoto {
    variable userDefault
    variable user
    variable libdir
    variable files
    variable theme
    namespace eval config     {}
    namespace eval gui        {
	variable widgets
	variable generateDphoto
    }
    namespace eval traitement {
	variable exif
	variable tclmagick
    }
}
##
##
set dphoto::libdir  [file join $::topdir lib app-dphoto]
array set dphoto::files "
    rc       [file join $::h decorphoto0.9.rc]
    config   [file join $::dphoto::libdir config.tcl]
    gui      [file join $::dphoto::libdir gui.tcl]
    themes   [file join $::dphoto::libdir themes_tclmagick.tcl]
    decphoto [file join $::dphoto::libdir decPhoto_tclmagick.tcl]
"
##################################################################
##################################################################
# valeurs par défaut
#
# on accède aux valeurs par ("value-oriented")
# dict get $dphoto::userDefault(font) name
#
# on change les valeurs par ("variable-oriented")
# dict set dphoto::userDefault(font) name Helvetica
#
array set ::dphoto::userDefault "
    font {
name Courier
size 60
fg   white
bg   black
}
    theme {
choice 0
multi  0
multiT {}   
}
    line {
fg    white
bg    black
width 2
}
   text {
lignes {le \$exif(date) \u00e0 \$exif(heure)\\n\u00a9 http://github.com/cobacdavid}
}
   logo {
path [file join $::r logo.jpg]
size 200
mode over
}
   images {
inpath          $::r
relativeoutpath dphoto
prefixout       perso_\$inFile
}
"
##################################################################
##################################################################
# on commence avec les thèmes
source $::dphoto::files(themes)
source $::dphoto::files(config)
# on attribue les valeurs par défaut
# à la variable 'user'
dphoto::config::copie
# on lit les valeurs enregistrées
# dans le fichier rc et on écrase dans 'user'
dphoto::config::lecture
############
source $dphoto::files(gui)
############
