# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/p7zip/p7zip-4.20-r1.ebuild,v 1.2 2005/09/14 17:28:41 grobian Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Port of 7-Zip archiver for Unix"
HOMEPAGE="http://p7zip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_src.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~x86"
IUSE="static doc"

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${A}
	cd ${S}
	use static && epatch ${FILESDIR}/p7zip-4.16_x86_static.patch
	sed -i \
		-e "/^CXX=/s:g++:$(tc-getCXX):" \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-e "s:-O2 -s -fPIC:${CXXFLAGS}:" \
		makefile* || die "cleaning up makefiles"
}

src_compile() {
	emake || die "compilation error"
}

src_install() {
	dobin bin/7za || die "dobin"
	dosym 7za /usr/bin/7z

	doman man1/7z.1
	doman man1/7za.1

	if use doc; then
		dodoc ChangeLog README TODO DOCS/*.txt
		dohtml -r DOCS/MANUAL/*
	fi
}
