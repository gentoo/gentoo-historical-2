# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openobex/openobex-1.0.1.ebuild,v 1.10 2004/07/03 18:52:29 kugelfang Exp $

inherit eutils

IUSE=""

RESTRICT="nostrip"	# .a and .la can't be stripped, stripping
			# the .so results in library w/o symbols :-/
			# Danny van Dyk <kugelfang@gentoo.org> 2004/07/03

DESCRIPTION="An implementation of the OBEX protocol used for transferring data to mobile devices"
SRC_URI="mirror://sourceforge/openobex/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/openobex"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"

DEPEND=">=dev-libs/glib-1.2"

src_unpack() {
	unpack ${A}
	cd ${S}
	pwd
	use amd64 && epatch ${FILESDIR}/${P}-shared-object.patch
}

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS}" || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc README AUTHORS NEWS ChangeLog
}
