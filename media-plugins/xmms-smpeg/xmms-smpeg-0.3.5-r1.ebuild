# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-smpeg/xmms-smpeg-0.3.5-r1.ebuild,v 1.1 2004/04/22 08:27:34 eradicator Exp $

inherit eutils

IUSE="sdl"

MY_PN="smpeg-xmms"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A MPEG Plugin for XMMS"
SRC_URI="ftp://ftp.xmms.org/xmms/plugins/smpeg-xmms/${MY_P}.tar.gz"
HOMEPAGE="http://www.xmms.org/plugins_input.html"

DEPEND=">=media-sound/xmms-1.2.4
	>=media-libs/smpeg-0.4.4-r3
	sdl? ( >=media-libs/libsdl-1.2.2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gcc.patch
}

src_compile() {
	econf `use_enable sdl sdltest` || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING README TODO ChangeLog
}
