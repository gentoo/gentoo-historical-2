# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/id3lib/id3lib-3.8.3-r4.ebuild,v 1.7 2006/02/06 15:52:14 s4t4n Exp $

inherit eutils autotools

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Id3 library for C/C++"
HOMEPAGE="http://id3lib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="doc examples"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${P}-zlib.patch"
	epatch "${FILESDIR}/${P}-test_io.patch"
	epatch "${FILESDIR}/${P}-autoconf259.patch"
	epatch "${FILESDIR}/${P}-doxyinput.patch"

	AT_M4DIR="${S}/m4" eautoreconf
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"

	if use doc; then
		cd doc/
		doxygen Doxyfile || die "doxygen failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"

	dodoc AUTHORS ChangeLog HISTORY README THANKS TODO

	# some example programs to be placed in docs dir.
	if use examples; then
		cp -pPR examples ${D}/usr/share/doc/${PF}/examples
		cd ${D}/usr/share/doc/${PF}/examples
		make distclean
	fi

	if use doc; then
		dohtml -r doc
	fi
}
