# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/undvd/undvd-0.3.2.ebuild,v 1.1 2008/02/23 00:40:39 gregkh Exp $

inherit eutils

DESCRIPTION="Simple dvd ripping command line app"
HOMEPAGE="http://sourceforge.net/projects/undvd/"
SRC_URI="http://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="css xvid"

DEPEND="sys-apps/coreutils
	app-shells/bash
	sys-apps/findutils
	sys-apps/gawk
	sys-apps/grep
	sys-process/procps
	sys-apps/sed
	media-video/lsdvd
	media-video/mplayer
	css? (
		media-libs/libdvdcss
		media-video/vobcopy
		sys-apps/util-linux
	)"
RDEPEND="${DEPEND}"

pkg_setup() {
	einfo "Checking mplayer for USE flags we need..."
	for f in "encode dvd x264 mp3"; do
		if ! built_with_use media-video/mplayer $f; then
			eerror "$f"
			die "mplayer merged without $f USE flag"
		fi
	done

	if use xvid; then
		if ! built_with_use media-video/mplayer xvid; then
			eerror "xvid missing. This means you cannot encode to xvid."
			die "mplayer merged without xvid USE flag"
		fi
	fi

	einfo "everything seems to be in order"
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
