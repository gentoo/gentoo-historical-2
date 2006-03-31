# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/plib/plib-1.8.4-r1.ebuild,v 1.1 2006/03/31 22:01:16 seemant Exp $

inherit flag-o-matic eutils

DESCRIPTION="multimedia library used by many games"
HOMEPAGE="http://plib.sourceforge.net/"
SRC_URI="http://plib.sourceforge.net/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
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
	unpack ${A} ; cd ${S}

	epatch "${FILESDIR}"/${P}-gcc41.patch
	epatch "${FILESDIR}"/${P}-too-many-axes.patch

	# Since plib only provides static libraries, force
	# building as PIC or plib is useless to amd64/etc...
	append-flags -fPIC
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog KNOWN_BUGS NOTICE README* TODO*
}
