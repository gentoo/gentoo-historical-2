# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnomad/gnomad-2.4.4.ebuild,v 1.3 2004/05/10 05:13:18 mr_bones_ Exp $

inherit flag-o-matic gnome2

ALLOWED_FLAGS=""
strip-flags

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="A GNOME2 frontend for Creative Players (Zen, JukeBox, etc ...)"
HOMEPAGE="http://gnomad2.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=gnome-base/libgnomeui-2
	>=media-libs/libnjb-1.1
	>=media-libs/id3lib-3.8.2
	>=gnome-base/gconf-1.2"

RDEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.21"

src_install() {
	make DESTDIR=${D} install || die
	dodir /usr/share/gnome/apps/Multimedia
	cp ${D}/usr/share/applications/${MY_PN}.desktop ${D}/usr/share/gnome/apps/Multimedia
	dodir /usr/share/applnk/Multimedia
	cp ${D}/usr/share/applications/${MY_PN}.desktop ${D}/usr/share/applnk/Multimedia
	dodoc AUTHORS ChangeLog NEWS README TODO
}
