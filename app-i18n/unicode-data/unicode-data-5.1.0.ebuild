# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/unicode-data/unicode-data-5.1.0.ebuild,v 1.2 2008/06/04 14:23:54 aballier Exp $

DESCRIPTION="Unicode data from unicode.org"
HOMEPAGE="http://unicode.org/"
SRC_URI="mirror://debian/pool/main/u/${PN}/${PN}_${PV}.orig.tar.gz"
LICENSE="unicode"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./*
}

src_compile() {
	rm *.zip
}

src_install() {
	cd "${WORKDIR}"
	dodir /usr/share/
	mv "${S}" "${D}/usr/share/${PN}" || die "mv failed"
}
