# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Reviewed by Achim Gottinger <achim@gentoo.org>
# /home/cvsroot/gentoo-x86/gnome-apps/gedit/gedit-0.9.4.ebuild,v 1.4 2000/11/27 16:20:46 achim Exp
# $Header: /var/cvsroot/gentoo-x86/app-editors/gedit/gedit-0.9.6.ebuild,v 1.7 2001/11/10 02:54:28 hallski Exp $


S=${WORKDIR}/${P}
DESCRIPTION="Gnome Text Editor"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://gedit.sourceforge.net/"

RDEPEND=">=gnome-base/libglade-0.17-r1
	 >=gnome-base/gnome-print-0.30
         >=gnome-base/gnome-vfs-1.0.2-r1"

DEPEND="${RDEPEND}
        nls? ( sys-devel/gettext )"


src_compile() {
	local myconf

	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	CFLAGS="${CFLAGS} `gnome-config --cflags libglade vfs`"

	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
		    ${myconf} || die
	
	emake || die
}

src_install() {
  	make prefix=${D}/usr install || die

	dodoc AUTHORS BUGS COPYING ChangeLog FAQ NEWS README* THANKS TODO
}
