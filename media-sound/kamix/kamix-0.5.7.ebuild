# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kamix/kamix-0.5.7.ebuild,v 1.9 2004/12/19 05:50:17 eradicator Exp $

IUSE=""

inherit kde
need-kde 3

DESCRIPTION="A mixer for KDE and ALSA."
HOMEPAGE="http://kamix.sourceforge.net/"
SRC_URI="mirror://sourceforge/kamix/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86"
DEPEND="${DEPEND}
	>=kde-base/arts-1.2.0
	>=media-libs/alsa-lib-0.9"

S=${WORKDIR}/${PN}

src_compile() {
	kde_src_compile myconf
	myconf="$myconf --enable-vumeter"
	kde_src_compile configure make
}
