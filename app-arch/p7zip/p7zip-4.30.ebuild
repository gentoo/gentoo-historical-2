# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/p7zip/p7zip-4.30.ebuild,v 1.2 2006/01/31 21:26:56 hanno Exp $

inherit eutils toolchain-funcs multilib

DESCRIPTION="Port of 7-Zip archiver for Unix"
HOMEPAGE="http://p7zip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_src_all.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="static doc"

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/${P}-gcc41.diff
	use static && epatch "${FILESDIR}"/p7zip-4.16_x86_static.patch
	sed -i \
		-e "/^CXX=/s:g++:$(tc-getCXX):" \
		-e "/^CC=/s:gcc:$(tc-getCC):" \
		-e "s:-O1 -s:${CXXFLAGS}:" \
		makefile* || die "cleaning up makefiles"
}

src_compile() {
	emake all2 || die "compilation error"
}

src_install() {
	# this wrappers can not be symlinks, p7zip should be called with full path
	make_wrapper 7za "/usr/lib/${PN}/7za"
	make_wrapper 7z "/usr/lib/${PN}/7z"

	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/7z bin/7za bin/7zCon.sfx || die "doexe bins"
	exeinto /usr/$(get_libdir)/${PN}/Codecs
	doexe bin/Codecs/* || die "doexe Codecs"
	exeinto /usr/$(get_libdir)/${PN}/Formats
	doexe bin/Formats/* || die "doexe Formats"

	doman man1/7z.1 man1/7za.1
	dodoc ChangeLog README TODO

	if use doc ; then
		dodoc DOCS/*.txt
		dohtml -r DOCS/MANUAL/*
	fi
}
