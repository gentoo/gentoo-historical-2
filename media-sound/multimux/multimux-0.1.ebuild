# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/multimux/multimux-0.1.ebuild,v 1.2 2004/10/08 04:00:38 eradicator Exp $

IUSE=""

DESCRIPTION="combines up to 8 audio mono wave ch. into one big multi ch. wave file."
HOMEPAGE="http://home.zonnet.nl/panteltje/dvd/"
SRC_URI="http://home.zonnet.nl/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"

DEPEND=""

src_compile() {
	emake CFLAGS="$CFLAGS" || die "emake failed"
}

src_install() {
	dobin multimux multidemux
	dodoc CHANGES LICENSE README
}
