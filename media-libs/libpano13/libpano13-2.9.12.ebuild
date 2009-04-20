# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpano13/libpano13-2.9.12.ebuild,v 1.5 2009/04/20 20:59:25 maekke Exp $

inherit eutils

DESCRIPTION="Helmut Dersch's panorama toolbox library"
HOMEPAGE="http://panotools.sf.net"
SRC_URI="mirror://sourceforge/panotools/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="java"
DEPEND="
	media-libs/jpeg
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	java? ( virtual/jdk )"

src_compile() {
	local myconf=""
	use java && myconf="--with-java=${JAVA_HOME}"
	use java  || myconf="--without-java"
	econf ${myconf} || die "Configure failed"
	emake || die "Build failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README README.linux AUTHORS NEWS doc/*.txt
}
