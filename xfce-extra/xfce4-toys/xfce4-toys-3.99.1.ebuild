# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-toys/xfce4-toys-3.99.1.ebuild,v 1.1 2003/07/15 05:31:07 bcowan Exp $

IUSE=""
S=${WORKDIR}/${P}

DESCRIPTION="Xfce4 toys"
HOMEPAGE="http://www.xfce.org"
SRC_URI="http://www.xfce.org/archive/xfce4-rc1/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND=">=x11-libs/gtk+-2.0.6                                                   
        dev-util/pkgconfig                                                      
        dev-libs/libxml2                                                        
        =xfce-base/xfce4-${PV}"                                                 

src_install() {
	make DESTDIR=${D} install || die
	
	dodoc AUTHORS INSTALL NEWS COPYING README ChangeLog TODO
}
