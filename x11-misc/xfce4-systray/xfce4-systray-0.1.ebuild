# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xfce4-systray/xfce4-systray-0.1.ebuild,v 1.2 2003/06/25 18:36:17 bcowan Exp $

IUSE=""
S=${WORKDIR}/${P}

DESCRIPTION="Xfce4 system tray"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://sourceforge/xfce/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND=">=x11-libs/gtk+-2.0.6
	dev-util/pkgconfig
	dev-libs/libxml2
        =x11-libs/libxfce4util-3.91.0
        =x11-libs/libxfcegui4-3.91.0
        =x11-libs/libxfce4mcs-3.91.0
	=x11-misc/xfce-mcs-manager-3.91.0
	=x11-misc/xfce4-panel-3.91.0"

src_install() {
        make DESTDIR=${D} install || die
                                                                                                                                           
        dodoc AUTHORS INSTALL NEWS COPYING README ChangeLog TODO
}
