# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/poedit/poedit-1.2.1.ebuild,v 1.3 2003/03/25 02:14:23 liquidx Exp $

inherit eutils kde

DESCRIPTION="Cross-platform gettext catalogs (.po files) editor."
SRC_URI="mirror://sourceforge/poedit/${P}.tar.bz2"
HOMEPAGE="http://poedit.sourceforge.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~sparc"

DEPEND=">=x11-libs/wxGTK-2.3.4
	>=sys-libs/db-3"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo_make_paths.patch
}

src_compile() {
	autoconf
	automake

	econf || die
	emake || die
}

src_install () {
	einstall \
		datadir=${D}/usr/share \
		GNOME_DATA_DIR=${D}/usr/share || die
        KDE_DATA_DIR=${D}/${KDEDIR}/share || die

	dodoc AUTHORS LICENSE NEWS README TODO
}
