# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/devhelp/devhelp-0.9.3.ebuild,v 1.3 2004/12/15 12:50:07 gustavoz Exp $

inherit gnome2 eutils

DESCRIPTION="Developer help browser"
HOMEPAGE="http://www.imendio.com/projects/devhelp/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~amd64"
IUSE="zlib"

RDEPEND=">=x11-libs/gtk+-2.4
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/gnome-vfs-2.2
	>=gnome-base/libglade-2
	net-www/mozilla
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog README NEWS TODO"

G2CONF="${G2CONF} $(use_with zlib) --with-mozilla=mozilla"

src_unpack() {

	unpack ${A}

	cd ${S}
	# fix mozilla includes
	epatch ${FILESDIR}/${P}-fix_includes.patch

}
