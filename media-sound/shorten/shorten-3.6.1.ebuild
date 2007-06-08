# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shorten/shorten-3.6.1.ebuild,v 1.2 2007/06/08 17:04:55 aballier Exp $

inherit eutils

IUSE=""

DESCRIPTION="fast, low complexity waveform coder (i.e. audio compressor)"
HOMEPAGE="http://shnutils.freeshell.org/shorten/"
SRC_URI="http://shnutils.freeshell.org/shorten/dist/src/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-tests.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
