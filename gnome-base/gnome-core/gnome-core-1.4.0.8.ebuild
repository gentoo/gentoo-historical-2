# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-core/gnome-core-1.4.0.8.ebuild,v 1.5 2002/06/28 10:22:57 trance Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Core components of the GNOME desktop environment"
SRC_URI="ftp://ftp.yggdrasil.com/mirrors/site/ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz
	ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

RDEPEND="=gnome-base/control-center-1.4*
     ( =gnome-base/libglade-0.17*
       <gnome-base/libglade-0.99.0 )
     >=gnome-base/gnome-libs-1.4.1.2-r1
     >=media-libs/gdk-pixbuf-0.16.0-r1"


DEPEND="${RDEPEND}
        >=sys-apps/tcp-wrappers-7.6
        >=app-text/scrollkeeper-0.2
        nls? ( sys-devel/gettext
		>=dev-util/intltool-0.11 )"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Fix build error
	patch -p0 <${FILESDIR}/${P}-configure.in.patch  || die "failed patch" 

	# Libtoolize
	libtoolize --copy --force
	aclocal -I macros
	automake --add-missing
	autoconf
}

src_compile() {
	local myconf=""
	local myldflags=""
	
	use nls || myconf="${myconf} --disable-nls"

	if [ "`use kde`" ]
	then
		myconf="${myconf} --with-kde-datadir=/usr/share"
	fi

	# Fix build against gdk-pixbuf-0.12 and later
	CFLAGS="${CFLAGS} `gdk-pixbuf-config --cflags`"

	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --mandir=/usr/share/man \
		    --sysconfdir=/etc \
		    --localstatedir=/var/lib \
		    ${myconf} || die

	cd panel
	cp gnome-panel-screenshot.c gnome-panel-screenshot.c.orig
	cat gnome-panel-screenshot.c.orig | \
		sed 's:\(^#include <errno.h>\):\1\n#include <locale.h>:' \
		> gnome-panel-screenshot.c
	
	cd ${S}

	emake || die
}

src_install() {
	make prefix=${D}/usr \
	     mandir=${D}/usr/share/man \
	     sysconfdir=${D}/etc \
  	     localstatedir=${D}/var/lib \
	     install || die

	# Support for new X session management scheme
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/Gnome

	dodoc AUTHORS COPYING* ChangeLog README NEWS
}

