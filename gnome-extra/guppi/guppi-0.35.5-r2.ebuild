# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# /home/cvsroot/gentoo-x86/gnome-office/gnumeric/gnumeric-0.64-r1.ebuild,v 1.1 2001/05/17 13:29:30 achim Exp
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/guppi/guppi-0.35.5-r2.ebuild,v 1.3 2001/10/19 22:11:59 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNOME Plottin Tool"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/Guppi/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/guppi/"

RDEPEND=">=media-libs/gdk-pixbuf-0.11.0-r1
	>=dev-util/guile-1.4
        >=gnome-base/gnome-print-0.30
	bonobo? ( >=gnome-base/bonobo-1.0.9-r1 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
        >=dev-util/xml-i18n-tools-0.8.4
	python? ( >=dev-lang/python-2.0 )"

src_compile() {                           
	local myconf

	if [ "`use bonobo`" ]
	then
		myconf="--enable-bonobo"
	else
		myconf="--disable-bonobo"
	fi

	if [ "`use python`" ]
	then
		myconf="--enable-python"
	else
		myconf="--disable-python"
	fi

	if [ -z "`use nls`" ] ; then
		myconf="$myconf --disable-nls"
	fi

	if [ -z "`use readline`" ] ; then
		myconf="$myconf --disable-guile-readline"
	fi

	CFLAGS="${CFLAGS} `gnome-config --cflags libglade`"

	./configure --host=${CHOST}					\
		    --prefix=/usr					\
		    --sysconfdir=/etc					\
		    --localstatedir=/var/lib				\
		    ${myconf} || die

	make || die # Doesn't work with -j 4 (hallski)
}

src_install() {                               
	make prefix=${D}/usr						\
	     sysconfdir=${D}/etc					\
	     localstatedir=${D}/var/lib					\
	     install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
