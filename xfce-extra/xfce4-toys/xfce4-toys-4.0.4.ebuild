# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-toys/xfce4-toys-4.0.4.ebuild,v 1.11 2004/11/09 02:58:06 vapier Exp $

DESCRIPTION="Xfce4 toys"
HOMEPAGE="http://www.xfce.org"
SRC_URI="http://www.xfce.org/archive/xfce-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0.6
	dev-libs/libxml2
	=xfce-base/xfce4-base-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS INSTALL README ChangeLog TODO
}
