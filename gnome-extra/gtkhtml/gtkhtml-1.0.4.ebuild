# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gtkhtml/gtkhtml-1.0.4.ebuild,v 1.3 2002/09/28 07:35:48 azarah Exp $

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="Lightweight HTML rendering/printing/editing engine."
SRC_URI="ftp://ftp.ximian.com/pub/source/evolution/${P}.tar.gz
	 ftp://ftp.gnome.org/pub/GNOME/unstable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

RDEPEND=">=gnome-extra/gal-0.19
	<gnome-base/control-center-1.99.0
	>=gnome-base/libghttp-1.0.9-r1
	>=dev-libs/libunicode-0.4-r1
	>=gnome-base/gnome-print-0.34
	>=gnome-base/bonobo-1.0.18
	gnome? ( <gnome-base/gconf-1.1.0 )
	nls? ( sys-devel/gettext
		>=dev-util/intltool-0.11 )
	<gnome-base/libglade-0.99.0"

DEPEND="${RDEPEND}"

src_compile() {
	elibtoolize

	local myconf=""

	use nls || myconf="${myconf} --disable-nls"

	# Evo users need to have bonobo support
	#use bonobo \
	#	&& myconf="${myconf} --with-bonobo" \
	#	|| myconf="${myconf} --without-bonobo"

	use gnome \
		&& myconf="${myconf} --with-gconf" \
		|| myconf="${myconf} --without-gconf"

  	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		${myconf} || die

  	emake || die "Package building failed."
}

src_install() {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die

	# Fix the double entry in Control Center
	rm ${D}/usr/share/control-center/capplets/gtkhtml-properties.desktop

  	dodoc AUTHORS COPYING* ChangeLog README
  	dodoc NEWS TODO
}

