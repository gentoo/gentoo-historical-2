# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xffm-icons/xffm-icons-4.0.5.ebuild,v 1.7 2004/06/24 22:04:23 agriffis Exp $

IUSE=""

DESCRIPTION="Icons for xffm"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://hannelore.f1.fhtw-berlin.de/mirrors/xfce4/xfce-${PV}/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ia64 x86 ppc alpha sparc amd64 hppa ~mips"

RDEPEND=">=x11-libs/gtk+-2.0.6
	dev-libs/libxml2
	>=xfce-base/xffm-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die
	dodoc ChangeLog
}
