# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-icon-theme/xfce4-icon-theme-4.1.90.ebuild,v 1.2 2004/11/09 03:11:10 vapier Exp $

DESCRIPTION="Xfce 4 icon theme"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="virtual/x11
	>=x11-libs/gtk+-2.2*
	dev-libs/libxml2
	=xfce-base/libxfce4util-4.1.90
	=xfce-base/libxfcegui4-4.1.90
	=xfce-base/libxfce4mcs-4.1.90
	=xfce-base/xfce-mcs-manager-4.1.90
	=xfce-base/xffm-4.1.90"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	!xfce-extra/xffm-icons"

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog*
}
