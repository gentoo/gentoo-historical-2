# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gprolog/gprolog-1.2.13.ebuild,v 1.5 2004/06/24 22:49:56 agriffis Exp $

IUSE=""

DEPEND="virtual/glibc"

DESCRIPTION="GNU Prolog is a native Prolog compiler with constraint solving over finite domains (FD)"
HOMEPAGE="http://www.gnu.org"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
S=${WORKDIR}/${P}/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

src_unpack() {
	unpack ${A}
	cd ${S}

	mv Makefile.in Makefile.in.orig
	sed -e "s/TXT_FILES /#TXT_FILES/" Makefile.in.orig > Makefile.in
}

src_compile() {
	econf || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	dodir /usr/bin
	make INSTALL_DIR=${D}/usr \
		LINKS_DIR="" \
		DOC_DIR=/${D}/usr/share/doc/${P} \
		HTML_DIR=${D}/usr/share/doc/${P}/html \
		EXAMPLES_DIR=${D}/usr/share/${P}/examples install || die "install failed"
	cd ${S}/..
	dodoc ChangeLog COPYING INSTALL NEWS PROBLEMS README VERSION
}
