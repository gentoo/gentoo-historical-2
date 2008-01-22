# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/gwp/gwp-0.4.0-r2.ebuild,v 1.2 2008/01/22 08:04:04 nyhm Exp $

inherit eutils gnome2

DESCRIPTION="GNOME client for the classic PBEM strategy game VGA Planets 3"
HOMEPAGE="http://gwp.lunix.com.ar/"
SRC_URI="http://gwp.lunix.com.ar/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls opengl python"

RDEPEND="=x11-libs/gtk+-2*
	=gnome-base/libgnomeui-2*
	=gnome-base/libglade-2*
	app-text/scrollkeeper
	dev-libs/libpcre
	nls? ( virtual/libintl )
	opengl? ( =x11-libs/gtkglext-1* )
	python? ( =dev-python/pygtk-2* )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_unpack() {
	gnome2_src_unpack
	epatch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-exec-stack.patch
	sed -i \
		-e '/ -O1/d' \
		-e '/ -g$/d' \
		src/Makefile.in \
		|| die "sed failed"
}

src_compile() {
	gnome2_src_compile \
		$(use_enable nls) \
		$(use_enable opengl gtkglext) \
		$(use_enable python)
}

src_install() {
	DOCS="AUTHORS ChangeLog CHANGES README TODO" \
	gnome2_src_install
	rm -rf "${D}"/usr/share/doc/gwp
}
