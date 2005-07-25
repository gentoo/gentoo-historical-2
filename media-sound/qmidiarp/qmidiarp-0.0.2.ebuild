# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qmidiarp/qmidiarp-0.0.2.ebuild,v 1.6 2005/07/25 17:52:54 caleb Exp $

IUSE=""

inherit eutils qt3

DESCRIPTION="MIDI Arpeggiator QMidiArp"
HOMEPAGE="http://alsamodular.sourceforge.net/"
SRC_URI="mirror://sourceforge/alsamodular/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND="$(qt_min_version 3.2)
	>=media-libs/alsa-lib-0.9.0"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-fix_qtdir_in_makefile.patch
}

src_compile() {
	emake || die
}

src_install() {
	dobin qmidiarp
	dodoc LICENSE README
	insinto /usr/share/${PN}
	doins demo.qma demo_up_down.qma
}
