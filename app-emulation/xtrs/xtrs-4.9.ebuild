# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xtrs/xtrs-4.9.ebuild,v 1.14 2005/01/01 14:21:25 eradicator Exp $

inherit eutils gcc

DESCRIPTION="RadioShack TRS80 Emulator, inc. FreeWare ROM & LDOS Image"
HOMEPAGE="http://www.tim-mann.org/trs80.html"
SRC_URI="http://home.gwi.net/~plemon/sources/${P}.tar.gz
	 http://home.gwi.net/~plemon/support/disks/xtrs/ld4-631.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="sys-libs/ncurses
	sys-libs/readline
	virtual/x11"

src_unpack() {
	### make doesn't play nicely with the usual ${PREFIX} behaviour, but relies
	### on an external Makefile.local to set compiletime options, and default
	### behavious.  we'll patch it here, to make our install sane.
	unpack ${P}.tar.gz
	cd ${WORKDIR}
	epatch "${FILESDIR}/${P}-gentoo.diff"
}

src_compile() {
	emake DEBUG="${CFLAGS}" CC="$(gcc-getCC)" || die "emake failed"
}

src_install() {
	dodir /usr/bin /usr/share/xtrs/disks /usr/share/man/man1
	make install || die "make install failed"
	dodoc README xtrsrom4p.README

	#  OSS rom images & an lsdos image
	tar \
		-C ${D}/usr/share/xtrs/ \
		--no-same-owner \
		-zxvf "${DISTDIR}/ld4-631.tar.gz"  || die "tar failed"
}
