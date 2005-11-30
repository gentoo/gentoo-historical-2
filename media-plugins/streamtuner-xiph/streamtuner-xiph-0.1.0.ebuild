# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/streamtuner-xiph/streamtuner-xiph-0.1.0.ebuild,v 1.1.1.1 2005/11/30 10:07:25 chriswhite Exp $

DESCRIPTION="A plugin for Streamtuner to play xiph.org streams."
SRC_URI="http://savannah.nongnu.org/download/streamtuner/${P}.tar.gz"
HOMEPAGE="http://www.nongnu.org/streamtuner/"

IUSE=""
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
LICENSE="BSD"

DEPEND=">=net-misc/streamtuner-0.12.0
	>=media-libs/libvorbis-1.0"

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog NEWS README
}
