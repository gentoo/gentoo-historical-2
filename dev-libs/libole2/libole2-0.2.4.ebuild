# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libole2/libole2-0.2.4.ebuild,v 1.10 2002/12/06 23:59:39 mholzer Exp $

S=${WORKDIR}/${P}
DESCRIPTION="libole2"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/sources/${PN}/0.2/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64 ppc"

DEPEND="=dev-libs/glib-1.2*"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README* TODO
}
