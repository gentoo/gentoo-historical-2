# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmustux/libmustux-0.16.0.ebuild,v 1.8 2004/04/26 18:15:02 agriffis Exp $

inherit kde-functions

DESCRIPTION="Protux - Libary"
HOMEPAGE="http://www.nognu.org/protux"
SRC_URI="http://savannah.nongnu.org/download/protux/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

RDEPEND="virtual/x11
	>=x11-libs/qt-3
	media-libs/alsa-lib"

DEPEND="${RDEPEND}
	sys-devel/automake
	sys-devel/autoconf"

set-qtdir 3

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-alsalib-fix.patch || \
		die "alsalib-1.0 patch failed"
}

src_compile() {
	export QT_MOC=${QTDIR}/bin/moc
	cd ${S}
	export WANT_AUTOMAKE=1.4
	export WANT_AUTOCONF=2.1
	make -f admin/Makefile.common
	econf || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYRIGHT ChangeLog FAQ README TODO
}
