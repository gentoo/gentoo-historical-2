# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mlton/mlton-20040227.ebuild,v 1.3 2004/07/02 04:28:29 eradicator Exp $

inherit eutils

DESCRIPTION="Standard ML optimizing compiler and libraries"
SRC_URI="http://www.mlton.org/download/${P}-1.src.tgz"
HOMEPAGE="http://www.mlton.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="doc"

DEPEND="virtual/libc
dev-libs/gmp
dev-lang/mlton-bin"

src_compile() {
	epatch ${FILESDIR}/${P}-obsolete-flags.patch
	# does not support parallel make
	make
}

src_install() {
	make DESTDIR=${D} install-no-docs

	if use doc; then
		make DESTDIR=${D} TDOC=${D}/usr/share/doc/${P} install-docs
	else
		cd doc && dodoc changelog license/*
	fi
}
