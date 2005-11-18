# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/hyphen_show/hyphen_show-20000425.ebuild,v 1.1 2005/11/18 17:57:01 leonardop Exp $

inherit eutils toolchain-funcs

MY_PN=${PN//_/-}
DESCRIPTION="Show hyphenations in DVI files"
HOMEPAGE="http://packages.debian.org/stable/tex/hyphen-show"
SRC_URI="mirror://debian/pool/main/h/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
S=${WORKDIR}/${MY_PN}-${PV}


src_unpack() {
	unpack "${A}"
	epatch "${FILESDIR}"/${PN}-gcc34.patch
}

src_compile() {
	$(tc-getCC) ${CFLAGS} hyphen_show.c \
		-o hyphen_show || die "Compilation failed"
}

src_install() {
	dobin hyphen_show
	doman hyphen_show.1
	dodoc README.hyphen_show
}
