# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kamix/kamix-0.6.5.ebuild,v 1.1 2005/11/10 15:30:22 greg_g Exp $

inherit kde

DESCRIPTION="A mixer for KDE and ALSA."
HOMEPAGE="http://kamix.sourceforge.net/"
SRC_URI="mirror://sourceforge/kamix/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=media-libs/alsa-lib-1.0.9"

need-kde 3

S=${WORKDIR}/${PN}

src_compile() {
	myconf="$(use_enable arts vumeter)"

	kde_src_compile
}
