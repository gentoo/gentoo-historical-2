# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpano12/libpano12-2.7.0.8.ebuild,v 1.3 2005/03/07 16:02:17 swegener Exp $

inherit eutils

DESCRIPTION="Helmut Dersch's panorama toolbox library"
HOMEPAGE="http://panotools.sf.net"
SRC_URI="mirror://sourceforge/panotools/libpano12-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~ppc-macos"
IUSE="java"
DEPEND="media-libs/libpng
		media-libs/tiff
		media-libs/jpeg
		sys-libs/zlib
		java? ( virtual/jdk )"

S="${WORKDIR}/libpano12-${PV}"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-dejava.patch
	cd ${S}
	autoconf
	libtoolize --force --copy
}

src_compile() {
	local myconf=""
	use java \
		&& myconf="--with-java=${JAVA_HOME}"
	use java \
		|| myconf="--without-java"
	econf ${myconf} || die "Configure failed"
	emake || die "Build failed"
}

src_install() {
	make DESTDIR=${D} install || die "Install failed"
	dodoc README README.linux AUTHORS NEWS doc/*.txt
}
