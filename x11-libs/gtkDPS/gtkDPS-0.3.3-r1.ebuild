# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkDPS/gtkDPS-0.3.3-r1.ebuild,v 1.4 2002/07/09 10:53:20 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Set of functions, objects and widgets to use DPS easily with GTK"
SRC_URI="http://www.aist-nara.ac.jp/~masata-y/gtkDPS/dist/${P}.tar.gz"
HOMEPAGE="http://www.aist-nara.ac.jp/~masata-y/gtkDPS/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc
	=x11-libs/gtk+-1.2*
	>=app-text/dgs-0.5.9.1"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	./configure --prefix=/usr --host=${CHOST} \
		--with-x --with-dps $myconf || die
	make || die

}

src_install () {

	make prefix=${D}/usr install || die
	dodoc COPYING* ChangeLog GTKDPS-VERSION HACKING NEWS README TODO
}
