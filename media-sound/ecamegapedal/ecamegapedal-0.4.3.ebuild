# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ecamegapedal/ecamegapedal-0.4.3.ebuild,v 1.12 2005/07/28 20:57:19 caleb Exp $

DESCRIPTION="Ecamegapedal is a real-time effect processor."
HOMEPAGE="http://www.wakkanet.fi/~kaiv/ecamegapedal/"
SRC_URI="http://ecasound.seul.org/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

IUSE="jack"

DEPEND="=x11-libs/qt-3*
	jack? ( media-sound/jack-audio-connection-kit )
	media-sound/ecasound"

src_compile() {
	econf `use_enable jack` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc COPYING NEWS README TODO
}
