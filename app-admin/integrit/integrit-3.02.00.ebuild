# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header:

DESCRIPTION="Integrit is a file integrity verification program"
SRC_URI="http://www.noserose.net/e/integrit/download/${P}.tar.gz"
HOMEPAGE="http://integrit.sourceforge.net"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

UNPACKDIR=integrit-3.02

S=${WORKDIR}/${UNPACKDIR}

src_compile() {
	econf --prefix=/usr
	emake || die
	emake utils || die
	cd ${S}/doc
	emake || die
	cd ${S}/hashtbl
	emake hashtest || die
	mv README README.hashtbl
}

src_install() {
	into /usr

	dosbin integrit
	dolib libintegrit.a
	dodoc Changes HACKING INSTALL LICENSE README todo.txt

	cd ${S}/utils
	dosbin i-viewdb
	dobin i-ls	

	cd ${S}/hashtbl
	dolib libhashtbl.a
	insinto /usr/include
	doins hashtbl.h		
	dobin hashtest
	dodoc README.hashtbl

	cd ${S}/doc
	doman i-ls.1 i-viewdb.1 integrit.1
	doinfo integrit.info

	cd ${S}/examples
	docinto examples
	dodoc *
}

pkg_postinst() {
	einfo "It is recommended that the integrit binary is copied to a secure"
	einfo "location and re-copied at runtime or run from a secure medium."
	einfo "You should also create a configuration file (see examples)."
	echo
}
