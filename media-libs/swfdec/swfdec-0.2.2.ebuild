# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/swfdec/swfdec-0.2.2.ebuild,v 1.6 2004/06/24 23:23:56 agriffis Exp $

inherit eutils

DESCRIPTION="Macromedia Flash decoding library"
HOMEPAGE="http://swfdec.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc ~alpha"

IUSE="X mozilla"

DEPEND=">=x11-libs/gtk+-2.0
		gnome-base/gnome-libs
		>=sys-libs/zlib-1.1.4
		media-sound/madplay
		mozilla? ( >=net-www/mozilla-1.0.0 )"
#RDEPEND=""

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${P}.tar.gz
	cd ${P}
	use mozilla && {
		epatch ${FILESDIR}/swfdec-mozilla.patch
	}
}

src_compile() {
	local myconf

	use X && myconf="$myconf --with-x"

	use mozilla && {
		PATH=/usr/lib/mozilla:$PATH
	}
	econf $myconf || die "econfig failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die
}
