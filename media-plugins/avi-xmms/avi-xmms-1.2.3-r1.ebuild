# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/avi-xmms/avi-xmms-1.2.3-r1.ebuild,v 1.8 2004/07/06 21:06:36 eradicator Exp $

IUSE=""

inherit flag-o-matic

DESCRIPTION="A xmms plugin for AVI/DivX movies"
SRC_URI="http://www.xmms.org/files/plugins/avi-xmms/${P}.tar.gz"
HOMEPAGE="http://www.xmms.org/plugins_input.html"

SLOT="0"
LICENSE="GPL-2"
# Contains x86 assembly
KEYWORDS="-x86 -*"

DEPEND=">=media-sound/xmms-1.2.7-r13
	media-libs/libsdl"

src_unpack() {
	unpack ${A}
	cd ${S}
	# various C++ language fixes
	patch -p1 <${FILESDIR}/avi-xmms-1.2.3-gcc3-gentoo.patch || die
}

src_compile() {
	filter-flags -fno-exceptions

	econf || die
	emake || make || die
}

src_install () {
	make libdir=/usr/lib/xmms/Input DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog README TODO
}
