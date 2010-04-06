# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mosml/mosml-2.01-r1.ebuild,v 1.6 2010/04/06 15:17:05 mr_bones_ Exp $

EAPI="3"

inherit eutils

DESCRIPTION="Moscow ML - a lightweight implementation of Standard ML (SML)"
SRC_URI="http://www.itu.dk/people/sestoft/mosml/mos201src.tar.gz"
HOMEPAGE="http://www.itu.dk/people/sestoft/mosml.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}/src"

src_prepare() {
	epatch "${FILESDIR}/${P}-malloc.patch" #154859

	#Fixing pre-stripped files
	sed -i -e "/STRIP/d" mosmlyac/Makefile || die "sed Makefile failed"
	sed -i -e "/STRIP/d" runtime/Makefile || die "sed Makefile failed"

	sed -i -e "s|^CPP=/lib/cpp|CPP=${EPREFIX}/usr/bin/cpp|" Makefile.inc
}

src_configure() { :; }

src_compile() {
	emake CC=$(tc-getCC) CPP="$(tc-getCPP) -P -traditional -Dunix -Umsdos" \
		MOSMLHOME="${EPREFIX}"/opt/mosml world || die
}

src_install() {
	emake -j1 MOSMLHOME="${ED}"/opt/mosml install || die
	rm "${ED}"opt/mosml/lib/camlrunm # This is a bad symlink
	echo "#!${EPREFIX}/opt/mosml/bin/camlrunm" > "${ED}"opt/mosml/lib/header

	dodoc  ../README
	dosym  /opt/mosml/bin/mosml     /usr/bin/mosml
	dosym  /opt/mosml/bin/mosmlc    /usr/bin/mosmlc
	dosym  /opt/mosml/bin/mosmllex  /usr/bin/mosmllex
	dosym  /opt/mosml/bin/mosmlyac  /usr/bin/mosmlyac
	dosym  /opt/mosml/bin/camlrunm  /usr/bin/camlrunm
	dosym  /opt/mosml/bin/camlrunm  /opt/mosml/lib/camlrunm
}
