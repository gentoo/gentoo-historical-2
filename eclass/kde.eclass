# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/kde.eclass,v 1.2 2001/09/28 19:30:09 danarmak Exp $
# This is the kde ebuild for std. kde-dependant apps which follow configure/make/make install
# procedures and have std. configure options. 
. /usr/portage/eclass/inherit.eclass || die
inherit c autoconf base || die
ECLASS=kde

DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://www.kde.org/"

DEPEND="${DEPEND} kde-base/kdelibs dev-util/objprelink x11-libs/qt-x11"
RDEPEND="${RDEPEND} kde-base/kdelibs x11-libs/qt-x11"

kde_src_compile() {
    
    while [ "$1" ]; do
	
	case $1 in
	    myconf) 	
		use qtmt 	&& myconf="$myconf --enable-mt"
		use mitshm	&& myconf="$myconf --enable-mitshm"
	        use objprelink	&& myconf="$myconf --enable-objprelink"
		;;
	    configure)
                ./configure --host=${CHOST} --with-x \
		    ${myconf} --with-xinerama || die
		;;
	    make)
	        make || die
		;;
	    all)
		kde_src_compile myconf configure make
		;;
	esac
	
    shift
    done

}

kde_src_install() {
    
    while [ "$1" ]; do

	case $1 in
	    make)
		make install DESTDIR=${D} || die
		;;
	    dodoc)
		dodoc AUTHORS ChangeLog README*
		;;
	    all)
		kde_src_install make dodoc
		;;
	esac
	
    shift
    done
  
}


EXPORT_FUNCTIONS


