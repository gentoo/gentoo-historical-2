# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/kahakai/kahakai-0.2.1.ebuild,v 1.3 2004/04/26 15:05:28 agriffis Exp $

IUSE=""
S=${WORKDIR}/${P}

DESCRIPTION="A language agnostic scriptable window manager based on Waimea."
HOMEPAGE="http://kahakai.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND="=dev-lang/swig-1.3.16
	virtual/xft
	x11-terms/eterm
	media-libs/imlib2
	virtual/x11"

RESTRICT="nostrip"
PROVIDE="virtual/blackbox"

src_compile() {
	./autogen.sh
	econf || die "econf failed"
	emake
}

src_install() {
	einstall

	cd doc
	dodoc AUTHORS INSTALL NEWS COPYING README ChangeLog TODO

	dodir /etc/X11/Sessions
	echo "/usr/bin/kahakai" > ${D}/etc/X11/Sessions/kahakai
	fperms 755 /etc/X11/Sessions/kahakai
}
