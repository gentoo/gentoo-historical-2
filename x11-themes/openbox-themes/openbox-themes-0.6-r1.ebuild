# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/openbox-themes/openbox-themes-0.6-r1.ebuild,v 1.1 2005/01/03 22:42:46 slarti Exp $

DESCRIPTION="A set of themes for Openbox3."
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="http://gumerry.co.uk/themes/"
LICENSE="GPL-2"
KEYWORDS="x86 ppc amd64 ~sparc"
IUSE="gtk"
SLOT="0"

RDEPEND=">=x11-wm/openbox-3.0_beta6
		gtk? (
			|| (
				>=x11-themes/gtk-engines-thinice-2
				x11-themes/gnome-themes
			)
		)"

src_install() {
	dodir /usr/share/themes
	cp -a ${S}/* ${D}/usr/share/themes
}
