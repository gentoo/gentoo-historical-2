# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacity/audacity-1.1.1-r1.ebuild,v 1.6 2003/02/14 08:50:02 vapier Exp $

inherit eutils

DESCRIPTION="A free, crossplatform audio editor."
HOMEPAGE="http://audacity.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}-3.tgz"

LICENSE="GPL-2"
IUSE="oggvorbis"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=x11-libs/wxGTK-2.2.9
	>=app-arch/zip-2.3
	>=media-sound/mad-0.14
	>=media-libs/id3lib-3.8.0
	>=media-libs/libsndfile-1.0.0
	oggvorbis? ( >=media-libs/libvorbis-1.0 )"

S="${WORKDIR}/${PN}-src-${PV}-3"

src_unpack() {
	unpack ${PN}-src-${PV}-3.tgz
	cd ${S}
	epatch ${FILESDIR}/mono_mp3_export.patch || die
}

src_compile() {
	econf --with-libsndfile=system || die
	MAKEOPTS=-j1 emake || die
}

src_install() {
	make PREFIX="${D}/usr" install || die
	dodoc LICENSE.txt README.txt
	insinto /etc/skel
	newins ${FILESDIR}/basecfg-1.1.1 .Audacity
}

pkg_postinst() {
	einfo
	einfo "If you built Audacity against wxGTK-2.4.0 you must..."
	einfo "cp /etc/skel/.Audacity ~"
	einfo
}
