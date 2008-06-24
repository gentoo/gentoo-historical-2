# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/epos/epos-2.5.37-r1.ebuild,v 1.1 2008/06/24 20:30:42 drac Exp $

inherit eutils autotools

DESCRIPTION="language independent text-to-speech system"
HOMEPAGE="http://epos.ure.cas.cz/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-text/sgmltools-lite-3.0.3-r9"
RDEPEND=""

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc43.patch"
	sed -i -e "s/CCC/#CCC/" configure.ac

	eautoreconf
}

src_compile() {
	econf --enable-charsets --disable-portaudio
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	mv "${D}/usr/bin/say" "${D}/usr/bin/epos_say"

	doinitd "${FILESDIR}/eposd"

	dodoc WELCOME THANKS Changes "${FILESDIR}/README.gentoo"
}
