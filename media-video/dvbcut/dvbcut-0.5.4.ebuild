# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvbcut/dvbcut-0.5.4.ebuild,v 1.1 2007/04/14 23:18:19 aballier Exp $

inherit qt3 eutils

IUSE=""

MY_P="${P/-/_}"

DESCRIPTION="frame-accurate editing of MPEG-2 video with MPEG and AC3 audio"
HOMEPAGE="http://dvbcut.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="$(qt_min_version 3)
	media-libs/libao
	>=media-video/ffmpeg-0.4.9_p20070330"

DEPEND="${RDEPEND}
	dev-util/scons"

pkg_setup() {
	 if ! built_with_use media-video/ffmpeg a52; then
	 	eerror "This package requires media-video/ffmpeg compiled with A/52 (a.k.a. AC-3) support."
		eerror "Please reemerge media-video/ffmpeg with USE=\"a52\"."
		die "Please reemerge media-video/ffmpeg with USE=\"a52\"."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-0.5.3-ffmpeg-compat.patch"
}

src_compile() {
	emake FFMPEG=/usr || die "build failed"
}

src_install() {
	emake FFMPEG=/usr DESTDIR="${D}" PREFIX="/usr" MANPATH="/usr/share/man" install \
		|| die "install failed"
	dodoc CREDITS ChangeLog README README.ffmpeg README.icons
}
