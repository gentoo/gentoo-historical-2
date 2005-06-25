# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcdaudio/libcdaudio-0.99.12.ebuild,v 1.7 2005/06/25 14:54:54 gustavoz Exp $

IUSE=""

inherit eutils

DESCRIPTION="Library of cd audio related routines."
HOMEPAGE="http://libcdaudio.sourceforge.net/"
SRC_URI="mirror://sourceforge/libcdaudio/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ppc ppc64 sparc x86"

src_unpack() {
	unpack ${A}

	cd ${S}
	# CAN-2005-0706 (#84936)
	epatch ${FILESDIR}/${PN}-0.99-CAN-2005-0706.patch
}

src_compile() {
	econf --enable-threads || die "configure failed"
	emake || die "compile problem."
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangLog NEWS README TODO
}
