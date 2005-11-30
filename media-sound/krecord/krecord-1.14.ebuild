# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/krecord/krecord-1.14.ebuild,v 1.1.1.1 2005/11/30 09:38:27 chriswhite Exp $

IUSE=""

inherit kde

DESCRIPTION="A KDE sound recorder."
HOMEPAGE="http://bytesex.org/krecord.html"
SRC_URI="http://bytesex.org/misc/${PN}_${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc x86"

need-kde 3
#RDEPEND="media-libs/alsa-lib"

src_compile() {
	emake || die
}

src_install() {
	einstall || die
}
