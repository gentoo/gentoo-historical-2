# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/talika/talika-0.49.ebuild,v 1.2 2010/05/31 13:00:16 hwoarang Exp $

EAPI=3

inherit autotools base

DESCRIPTION="Gnome panel applet that lets you switch between open windows using
icons"
HOMEPAGE="http://talika.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libwnck
	dev-cpp/libpanelappletmm"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "/^talikadocdir/s:/doc/talika:/share/doc/${PF}:" Makefile.am
	# need to add missing files to po/POTFILES.in because testsuite fails
	# bug 322163
	echo -e "src/talika.schemas.in\nsrc/talika.server.in" >> po/POTFILES.in
	eautoreconf
}
