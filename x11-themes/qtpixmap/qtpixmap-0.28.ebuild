# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/qtpixmap/qtpixmap-0.28.ebuild,v 1.6 2005/06/17 20:08:03 hansmi Exp $

inherit gtk-engines2 eutils

MY_PN="QtPixmap"

IUSE=""
DESCRIPTION="A modified version of the original GTK pixmap engine which follows the KDE color scheme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=7043"
SRC_URI="http://www.cpdrummond.freeuk.com/${MY_PN}-${PV}.tar.gz"
KEYWORDS="alpha ~amd64 ~mips ppc sparc x86"
LICENSE="GPL-2"
SLOT="2"

DEPEND="${DEPEND}
	>=media-libs/imlib-1.8
	dev-util/pkgconfig
	=x11-libs/gtk+-1.2*"

S=${WORKDIR}/${MY_PN}-${PV}
