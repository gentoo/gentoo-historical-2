# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce4-panel/xfce4-panel-4.1.99.2.ebuild,v 1.3 2004/12/18 19:00:34 morfic Exp $

inherit eutils

DESCRIPTION="Xfce 4 panel"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="virtual/x11
	>=x11-libs/gtk+-2.2*
	dev-libs/libxml2
	gnome-base/librsvg
	x11-libs/startup-notification
	=xfce-base/libxfce4util-${PV}
	=xfce-base/libxfcegui4-${PV}
	=xfce-base/libxfce4mcs-${PV}
	=xfce-base/xfce-mcs-manager-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile () {
	unpack ${A}
	cd ${S}
		epatch ${FILESDIR}/getc.patch

	econf
	emake
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog* AUTHORS README* TODO*
}
