# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ecamegapedal/ecamegapedal-0.4.3.ebuild,v 1.5 2004/04/22 08:18:58 eradicator Exp $

DESCRIPTION="Ecamegapedal is a real-time effect processor."
HOMEPAGE="http://www.wakkanet.fi/~kaiv/ecamegapedal/"
SRC_URI="http://ecasound.seul.org/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE="jack"

DEPEND="x11-libs/qt \
	jack? ( virtual/jack )\
	media-sound/ecasound"

src_compile() {
	econf `use_enable jack` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc COPYING NEWS README TODO
}
