# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/snownews/snownews-1.5.12-r1.ebuild,v 1.1 2010/03/14 11:26:50 cedk Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Snownews, a text-mode RSS/RDF newsreader"
HOMEPAGE="http://snownews.kcore.de/"
SRC_URI="http://home.kcore.de/~kiza/software/snownews/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="unicode"

DEPEND=">=dev-libs/libxml2-2.5.6
	>=sys-libs/ncurses-5.3
	dev-libs/openssl"

RDEPEND="${DEPEND}
	dev-perl/XML-LibXML
	dev-perl/XML-LibXSLT
	dev-perl/libwww-perl"

pkg_setup() {
	if use unicode && ! built_with_use sys-libs/ncurses unicode; then
		eerror "sys-libs/ncurses must be build with unicode"
		die "${PN} requires sys-libs/ncurses with USE=unicode"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	use unicode && sed -i -e "s/-lncurses/-lncursesw/" \
		configure

	sed -i -e "s/-O2//" \
		configure

	sed -i -e 's/$(INSTALL) -s/$(INSTALL)/' \
		Makefile
}

src_compile() {
	local conf="--prefix=/usr"
	./configure ${conf} || die "configure failed"
	emake CC="$(tc-getCC)" EXTRA_CFLAGS="${CFLAGS}" EXTRA_LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "make install failed"

	dodoc AUTHOR Changelog CREDITS README README.de README.patching
}
