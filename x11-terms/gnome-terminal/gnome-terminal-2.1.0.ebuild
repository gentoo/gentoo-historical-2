# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/gnome-terminal/gnome-terminal-2.1.0.ebuild,v 1.1 2002/10/27 15:21:32 foser Exp $

inherit gnome2 debug

S=${WORKDIR}/${P}
DESCRIPTION="The Gnome Terminal"

HOMEPAGE="http://www.gnome.org/"
KEYWORDS="x86 ppc sparc sparc64 alpha"
SLOT="0"
LICENSE="GPL-2"

RDEPEND="=x11-libs/gtk+-2.1*
	=x11-libs/pango-1.1*
	>=gnome-base/libglade-2.0.1
	>=gnome-base/gconf-1.2.1
	=gnome-base/libgnomeui-2.1*
	>=app-text/scrollkeeper-0.3.11
	>=x11-libs/vte-0.9.0"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	!gnome-base/gnome-core"
# gnome-core overwrite /usr/bin/gnome-terminal

src_compile() {
	elibtoolize

	# you can change vte for zvt 
	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--disable-install-schemas \
		--enable-platform-gnome-2 \
                --with-widget=vzvt || die
	emake || die
}

DOCS="ABOUT-NLS AUTHORS ChangeLog COPYING README* INSTALL NEWS TODO"

