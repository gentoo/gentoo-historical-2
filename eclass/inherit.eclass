# $Header: /var/cvsroot/gentoo-x86/eclass/inherit.eclass,v 1.2 2001/09/28 19:30:09 danarmak Exp $
# This eclass provides the inherit() function. In the future it will be placed in ebuild.sh, but for now drobbins 
# doesn't want to make a new portage just for my testing, so every eclass/ebuild will source this file manually and
# then inherit(). This way whn the tmie comes for this to move into stable ebuild.sh, we can just delete the source lines.

ECLASSDIR=/usr/portage/eclass

inherit() {
    
    while [ "$1" ]; do
	source ${ECLASSDIR}/${1}.eclass
    shift
    done

}