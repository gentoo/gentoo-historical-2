# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xffm-icons/xffm-icons-3.99.2.ebuild,v 1.2 2003/09/04 07:12:36 msterret Exp $

IUSE=""
S=${WORKDIR}/${P}

DESCRIPTION="Icons for xffm"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="http://www.xfce.org/archive/xfce4-rc2/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

DEPEND=">=x11-libs/gtk+-2.0.6
	dev-util/pkgconfig
	dev-libs/libxml2
	=xfce-base/xffm-${PV}"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS INSTALL NEWS COPYING README ChangeLog TODO
}
