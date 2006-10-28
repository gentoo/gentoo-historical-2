# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/bio2jack/bio2jack-0.7.ebuild,v 1.10 2006/10/28 00:25:12 flameeyes Exp $

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.8"

inherit autotools

DESCRIPTION="A library for porting blocked I/O OSS/ALSA audio applications to JACK"
HOMEPAGE="http://bio2jack.sourceforge.net/"
SRC_URI="mirror://sourceforge/bio2jack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ~ppc-macos ppc64 sh sparc x86"
IUSE=""

RDEPEND=">=media-sound/jack-audio-connection-kit-0.80"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dobin bio2jack-config || die
	dodoc AUTHORS ChangeLog NEWS README
}
