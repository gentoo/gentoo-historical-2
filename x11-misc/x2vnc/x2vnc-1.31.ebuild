# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2 
# Author J Robert Ray <jrray@jrray.org>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/x2vnc/x2vnc-1.31.ebuild,v 1.3 2002/07/08 21:44:10 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Control a remote computer running VNC from X"
SRC_URI="http://www.hubbe.net/~hubbe/${P}.tar.gz"
HOMEPAGE="http://www.hubbe.net/~hubbe/x2vnc.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/x11"

src_compile() {

        xmkmf || die
        make || die

}

src_install () {

	make DESTDIR=${D} install || die

}


