# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/golden-xcursors/golden-xcursors-0.7-r1.ebuild,v 1.4 2004/06/25 03:03:13 agriffis Exp $

MY_P="5507-Golden-XCursors-3D-${PV}"
DESCRIPTION="A high quality set of Xfree 4.3.0 animated mouse cursors"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5507"
SRC_URI="http://www.kde-look.org/content/files/$MY_P.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""
DEPEND=""
RDEPEND=">=x11-base/xfree-4.3.0-r2"

src_install() {
	mkdir -p ${D}/usr/share/cursors/xfree/gold/cursors/
	cp -d ${WORKDIR}/${MY_P:5}/gold/cursors/* ${D}/usr/share/cursors/xfree/gold/cursors/ || die
	dodoc ${WORKDIR}/${MY_P:5}/{COPYING,README}
}

pkg_postinst() {
	einfo "To use this set of cursors, edit or create the file ~/.Xdefaults"
	einfo "and add the following line:"
	einfo "Xcursor.theme: gold"
	einfo ""
	einfo "Also, you can change the size by adding a line like:"
	einfo "Xcursor.size: 48"
	einfo ""
	einfo ""
	einfo "To globally use this set of mouse cursors edit the file:"
	einfo "   /usr/share/cursors/xfree/default/index.theme"
	einfo "and change the line:"
	einfo "   Inherits=[current setting]"
	einfo "to"
	einfo "   Inherits=gold"
	einfo "Note this will be overruled by a user's ~/.Xdefaults file"
	einfo ""
	ewarn "If you experience flickering, try setting the following line in"
	ewarn "the Device section of your XF86Config:"
	ewarn "Option  \"HWCursor\"  \"false\""
}
