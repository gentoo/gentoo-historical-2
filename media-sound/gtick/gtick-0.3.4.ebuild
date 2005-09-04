# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gtick/gtick-0.3.4.ebuild,v 1.2 2005/09/04 11:02:21 flameeyes Exp $

IUSE=""

DESCRIPTION="a metronome application supporting different meters and speeds ranging"
HOMEPAGE="http://www.antcom.de/gtick/"
SRC_URI="http://www.antcom.de/gtick/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc amd64"

DEPEND=">=x11-libs/gtk+-2.0"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
