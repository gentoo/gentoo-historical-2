# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libglade/libglade-0.17-r6.ebuild,v 1.1 2002/04/25 07:48:25 spider Exp $

#provide Xmake and Xemake
. /usr/portage/eclass/inherit.eclass
inherit virtualx

S=${WORKDIR}/${P}
DESCRIPTION="libglade allows programs to load their UIs from an XMLS description at tuntime."
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://developer.gnome.org/doc/API/libglade/libglade.html"

SLOT="0"
#please dont add gnome-libs as an optional DEPEND, as
#it causes too many problems.
RDEPEND=">=dev-libs/libxml-1.8.15
	 >=gnome-base/gnome-libs-1.4.1.2-r1
	 bonobo? ( >=gnome-base/bonobo-1.0.19-r1 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf=""

	use bonobo && myconf="${myconf} --enable-bonobo"
	use bonobo || myconf="${myconf} --disable-bonobo --disable-bonobotest"

	use nls    || myconf="${myconf} --disable-nls"

	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--disable-gnomedb \
		${myconf} || die
		
	Xemake || die
}

src_install() {
	make prefix=${D}/usr \
	     sysconfdir=${D}/etc \
	     localstatedir=${D}/var/lib \
	     install || die
	
	dodoc AUTHORS COPYING* ChangeLog NEWS
	dodoc doc/*.txt
}

