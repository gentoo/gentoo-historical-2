# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfwm4-themes/xfwm4-themes-4.0.3.ebuild,v 1.6 2004/04/17 19:22:44 aliz Exp $

IUSE=""
DESCRIPTION="Xfwm themes"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce-${PV}/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ia64 x86 ~ppc alpha sparc ~amd64 ~hppa ~mips"

DEPEND=">=x11-libs/gtk+-2.0.6
	dev-util/pkgconfig
	dev-libs/libxml2
	>=xfce-base/xfwm4-${PV}"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS INSTALL NEWS COPYING README ChangeLog TODO
}
