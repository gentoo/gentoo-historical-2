# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dbus/dbus-0.13.ebuild,v 1.1 2003/10/04 00:37:20 seemant Exp $

IUSE="qt doc"

S=${WORKDIR}/${P}
DESCRIPTION="A message bus system"
HOMEPAGE="http://www.freedesktop.org/software/dbus/"
SRC_URI="http://www.freedesktop.org/software/dbus/releases/${P}.tar.gz"

SLOT="0"
LICENSE="Academic"
KEYWORDS="~x86"

DEPEND="dev-libs/glib
	dev-libs/libxml2
	dev-util/pkgconfig
	doc? ( app-doc/doxygen
		app-text/openjade )
	qt? ( x11-libs/qt )"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	econf \
		--enable-glib \
		`use_enable qt` \
		`use_enable doc docs`\
		--with-initscripts=redhat || die
	make || die
}

src_install() {
	einstall || die
	keepdir /var/lib/run/dbus

	dodoc AUTHORS COPYING ChangeLog HACKING INSTALL NEWS README
}
