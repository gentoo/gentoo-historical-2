# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cbrpager/cbrpager-0.9.20.ebuild,v 1.1 2010/04/07 20:31:42 scarabeus Exp $

EAPI=3
inherit base

DESCRIPTION="a simple comic book pager."
HOMEPAGE="http://cbrpager.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="|| ( app-arch/unrar app-arch/rar )
	>=gnome-base/libgnomeui-2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

src_install() {
	base_src_install
	dodoc AUTHORS ChangeLog CONTRIBUTORS NEWS README TODO || die
	make_desktop_entry ${PN} "CBR Pager" ${PN} "Graphics;Viewer;Amusement;GTK"
}
