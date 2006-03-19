# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gtkhtml/gtkhtml-3.6.2.ebuild,v 1.3 2006/03/19 02:28:10 allanonjl Exp $

inherit gnome2 eutils

DESCRIPTION="Lightweight HTML Rendering/Printing/Editing Engine"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="3.6"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="static"

RDEPEND=">=net-libs/libsoup-2.1.6
	>=x11-libs/gtk+-2.2
	>=gnome-base/libgnomeui-1.112.1
	>=gnome-base/libgnomeprint-2.8
	>=gnome-base/libgnomeprintui-2.2.1
	>=x11-themes/gnome-icon-theme-1.2
	>=gnome-base/libglade-2
	>=gnome-base/libbonoboui-2.2.4
	>=gnome-base/orbit-2
	>=gnome-base/gail-0.13
	!=gnome-extra/gtkhtml-3.1.*"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.30
	dev-util/pkgconfig"

USE_DESTDIR="1"
SCROLLKEEPER_UPDATE="0"
ELTCONF="--reverse-deps"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"
G2CONF="${G2CONF} $(use_enable static)"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-fbsd.patch
}

