# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/bonobo/bonobo-1.0.19-r1.ebuild,v 1.9 2002/10/04 05:32:57 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A set of language and system independant CORBA interfaces"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"
LICENSE="GPL-"

RDEPEND=">=gnome-base/oaf-0.6.8
	>=gnome-base/ORBit-0.5.13
	>=gnome-base/gnome-print-0.30"

DEPEND="${RDEPEND}
	sys-devel/perl
	nls? ( sys-devel/gettext 
	>=dev-util/intltool-0.11 )"

src_compile() {
	#libtoolize to fix relink bug
	libtoolize --copy --force

	local myconf=""
	use nls || myconf="${myconf} --disable-nls"
  
	CFLAGS="${CFLAGS} `gnome-config --cflags print`"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		${myconf} || die

	make || die # make -j 4 didn't work
}

src_install() {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die

	chmod 644 ${D}/usr/lib/pkgconfig/libefs.pc

	dodoc AUTHORS COPYING* ChangeLog README NEWS TODO
}

