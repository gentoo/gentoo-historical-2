# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-spc/xmms-spc-0.2.1.ebuild,v 1.10 2004/06/18 05:42:01 eradicator Exp $

IUSE=""

inherit eutils gnuconfig

MY_P=spcxmms-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="SPC Plugun for XMMS"
HOMEPAGE="http://www.self-core.org/~kaoru-k/"
SRC_URI="http://www.self-core.org/~kaoru-k/pub/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

DEPEND="media-sound/xmms"

src_unpack() {
	unpack ${A}

	# Patch spcxmms.c and soundux.xpp
	cd ${S}/xmms-plugin
	mv spcxmms.c spcxmms.c.bak
	sed -e '108a\
	long int i = 0;' -e '115a\
	i++;' -e '116a\
	if (i >= 18300) going = FALSE;' spcxmms.c.bak > spcxmms.c

	cd ${S}/libspc
	mv soundux.cpp soundux.cpp.bak
	sed -e '417a\
	((((int64) hertz * FIXED_POINT) / so.playback_rate) * .980);' soundux.cpp.bak > soundux.cpp
	cd ${S}
	epatch ${FILESDIR}/${P}.patch

	use amd64 && gnuconfig_update
}

src_install() {
	make DESTDIR=${D} libdir=/usr/lib/xmms/Input install || die
	dodoc AUTHORS COPYING NEWS README
}
