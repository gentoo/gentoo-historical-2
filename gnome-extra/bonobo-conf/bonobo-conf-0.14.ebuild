# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/bonobo-conf/bonobo-conf-0.14.ebuild,v 1.4 2002/07/11 06:30:26 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Bonobo Configuration System"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/${PN}/${P}.tar.gz
	 ftp://ftp.ximian.com/pub/source/evolution/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

RDEPEND="=dev-libs/glib-1.2*
	 =x11-libs/gtk+-1.2*
	 >=gnome-base/bonobo-1.0.15
	 >=gnome-base/oaf-0.6.6-r1"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	>=dev-util/intltool-0.11"

src_compile() {
	local myconf

	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	./configure --host=${CHOST} 					\
		    --prefix=/usr	 				\
		    --sysconfdir=/etc					\
		    --localstatedir=/var/lib				\
		    --disable-more-warnings 				\
	    	    $myconf || die

	make || die
}

src_install () {
	make prefix=${D}/usr						\
	     sysconfdir=${D}/etc					\
	     localstatedir=${D}/var/lib					\
	     install || die

	dodoc AUTHORS COPYING ChangeLog README NEWS TODO
}
