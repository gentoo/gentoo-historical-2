# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/plib/plib-1.8.4.ebuild,v 1.9 2006/01/25 05:26:24 joshuabaergen Exp $

inherit flag-o-matic

DESCRIPTION="multimedia library used by many games"
HOMEPAGE="http://plib.sourceforge.net/"
SRC_URI="http://plib.sourceforge.net/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

RDEPEND="virtual/glut
	virtual/opengl
	media-libs/libsdl"
DEPEND="${RDEPEND}
	|| ( ( x11-proto/xproto
			x11-libs/libX11
			x11-libs/libXt )
		virtual/x11 )"

src_unpack() {
	unpack ${A}
	# Since plib only provides static libraries, force
	# building as PIC or plib is useless to amd64/etc...
	append-flags -fPIC
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog KNOWN_BUGS NOTICE README* TODO*
}
