# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmustux/libmustux-0.20.0.ebuild,v 1.6 2004/06/24 23:12:46 agriffis Exp $

inherit kde-functions

DESCRIPTION="Protux - Libary"
HOMEPAGE="http://www.nognu.org/protux"
SRC_URI="http://savannah.nongnu.org/download/protux/${P}.tar.gz"

IUSE="static"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

DEPEND="virtual/x11
	>=x11-libs/qt-3
	media-libs/alsa-lib"

set-qtdir 3

src_compile() {
	export QT_MOC=${QTDIR}/bin/moc
	local myconf
	myconf="--with-gnu-ld"
	use static || myconf="${myconf} --enable-static=no"
	econf ${myconf} || die "configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYRIGHT ChangeLog NEWS README TODO
}
