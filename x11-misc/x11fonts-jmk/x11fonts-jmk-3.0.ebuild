# Copyrigth 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Mikael Hallendal <hallski@gentoo.org>
# Maintainer: Desktop Team
# $Header: /var/cvsroot/gentoo-x86/x11-misc/x11fonts-jmk/x11fonts-jmk-3.0.ebuild,v 1.3 2002/07/08 21:31:07 aliz Exp $

MY_P=jmk-x11-fonts-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="X11 Application Launch Feedback"
SRC_URI="http://www.ntrnet.net/~jmknoble/fonts/${MY_P}.tar.gz"
HOMEPAGE="http://www.ntrnet.net/~jmknoble/fonts/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86

DEPEND="virtual/x11"

src_compile() {
	xmkmf || die

	emake || die
}

src_install() {
	make install INSTALL_DIR='${D}/usr/X11R6/lib/X11/fonts/jmk' || die

	dodoc README NEWS
}
