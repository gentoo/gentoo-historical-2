# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-geramik/gtk-engines-geramik-0.26.ebuild,v 1.5 2004/03/14 00:45:01 geoman Exp $

inherit gtk-engines2 eutils

MY_PN="Geramik"

IUSE="gtk2"
DESCRIPTION="GTK+1 and GTK+2 Geramik Theme Engine"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=3952"
SRC_URI="http://www.kde-look.org/content/files/3952-${MY_PN}-${PV}.tar.gz"
KEYWORDS="~x86 ~ppc ~sparc alpha ~amd64 ~mips"
LICENSE="GPL-2"
SLOT="2"

DEPEND="${DEPEND}
	dev-util/pkgconfig
	>=x11-themes/qtpixmap-0.25"

S=${WORKDIR}/${MY_PN}-${PV}

