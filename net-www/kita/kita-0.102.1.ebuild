# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/kita/kita-0.102.1.ebuild,v 1.1 2004/04/11 14:45:30 usata Exp $

IUSE=""

DESCRIPTION="Kita - 2ch client for KDE"
HOMEPAGE="http://kita.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/kita/8449/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/glibc
	>=x11-libs/qt-3.1
	>=kde-base/kdebase-3.1
	>=kde-base/kdelibs-3.1
	>=kde-base/arts-1.1.4
	>=sys-devel/gcc-3.2
	>=dev-libs/libpcre-4.2
	>=dev-libs/expat-1.95.6
	>=sys-libs/zlib-1.1.4
	>=app-admin/fam-2.6.9
	>=media-libs/libpng-1.2.5
	>=media-libs/jpeg-6b
	>=media-libs/freetype-2.1.4
	>=media-libs/fontconfig-2.2.1
	>=media-libs/libart_lgpl-2.3.16
	sys-devel/gettext"
# Never depend on a meta package
#	>=kde-base/kde-3.1
# see http://dev.gentoo.org/~liquidx/ebuildmistakes.html

src_compile() {
	addwrite ${QTDIR}/etc

	econf || die
	cd kita ; emake -j1 || die ; cd -
}

src_install() {

	cd kita ; make DESTDIR=${D} install || die ; cd -

	dodoc AUTHORS ChangeLog INSTALL NEWS README
}
