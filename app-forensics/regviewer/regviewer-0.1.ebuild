# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/regviewer/regviewer-0.1.ebuild,v 1.5 2006/10/29 09:42:37 dragonheart Exp $

inherit eutils

DESCRIPTION="RegViewer is GTK 2.2 based GUI Windows registry file navigator"

HOMEPAGE="http://sourceforge.net/projects/regviewer/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""
RDEPEND="dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/libxml2
	gnome-base/gconf
	gnome-base/libbonobo
	gnome-base/libgnome
	gnome-base/libgnomeui
	gnome-base/orbit
	media-libs/alsa-lib
	media-libs/audiofile
	media-libs/fontconfig
	media-libs/freetype
	media-libs/jpeg
	media-libs/libart_lgpl
	virtual/libc
	sys-libs/zlib
	>=x11-libs/gtk+-2
	x11-libs/pango"

DEPEND="${RDEPEND}
	sys-devel/automake
	sys-devel/autoconf"

src_unpack() {
	unpack "${A}"
	epatch "${FILESDIR}/"${P}-gcc4.patch
}

src_compile() {
	./autogen.sh --prefix=/usr || die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS  ChangeLog  NEWS  README
}
