# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/noweb/noweb-2.9-r1.ebuild,v 1.1 2002/03/21 10:36:07 danarmak Exp $

S=${WORKDIR}/src
#SRC_URI="ftp://ftp.dante.de/tex-archive/web/noweb/src.tar.gz"
SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/distfiles/noweb-src-${PV}.tar.gz"

HOMEPAGE="http://www.eecs.harvard.edu/~nr/noweb/"
DESCRIPTION="a literate programming tool, lighter than web"

DEPEND="sys-devel/gcc
	app-text/tetex
	sys-apps/gawk"

src_unpack() {
    
    unpack ${A}
    cd ${S}
    patch -p0 <${FILESDIR}/${PF}-gentoo.diff || die
    
}

src_compile() {
    
    emake || die

}

src_install () {

    make DESTDIR=${D} install || die
    
    [ -x /usr/bin/nawk ] || dosym /usr/bin/gawk /usr/bin/nawk

}

pkg_postinst() {

    einfo "Running texhash to complete installation.."
    addwrite "/var/lib/texmf"
    addwrite "/usr/share/texmf"
    addwrite "/var/cache/fonts"
    texhash
}
