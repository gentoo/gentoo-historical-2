# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfcegui4/libxfcegui4-4.1.91.ebuild,v 1.1 2004/11/01 02:48:27 bcowan Exp $

IUSE="xinerama"
DESCRIPTION="Libraries for Xfce 4"
SRC_URI="http://www.xfce.org/archive/xfce-${PV}/src/${P}.tar.gz"
HOMEPAGE="http://xfce.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~ia64 ~x86 ~ppc ~alpha ~sparc ~amd64 ~hppa ~mips"

RDEPEND="virtual/x11
	>=x11-libs/gtk+-2.2*
	dev-libs/libxml2
	x11-libs/startup-notification
	=xfce-base/libxfce4util-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
	    `use_enable xinerama` || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog* AUTHORS README*
}