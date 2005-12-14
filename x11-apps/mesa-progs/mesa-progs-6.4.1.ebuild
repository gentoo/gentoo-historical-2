# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/mesa-progs/mesa-progs-6.4.1.ebuild,v 1.2 2005/12/14 17:24:22 fmccor Exp $

inherit toolchain-funcs

MY_PN="${PN/m/M}"
MY_PN="${MY_PN/-progs}"
MY_P="${MY_PN}-${PV}"
LIB_P="${MY_PN}Lib-${PV}"
PROG_P="${MY_PN}Demos-${PV}"
DESCRIPTION="Mesa's OpenGL utility and demo programs"
HOMEPAGE="http://mesa3d.sourceforge.net/"
SRC_URI="mirror://sourceforge/mesa3d/${LIB_P}.tar.bz2
	mirror://sourceforge/mesa3d/${PROG_P}.tar.bz2"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE=""

DEPEND="virtual/glut
	virtual/opengl
	virtual/glu"

S=${WORKDIR}/Mesa-${PV}

pkg_setup() {
	if [[ ${KERNEL} == "FreeBSD" ]]; then
		CONFIG="freebsd"
	elif use x86; then
		CONFIG="linux-dri-x86"
	# amd64 people need to look at this file to deal with lib64 issues, unless
	# they're fine with hardcoded lib64.
	elif use amd64; then
		CONFIG="linux-dri-x86-64"
	elif use ppc; then
		CONFIG="linux-dri-ppc"
	else
		CONFIG="linux-dri"
	fi
}

src_unpack() {
	HOSTCONF="${S}/configs/${CONFIG}"

	unpack ${A}
	cd ${S}

	# Kill this; we don't want /usr/X11R6/lib ever to be searched in this
	# build.
	echo "EXTRA_LIB_PATH =" >> ${HOSTCONF}

	echo "OPT_FLAGS = ${CFLAGS}" >> ${HOSTCONF}
	echo "CC = $(tc-getCC)" >> ${HOSTCONF}
	echo "CXX = $(tc-getCXX)" >> ${HOSTCONF}
	# bug #110840 - Build with PIC, since it hasn't been shown to slow it down
	echo "PIC_FLAGS = -fPIC" >> ${HOSTCONF}
}

src_compile() {
	cd ${S}/configs
	ln -s ${CONFIG} current

	cd ${S}/progs/xdemos

	emake glxinfo
	emake glxgears
}

src_install() {
	dobin ${S}/progs/xdemos/glxgears
	dobin ${S}/progs/xdemos/glxinfo
}
