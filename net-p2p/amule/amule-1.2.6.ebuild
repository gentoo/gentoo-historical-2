# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/amule/amule-1.2.6.ebuild,v 1.2 2004/03/01 06:18:54 eradicator Exp $

MY_P=${P/m/M}
S=${WORKDIR}/${MY_P}

DESCRIPTION="aNOTHER wxWindows based eMule P2P Client"
HOMEPAGE="http://sourceforge.net/projects/amule"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls"

DEPEND=">=x11-libs/wxGTK-2.4.2
	>=net-ftp/curl-7.11.0
	>=sys-libs/zlib-1.2.1"

src_compile() {
	econf `use_enable nls` || die
	emake -j1 || die
}

src_install() {
	make DESTDIR=${D} install || die
}
