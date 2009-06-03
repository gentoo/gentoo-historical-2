# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xml2doc/xml2doc-20030510-r1.ebuild,v 1.5 2009/06/03 20:27:01 maekke Exp $

inherit eutils

DESCRIPTION="Tool to convert simple XML to a variety of formats (pdf, html, txt, manpage)"

HOMEPAGE="http://xml2doc.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
IUSE="pdf"
SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"

DEPEND=">=dev-libs/libxml2-2.5
	pdf? ( >=media-libs/pdflib-4 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix pointer-related bug detected by a QA notice.
	epatch "${FILESDIR}/${PN}-pointer_fix.patch"

	# Don't strip symbols from binary (bug #152266)
	sed -i -e '/^\s*strip/d' \
		-e '/^CC=/d' \
		-e 's/^\t$(CC) $(LFLAGS).*/\t$(LINK.o) $(L_PDF) $^ -lxml2 -o $(BIN)/' \
		-e '/^\t$(CC) $(CFLAGS) /d' \
		src/Makefile.in
}

src_compile() {
	econf $(use_enable pdf) || die "./configure failed"
	emake || die "Compilation failed"

	cd "${S}/doc"
	"${S}"/src/xml2doc -oM manpage.xml xml2doc.1 || die
}

src_install() {
	# xml2doc's make install is unfortunately broken

	# binary
	dobin src/xml2doc || die

	# documentation
	dodoc BUGS README TODO || die
	docinto examples
	dodoc examples/*.{xml,png} || die

	# manpage
	doman doc/xml2doc.1 || die
}
