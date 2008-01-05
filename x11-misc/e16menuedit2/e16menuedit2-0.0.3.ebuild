# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/e16menuedit2/e16menuedit2-0.0.3.ebuild,v 1.4 2008/01/05 16:18:58 armin76 Exp $

inherit gnome2 eutils

DESCRIPTION="Menu editor for enlightenment DR16 written in GTK2"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sh sparc x86"
IUSE=""

DEPEND=">=x11-wm/enlightenment-0.16
	=x11-libs/gtk+-2*"

src_unpack() {
	gnome2_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${P}-no-docs.patch
}

DOCS="AUTHORS ChangeLog NEWS README TODO"
