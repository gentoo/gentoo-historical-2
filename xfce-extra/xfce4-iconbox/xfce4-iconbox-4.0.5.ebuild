# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-iconbox/xfce4-iconbox-4.0.5.ebuild,v 1.8 2004/11/09 03:10:53 vapier Exp $

DESCRIPTION="Xfce4 iconbox"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://hannelore.f1.fhtw-berlin.de/mirrors/xfce4/xfce-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0.6
	dev-libs/libxml2
	=xfce-base/libxfce4util-${PV}
	=xfce-base/libxfcegui4-${PV}
	=xfce-base/libxfce4mcs-${PV}
	=xfce-base/xfce-mcs-manager-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die
	dodoc INSTALL README ChangeLog TODO
}
