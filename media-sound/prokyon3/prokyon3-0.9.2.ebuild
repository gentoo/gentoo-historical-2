# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/prokyon3/prokyon3-0.9.2.ebuild,v 1.6 2005/04/03 22:53:50 greg_g Exp $

inherit eutils

DESCRIPTION="Multithreaded MP3 manager and tag editor based on Qt and MySQL"
HOMEPAGE="http://prokyon3.sourceforge.net"
SRC_URI="mirror://sourceforge/prokyon3/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 sparc amd64"
IUSE="oggvorbis"

DEPEND=">=x11-libs/qt-3.0
	dev-db/mysql
	>=media-libs/id3lib-3.8.2
	oggvorbis? ( >=media-libs/libogg-1.0
		>=media-libs/libvorbis-1.0 )"

pkg_setup() {
	if [ ! -e ${QTDIR}/plugins/sqldrivers/libqsqlmysql.so ] ; then
		eerror "You have installed Qt without MySQL support."
		eerror "Please make sure "mysql" is in your USE variable"
		eerror "and reemerge Qt"
		die "MySQL support for Qt not found"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# do not assume that $x_libraries is not empty
	epatch "${FILESDIR}/${P}-configure.patch"
}

src_compile() {
	local myconf

	use oggvorbis || myconf="--without-ogg"

	econf ${myconf} || die
	emake || die
}

src_install () {
	einstall || die
	dodoc ChangeLog COPYING INSTALL NEWS README
}
