# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Ben Lutgens <ben@sistina.com>
# /space/gentoo/cvsroot/gentoo-x86/x11-wm/xfce/xfce-3.8.11-r2.ebuild,v 1.1 2002/03/12 12:54:06 seemant Exp
 
S=${WORKDIR}/${P}
DESCRIPTION="XFce is a lightweight desktop environment for various UNIX systems."
SRC_URI="http://prdownloads.sourceforge.net/xfce/${P}.tar.gz"
HOMEPAGE="http://www.xfce.org/"

DEPEND="virtual/x11
	>=x11-libs/gtk+-1.2.10-r4
	gnome? ( dev-libs/libxml2 )
	gnome? ( >=media-libs/gdk-pixbuf-0.11.0-r1 )
	arts? ( kde-base/kdelibs )
	nls? ( sys-devel/gettext )"

	use gnome || DEPEND="${DEPEND} >=media-libs/imlib-1.9.10-r1"
RDEPEND=""

src_compile() {
	local myconf

	if [ "`use gnome`" ]
	then
		myconf="--enable-imlib=no --enable-gdk-pixbuf=/usr"
		myconf="${myconf} --enable-gdm"
		myconf="${myconf} --enable-libxml2"
	fi
	
	use nls || myconf="${myconf} --disable-nls"
	use arts && myconf="${myconf} --enable-arts"

	./configure --host=${CHOST}						\
		--prefix=/usr						\
	 	--mandir=/usr/share/man					\
		--with-data-dir=/usr/share/xfce				\
		--with-conf-dir=/etc/xfce 				\
		--disable-xft						\
		--with-locale-dir=/usr/share/locale \
		${myconf} || die

	cd docs
	cp Makefile Makefile.orig
	sed "s:/usr/share/xfce:/usr/share/doc/${PF}:" Makefile.orig > Makefile
	cd ..

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog* AUTHORS LICENSE README* TODO*
	dodir /etc/skel/.xfce

	exeinto /etc/X11/Sessions
	doexe $FILESDIR/xfce
}
