# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/bonobo/bonobo-1.0.19-r1.ebuild,v 1.21 2004/08/07 23:02:29 slarti Exp $

IUSE="nls"

DESCRIPTION="A set of language and system independent CORBA interfaces"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc"
LICENSE="GPL-2"

RDEPEND=">=gnome-base/oaf-0.6.8
	>=gnome-base/ORBit-0.5.13
	>=gnome-base/gnome-print-0.30
	>=media-libs/gdk-pixbuf-0.6"

DEPEND="${RDEPEND}
	dev-lang/perl
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
