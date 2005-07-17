# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/plib/plib-1.8.4.ebuild,v 1.8 2005/07/17 06:29:45 vapier Exp $

inherit flag-o-matic

DESCRIPTION="multimedia library used by many games"
HOMEPAGE="http://plib.sourceforge.net/"
SRC_URI="http://plib.sourceforge.net/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

DEPEND="virtual/x11
	virtual/opengl"

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
