# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/xfce-mcs-manager/xfce-mcs-manager-3.99.1.ebuild,v 1.2 2003/08/07 20:14:44 bcowan Exp $ 

IUSE=""
S=${WORKDIR}/${P}

DESCRIPTION="Libraries for XFCE4"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce4-rc1/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND=">=x11-libs/gtk+-2.0.6
	dev-util/pkgconfig
	dev-libs/libxml2
        =xfce-base/libxfce4util-${PV}
        =xfce-base/libxfcegui4-${PV}
	=xfce-base/libxfce4mcs-${PV}"

src_install() {
        make DESTDIR=${D} install || die

        dodoc AUTHORS INSTALL NEWS COPYING README ChangeLog TODO
}
