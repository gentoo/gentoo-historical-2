# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/poedit/poedit-1.2.3.ebuild,v 1.1 2003/10/30 09:46:03 liquidx Exp $

inherit eutils kde

IUSE="kde"
DESCRIPTION="Cross-platform gettext catalogs (.po files) editor."
SRC_URI="mirror://sourceforge/poedit/${P}.tar.bz2"
HOMEPAGE="http://poedit.sourceforge.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~sparc"

DEPEND=">=x11-libs/wxGTK-2.3.4
	>=sys-libs/db-3"

src_compile() {
	econf || die
	emake || die
}

src_install () {

	einstall \
		datadir=${D}/usr/share \
		GNOME_DATA_DIR=${D}/usr/share \
		KDE_DATA_DIR=${D}/${KDEDIR-/usr}/share || die

	dodoc AUTHORS LICENSE NEWS README TODO
}
