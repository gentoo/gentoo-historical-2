# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gpicview/gpicview-0.2.1.ebuild,v 1.6 2010/02/24 09:24:53 ssuominen Exp $

EAPI=2

DESCRIPTION="A Simple and Fast Image Viewer for X"
HOMEPAGE="http://lxde.sourceforge.net/gpicview"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6:2
	media-libs/jpeg:0"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS
}
