# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/libxfcegui4/libxfcegui4-3.99.3.ebuild,v 1.1 2003/09/03 23:19:08 bcowan Exp $

IUSE="xinerama X"
S=${WORKDIR}/${P}

DESCRIPTION="Library's for XFCE4"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce4-rc2/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND=">=x11-libs/gtk+-2.0.6
	dev-util/pkgconfig
	dev-libs/libxml2
	=xfce-base/libxfce4util-${PV}"

src_compile() {
	local myconf
	myconf=""
	
	use xinerama && myconf="${myconf} --enable-xinerama"
	use X && myconf="${myconf} --with-x"
	
	econf ${myconf} || die
	emake || die
}

src_install() {
        make DESTDIR=${D} install || die
                                                                                                                                           
        dodoc AUTHORS INSTALL NEWS COPYING README TODO ChangeLog
}
