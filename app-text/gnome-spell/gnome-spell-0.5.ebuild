# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnome-spell/gnome-spell-0.5.ebuild,v 1.20 2004/07/14 01:59:43 agriffis Exp $

IUSE="nls"

inherit gnome.org libtool

DESCRIPTION="Gnome spellchecking component."
HOMEPAGE="http://www.gnome.org/"

KEYWORDS="x86 sparc ppc hppa"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=gnome-base/gnome-libs-1.4.1.7
	=gnome-base/control-center-1.4*
	>=gnome-base/bonobo-1.0.19-r1
	<gnome-base/libglade-2.0.0
	<gnome-extra/gal-1.99
	virtual/aspell-dict
	nls? ( sys-devel/gettext )"

src_compile() {

	elibtoolize

	local myconf=""
	use nls || myconf="${myconf} --disable-nls"

	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		${myconf} || die

	emake || die
}

src_install() {

	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		install || die

	# Dual gnomecc entry.
	rm -f ${D}/usr/share/control-center/capplets/${PN}-properties.desktop

	dodoc AUTHORS COPYING ChangeLog NEWS README
}
