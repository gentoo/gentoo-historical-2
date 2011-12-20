# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/xvba-video/xvba-video-0.8.0.ebuild,v 1.2 2011/12/20 15:31:08 ago Exp $

EAPI=4

inherit multilib

x86name="${P}.i686"
amd64name="${P}.x86_64"

DESCRIPTION="XVBA Backend for Video Acceleration (VA) API"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi/"
SRC_URI="
	amd64? ( http://www.splitted-desktop.com/~gbeauchesne/${PN}/${amd64name}.tar.gz )
	x86? ( http://www.splitted-desktop.com/~gbeauchesne/${PN}/${x86name}.tar.gz )
"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libva[opengl]
	x11-drivers/ati-drivers"
DEPEND=""

S=${WORKDIR}

# TODO: ignore QA warning about ldflags since this is binary
QA_PRESTRIPPED="
	usr/lib\(32\|64\)\?/va/drivers/xvba_drv_video.so
	usr/lib\(32\|64\)\?/va/drivers/fglrx_drv_video.so
"

src_install() {
	use x86 && cd "${x86name}"
	use amd64 && cd "${amd64name}"

	dodoc AUTHORS NEWS README
	exeinto /usr/$(get_libdir)/va/drivers/
	doexe usr/lib/va/drivers/*
}
