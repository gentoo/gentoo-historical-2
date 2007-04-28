# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/epos/epos-2.5.37.ebuild,v 1.3 2007/04/28 17:18:13 swegener Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

IUSE="portaudio"

inherit eutils autotools

DESCRIPTION="language independent text-to-speech system"
HOMEPAGE="http://epos.ure.cas.cz/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="portaudio? ( =media-libs/pablio-18*
				  >=media-libs/portaudio-18.1-r3
				  <media-libs/portaudio-19_alpha1 )"

DEPEND=">=app-text/sgmltools-lite-3.0.3-r9
	${RDEPEND}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${PN}-2.5.35-sysportaudio.patch"

	eautoreconf
}

src_compile() {
	econf $(use_enable portaudio) --enable-charsets
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	mv "${D}/usr/bin/say" "${D}/usr/bin/epos_say"

	doinitd "${FILESDIR}/eposd"

	dodoc WELCOME THANKS Changes "${FILESDIR}/README.gentoo"
}
