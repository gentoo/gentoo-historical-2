# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xffm-icons/xffm-icons-4.0.4.ebuild,v 1.11 2004/11/09 02:17:26 vapier Exp $

DESCRIPTION="Icons for xffm"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.0.6
	dev-libs/libxml2
	>=xfce-base/xffm-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	make DESTDIR=${D} install || die
	dodoc ChangeLog
}
