# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/freebirth/freebirth-0.3.2.ebuild,v 1.6 2004/09/03 15:11:05 dholm Exp $

inherit eutils

DESCRIPTION="Free software bass synthesizer step sequencer"
HOMEPAGE="http://www.bitmechanic.com/projects/freebirth/"
SRC_URI="http://www.bitmechanic.com/projects/freebirth/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*
	=dev-libs/glib-1.2*"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS} $(gtk-config --cflags)" || die
}

src_install() {
	dobin freebirth

	insinto /usr/lib/${PN}/raw
	doins raw/*.raw

	dodoc CHANGES INSTALL NEXT_VERSION README
}

