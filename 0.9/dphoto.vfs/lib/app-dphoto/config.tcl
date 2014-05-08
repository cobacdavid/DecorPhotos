# utilisé pour attribuer à la variable 'user' les valeurs par défaut
proc dphoto::config::copie {} {
    variable ::dphoto::userDefault
    variable ::dphoto::user
    
    array set ::dphoto::user [array get ::dphoto::userDefault]
}

# utilisé pour revenir aux valeurs par défaut
proc dphoto::config::defaut {} {
    variable ::dphoto::userDefault
    variable ::dphoto::user
    
    array set ::dphoto::userDefault [array get ::dphoto::user]
}

# lecture du fichier de configuration
proc dphoto::config::lecture {} {
    variable ::dphoto::files

    set f $::dphoto::files(rc)
    if {[file exists $f]} {
	uplevel #0 source $f
    }
}

# enregistrement des valeurs de la variable 'user'
proc dphoto::config::enregistrement {} {
    variable ::dphoto::user
    variable ::dphoto::files

    set    fh [open $::dphoto::files(rc) w+]
    puts  $fh "array set ::dphoto::user [list [array get ::dphoto::user]]"
    close $fh
}
