# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/poedit/poedit-1.2.5.ebuild,v 1.1 2004/07/27 00:15:00 pythonhead Exp $

inherit eutils kde

IUSE="kde"
DESCRIPTION="Cross-platform gettext catalogs (.po files) editor."
SRC_URI="mirror://sourceforge/poedit/${P}.tar.gz"
HOMEPAGE="http://poedit.sourceforge.net/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~x86 ~sparc"

DEPEND=">=x11-libs/wxGTK-2.3.4
	>=sys-libs/db-3"

src_unpack() {
	unpack ${A} || die "Failed to unpack ${A}"
	cd ${S} || die "Failed to cd ${S}"
	epatch ${FILESDIR}/poedit-1.2.5-db4-compilation.patch


}

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

