# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-geramik/gtk-engines-geramik-0.24-r3.ebuild,v 1.2 2003/06/26 10:06:53 foser Exp $

inherit gtk-engines2 eutils

MY_PN="Geramik"

IUSE="gtk2"
DESCRIPTION="GTK+1 and GTK+2 Geramik Theme Engine"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=3952"
SRC_URI="http://www.kde-look.org/content/files/3952-${MY_PN}-${PV}.tar.gz"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
LICENSE="GPL-2"
SLOT="2"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}

	epatch ${FILESDIR}/${P}-gentoo.diff
}
