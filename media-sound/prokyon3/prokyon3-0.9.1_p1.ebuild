# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/prokyon3/prokyon3-0.9.1_p1.ebuild,v 1.2 2003/07/12 20:30:56 aliz Exp $

IUSE="oggvorbis"

S=${WORKDIR}/${PN}
DESCRIPTION="Multithreaded MP3 manager and tag editor based on Qt and MySQL"
HOMEPAGE="http://prokyon3.sourceforge.net"
SRC_URI="mirror://sourceforge/prokyon3/${PN}-${PV/_p/-r}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=x11-libs/qt-3.0
	dev-db/mysql
	>=media-libs/id3lib-3.8.2
	oggvorbis? ( >=media-libs/libogg-1.0
		>=media-libs/libvorbis-1.0 )"

RDEPEND="${DEPEND}"

pkg_setup() {
	if [ ! -e ${QTDIR}/plugins/sqldrivers/libqsqlmysql.so ] ; then
		eerror "You have installed Qt without MySQL support."
		eerror "Please make sure "mysql" is in your USE variable"
		eerror "and reemerge Qt"
		die "MySQL support for Qt not found"
	fi
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
