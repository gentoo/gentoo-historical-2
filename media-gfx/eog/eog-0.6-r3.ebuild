# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/eog/eog-0.6-r3.ebuild,v 1.2 2002/04/13 00:10:37 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Eye of GNOME"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/eog/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/gnome-office/eog.shtml"

RDEPEND="virtual/glibc
	>=gnome-base/gconf-1.0.4-r2
	>=gnome-base/bonobo-1.0.9-r1
	>=gnome-base/gnome-print-0.25i
	>=gnome-base/libglade-0.17
	>=gnome-base/oaf-0.6.2
	=dev-libs/glib-1.2*
	>=media-libs/gdk-pixbuf-0.16.0
	jpeg? ( media-libs/jpeg )
	png? ( 	media-libs/libpng 
			sys-libs/zlib )"

DEPEND="${RDEPEND}
	virtual/glibc
	nls? ( sys-devel/gettext )
	>=dev-util/intltool-0.11"


src_compile() {

	local myconf

	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		${myconf} || die
	
	emake || die
}

src_install() {

	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		localstatedir=/var/lib \
		GCONF_CONFIG_SOURCE="xml::${D}/etc/gconf/gconf.xml.defaults" \
		install || die

	dodoc AUTHORS COPYING DEPENDS ChangeLog HACKING NEWS README \
		TODO MAINTAINERS
}

