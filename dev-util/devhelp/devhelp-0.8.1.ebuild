# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/devhelp/devhelp-0.8.1.ebuild,v 1.2 2004/02/21 04:34:11 vapier Exp $

inherit gnome2

DESCRIPTION="Developer help browser"
HOMEPAGE="http://devhelp.codefactory.se/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc"
IUSE="zlib"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/gnome-vfs-2.2
	=gnome-extra/libgtkhtml-2*
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog README NEWS TODO"
G2CONF="${G2CONF} `use_with zlib`"
