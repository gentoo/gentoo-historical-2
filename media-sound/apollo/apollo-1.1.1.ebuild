# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/apollo/apollo-1.1.1.ebuild,v 1.5 2002/05/27 17:27:38 drobbins Exp $

S=${WORKDIR}/${P}-1

DESCRIPTION="A Qt-based front-end to mpg123"

SRC_URI="mirror://sourceforge/apolloplayer/apollo-src-1.1.1-1.tar.bz2"

HOMEPAGE="http://www.apolloplayer.org"

DEPEND="=x11-libs/qt-x11-2.3*"

RDEPEND=">=media-sound/mpg123-0.59r"

src_unpack() {

   cd ${WORKDIR}
   unpack apollo-src-1.1.1-1.tar.bz2
   cd ${S}
   mv install.sh install.sh.orig
   cat install.sh.orig | sed -e 's:$PREFIX/local:$PREFIX:g' > install.sh
}

src_compile() {

    make || die
    
}

src_install () {
    local myconf
    if [ "`use kde`" ]
    then
        # FIXME: won't work when multiple versions of KDE is installed
	# IFIXEDYOU: danarmak: kde dir must *always* be determined via
	# $KDEDIR. If $KDEDIR doesn't do the job, fix it, don't work
	# around it.
        myconf="--with-kde=${KDEDIR}"
        dodir ${KDEDIR}/share/applnk/Multimedia
    fi
    
    dodir usr/bin
    echo `pwd`
    sh install.sh --prefix=${D}/usr $myconf
    
}

