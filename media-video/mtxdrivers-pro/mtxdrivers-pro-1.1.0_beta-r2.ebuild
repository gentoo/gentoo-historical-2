# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mtxdrivers-pro/mtxdrivers-pro-1.1.0_beta-r2.ebuild,v 1.6 2004/10/04 06:34:43 spyderous Exp $

inherit matrox

# GL lib version
GL_V="1.3.0"

# Stupid naming scheme requires this, probably only works for betas
MY_PV="${PV/_/-pro-}"
MY_PN="${PN/-pro}"
MY_P="${MY_PN}-rh9.0-v${MY_PV}"
S="${WORKDIR}/${MY_PN}"
DESCRIPTION="Drivers for the Matrox Parhelia and Millenium P650/P750 cards with OpenGL support."
SRC_URI="${MY_P}.tar.gz"

KEYWORDS="x86"
IUSE=""

RDEPEND="x11-base/opengl-update
	!media-video/mtxdrivers"
PROVIDE="virtual/opengl"

pkg_nofetch() {
	einfo "You must go to:"
	einfo "http://www.matrox.com/mga/registration/driverhub.cfm?aid=103&dtype=3&osid=7&prodid=40"
	einfo "(for the RH9.0 drivers) and log in (or create an account) to download the"
	einfo "Matrox Parhelia drivers. Remember to right-click and use Save Link As when"
	einfo "downloading the driver."
}

src_install() {
	# Install 2D driver and DRM kernel module
	matrox_base_src_install

	dodoc README*

	# Install OpenGL driver, libs, etc.
	local GENTOO_GL_ROOT="/usr/lib/opengl"
	local GENTOO_MTX_ROOT="${GENTOO_GL_ROOT}/mtx"

	dodir ${GENTOO_MTX_ROOT}/extensions; exeinto ${GENTOO_MTX_ROOT}/extensions
	doexe xfree86/${GENTOO_X_VERSION}/libglx.a

	dodir ${GENTOO_MTX_ROOT}/include; insinto ${GENTOO_MTX_ROOT}/include
	doins include/GL/gl.h include/GL/glx.h include/GL/glext.h

	dodir ${GENTOO_MTX_ROOT}/lib; exeinto ${GENTOO_MTX_ROOT}/lib
	doexe lib/libGL.so.${GL_V}
	dosym ../../${X11_IMPLEM}/lib/libGL.so.${GL_V} ${GENTOO_MTX_ROOT}/lib/libGL.so.1
	dosym ../../${X11_IMPLEM}/lib/libGL.so.${GL_V} ${GENTOO_MTX_ROOT}/lib/libGL.so

	# Same as X11
	dosym ../../${X11_IMPLEM}/lib/libGL.la ${GENTOO_MTX_ROOT}/lib/libGL.la
}

pkg_postinst() {
	# modules-update, maybe some info on busmastering
	matrox_base_pkg_postinst

	# Don't run opengl-update for them. Tell them how, instead. (spyderous)
	einfo "To switch to Matrox OpenGL, run \"opengl-update mtx\""
}
