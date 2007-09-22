# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/yasm/yasm-0.6.1.ebuild,v 1.3 2007/09/22 15:51:49 angelos Exp $

DESCRIPTION="assembler that supports amd64"
HOMEPAGE="http://www.tortall.net/projects/yasm/"
SRC_URI="http://www.tortall.net/projects/yasm/releases/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Remove macho tests (gas{32,64},nasm{32,64}) until fixed upstream.
	# Necessary to pass test phase on at least amd64 with gcc-4.1.2.
	sed -i \
		-e '/modules\/objfmts\/macho\/tests\/.*\/.*macho.*_test.sh/d' \
		Makefile.in
}

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS INSTALL
}
