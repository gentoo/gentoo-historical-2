# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/libgsf/libgsf-1.1.0.ebuild,v 1.9 2003/02/13 12:22:35 vapier Exp $

IUSE="gnome"

S=${WORKDIR}/${P}

DESCRIPTION="The GNOME Structured File Library"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 sparc  ppc"

DEPEND=">=dev-libs/glib-2.0.4
	>=dev-libs/libxml2-2.4.23
	>=sys-libs/zlib-1.1.4
	gnome? ( >=gnome-base/libbonobo-2.0.0
		>=gnome-base/gnome-vfs-2.0.1 )" 


src_compile() {
	local myconf 

	if [ "`use gnome`" ]
	then
		# README lied it is --with-gnomevfs not --with-gnome-vfs
		# building with-gnomevfs fails, disabling it
		# stroke@gentoo.org
		#
		#myconf="--with-gnomevfs --with-bonobo"
		myconf="--without-gnomevfs --with-bonobo"
	else
		myconf="--without-gnomevfs --without-bonobo"
	fi

	econf $myconf --with-zlib  || die
	make || die
}

src_install() {

	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		datadir=${D}/usr/share \
		install || die

	dodoc AUTHORS COPYING* ChangeLog INSTALL NEWS README
}
