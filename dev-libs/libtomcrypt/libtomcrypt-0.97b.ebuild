# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtomcrypt/libtomcrypt-0.97b.ebuild,v 1.1 2004/07/24 00:38:42 vapier Exp $

inherit eutils

DESCRIPTION="modular and portable cryptographic toolkit"
HOMEPAGE="http://libtomcrypt.org/"
SRC_URI="http://libtomcrypt.org/files/crypt-${PV}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="doc"

DEPEND="doc? ( virtual/tetex app-text/ghostscript )"

src_unpack() {
	unpack ${A}
	cd ${S}
	use doc || sed -i '/^install:/s:docs::' makefile
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc authors changes
	if use doc ; then
		docinto examples ; dodoc examples/*
		docinto notes ; dodoc notes/*
		docinto demos ; dodoc demos/*
	fi
}
