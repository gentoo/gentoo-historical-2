# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacity/audacity-1.1.0.ebuild,v 1.6 2002/11/10 18:45:31 raker Exp $

IUSE="oggvorbis"

DESCRIPTION="A free, crossplatform audio editor."
HOMEPAGE="http://audacity.sourceforge.net/"
LICENSE="GPL-2"

# doesn't compile with wxGTK-2.3.2
DEPEND="~x11-libs/wxGTK-2.2.9
	oggvorbis? ( media-libs/libvorbis )
	app-arch/zip
	media-sound/mad"
	

SLOT="0"
KEYWORDS="x86"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tgz"
S="${WORKDIR}/${PN}-src-${PV}"

src_unpack() {
	unpack "${PN}-src-${PV}.tgz"
	## Patches from http://www.hcsw.org/audacity/
	patch -p0 < "${FILESDIR}/${PN}-src-${PV}-timestretch.patch" || die
	patch -p0 < "${FILESDIR}/${PN}-src-${PV}-phonograph.patch" || die
}

src_compile() {
	
	econf || die
	emake || die
}

src_install () {
	make PREFIX="${D}/usr" install || die
	dodoc LICENSE.txt README.txt
}
