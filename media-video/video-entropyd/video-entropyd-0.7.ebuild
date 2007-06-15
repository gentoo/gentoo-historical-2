# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/video-entropyd/video-entropyd-0.7.ebuild,v 1.8 2007/06/15 02:06:59 angelos Exp $

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Video-entropyd generates entropy-data for the /dev/random device."
HOMEPAGE="http://www.vanheusden.com/ved/"
SRC_URI="http://www.vanheusden.com/ved/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""
RDEPEND="virtual/libc
		media-libs/netpbm"
DEPEND="${RDEPEND}
		sys-kernel/linux-headers" # v4l headers from kernel
S="${WORKDIR}/${MY_P}"

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	newsbin video_entropyd video-entropyd
}

pkg_postinst() {
	elog "As video-entropyd does not provide a daemon mode, you"
	elog "should configure a cron job to regularly run:"
	elog "/usr/sbin/video-entropyd VIDEODEVICE"
}
