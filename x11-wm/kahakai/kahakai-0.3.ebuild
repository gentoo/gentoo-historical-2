# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/kahakai/kahakai-0.3.ebuild,v 1.2 2004/04/26 15:05:28 agriffis Exp $

IUSE="truetype xinerama"
S=${WORKDIR}/${P}

DESCRIPTION="A language agnostic scriptable window manager based on Waimea."
HOMEPAGE="http://kahakai.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND="virtual/x11
	truetype? ( virtual/xft )
	<dev-lang/swig-1.3.18
	media-libs/imlib2
	x11-terms/eterm"

PROVIDE="virtual/blackbox"

src_compile() {
	./autogen.sh
	econf \
		`use_enable xinerama` \
		`use_enable truetype xft` \
		|| die
	emake || die
}

src_install() {
	einstall || die
	cd doc
	dodoc AUTHORS INSTALL NEWS COPYING README ChangeLog TODO

	exeinto /etc/X11/Sessions
	echo "/usr/bin/kahakai" > ${T}/kahakai
	doexe ${T}/kahakai
}
