# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/scrollkeeper/scrollkeeper-0.2-r2.ebuild,v 1.1 2002/01/14 14:19:25 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Scrollkeeper"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

RDEPEND=">=dev-libs/libxml-1.8.11
 	 >=sys-libs/zlib-1.1.3"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_compile() {
	local  myconf

	if [ -z "`use nls`" ] ; then
		myconf ="--disable-nls"
	fi

	./configure --host=${CHOST} 					\
		    --prefix=/usr                                       \
	            --sysconfdir=/etc					\
		    --localstatedir=/var $myconf || die

	emake || die
}

src_install() {
        cd omf-install
        cp Makefile Makefile.old
        sed -e "s:scrollkeeper-update.*::g" Makefile.old > Makefile
        rm Makefile.old
        cd ${S}

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING* ChangeLog README NEWS
}

pkg_postinst() {
        echo ">>> Updating Scrollkeeper database..."
        scrollkeeper-update >/dev/null 2>&1
}

pkg_postrm() {
        echo ">>> Scrollkeeper ${PV} unmerged, if you removed the package"
	echo "    you might want to clean up /var/lib/scrollkeeper."
}
