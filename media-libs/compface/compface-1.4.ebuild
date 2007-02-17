# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/compface/compface-1.4.ebuild,v 1.26 2007/02/17 17:26:13 grobian Exp $

inherit eutils

IUSE=""

DESCRIPTION="Utilities and library to convert to/from X-Face format"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/apps/graphics/convert/"
SRC_URI="http://www.ibiblio.org/pub/Linux/apps/graphics/convert/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa amd64 ia64 ppc64"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-errno.diff
	epatch ${FILESDIR}/${P}-destdir.diff
}

src_install() {
	dodir /usr/share/man/man{1,3} /usr/{bin,include,$(get_libdir)}
	make DESTDIR="${D}" install || die

	dodoc README ChangeLog
}
