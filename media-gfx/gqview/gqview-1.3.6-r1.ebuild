# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gqview/gqview-1.3.6-r1.ebuild,v 1.1 2003/12/16 23:14:53 avenj Exp $

IUSE="nls"

DESCRIPTION="A GTK-based image browser"
SRC_URI="mirror://sourceforge/gqview/${P}.tar.gz"
HOMEPAGE="http://gqview.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"

DEPEND="media-libs/libpng
	>=x11-libs/gtk+-2.2.0"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	epatch ${FILESDIR}/rotate_crash_fix.patch

	econf `use_enable nls` || die
	emake || die "emake failed"
}

src_install() {
	einstall GNOME_DATADIR=${D}/usr/share || die

	# Don't remove duplicate README, the program looks for it. (bug 30111)
	# rm -rf ${D}/usr/share/gqview
	dodoc AUTHORS ChangeLog README TODO || die "dodoc failed"
}
