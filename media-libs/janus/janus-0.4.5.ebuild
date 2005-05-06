# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/janus/janus-0.4.5.ebuild,v 1.8 2005/05/06 03:21:09 swegener Exp $

IUSE="gtk"

DESCRIPTION="A UI and widget library which employs an extensible XML like data structure and provides an abstract instance of a UI"
SRC_URI="ftp://victor.worldforge.org/pub/worldforge/libs/janus/${P}.tar.gz"
HOMEPAGE="http://www.worldforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -sparc"

DEPEND=">=dev-libs/libsigc++-1.0
	>=media-libs/libsdl-1.2.3-r1
	gtk? ( >=x11-libs/gtk+-1.2.8 )"

src_compile() {

	econf || die
	emake || die

}

src_install() {

	make DESTDIR=${D} install || die

}
