# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gnome-blog/gnome-blog-0.7-r1.ebuild,v 1.2 2004/05/07 15:38:05 kugelfang Exp $

inherit eutils gnome2

DESCRIPTION="Post entries to your blog right from the Gnome panel"
HOMEPAGE="http://www.gnome.org/~seth/gnome-blog/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND=">=dev-python/pygtk-2
	>=gnome-base/gconf-2"

RDEPEND="${DEPEND}
	dev-python/gnome-python"

DOCS="AUTHORS ChangeLog COPYING README TODO"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-blogger_fix.patch
}

