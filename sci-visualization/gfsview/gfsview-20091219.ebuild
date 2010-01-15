# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/gfsview/gfsview-20091219.ebuild,v 1.2 2010/01/15 19:43:50 bicatali Exp $

EAPI=2
inherit eutils

DESCRIPTION="Graphical viewer for Gerris simulation files."
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=">=x11-libs/gtkglext-1.0.6
	>=x11-libs/gtk+-2.4.0
	x11-libs/startup-notification
	>=sci-libs/gerris-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}-snapshot-091219"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
