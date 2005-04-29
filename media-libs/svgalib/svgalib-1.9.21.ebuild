# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/svgalib/svgalib-1.9.21.ebuild,v 1.2 2005/04/29 22:56:42 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs linux-mod

DESCRIPTION="A library for running svga graphics on the console"
HOMEPAGE="http://www.svgalib.org/"
SRC_URI="http://www.arava.co.il/matan/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="build"

DEPEND=""

MODULE_NAMES="svgalib_helper(misc:${S}/kernel/svgalib_helper)"
BUILD_PARAMS="KDIR=${KV_DIR}"
BUILD_TARGETS="default"
MODULESD_SVGALIB_HELPER_ADDITIONS="probeall  /dev/svga  svgalib_helper"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Misc makefile clean ups
	epatch "${FILESDIR}"/${P}-gentoo.patch

	# Get it to work with kernel 2.6
	epatch "${FILESDIR}"/${PN}-1.9.21-linux2.6.patch

	# -fPIC does work for lrmi, see bug #51698
	epatch "${FILESDIR}"/${PN}-1.9.19-pic.patch

	# Don't let the ebuild screw around with ld.so.conf #64829
	epatch "${FILESDIR}"/${PN}-1.9.19-dont-touch-ld.conf.patch

	# Don't strip stuff, let portage do it
	sed -i '/^INSTALL_PROGRAM/s: -s ::' Makefile.cfg
}

src_compile() {
	export CC="$(tc-getCC)"

	# First build static
	make OPTIMIZE="${CFLAGS}" static || die "Failed to build static libraries!"
	# Have to remove for shared to build ...
	rm -f src/svgalib_helper.h
	# Then build shared ...
	make OPTIMIZE="${CFLAGS}" shared || die "Failed to build shared libraries!"
	# Missing in some cases ...
	ln -s libvga.so.${PV} sharedlib/libvga.so
	# Build lrmi and tools ...
	make OPTIMIZE="${CFLAGS}" LDFLAGS="-L../sharedlib" \
		textutils lrmi utils \
		|| die "Failed to build libraries and utils!"
	# Build the gl stuff tpp
	make OPTIMIZE="${CFLAGS}" -C gl || die "Failed to build gl!"
	make OPTIMIZE="${CFLAGS}" -C gl libvgagl.so.${PV} \
		|| die "Failed to build libvgagl.so.${PV}!"
	# Missing in some cases ...
	ln -s libvgagl.so.${PV} sharedlib/libvgagl.so
	rm -f src/svgalib_helper.h
	make OPTIMIZE="${CFLAGS}" -C src libvga.so.${PV} \
		|| die "Failed to build libvga.so.${PV}!"
	cp -a src/libvga.so.${PV} sharedlib/
	# Build threeDKit ...
	make OPTIMIZE="${CFLAGS}" LDFLAGS='-L../sharedlib' \
		-C threeDKit lib3dkit.a || die "Failed to build threeDKit!"
	# Build demo's ...
	make OPTIMIZE="${CFLAGS} -I../gl" LDFLAGS='-L../sharedlib' \
		demoprogs || die "Failed to build demoprogs!"

	use build || linux-mod_src_compile
}

src_install() {
	local x=

	dodir /etc/svgalib /usr/{include,lib,bin,share/man}

	make \
		TOPDIR="${D}" OPTIMIZE="${CFLAGS}" INSTALLMODULE="" \
		install || die "Failed to install svgalib!"
	use build || linux-mod_src_install

	insinto /usr/include
	doins gl/vgagl.h
	dolib.a staticlib/libvga.a
	dolib.a gl/libvgagl.a
	dolib.a threeDKit/lib3dkit.a
	dolib.so gl/libvgagl.so.${PV}
	dosym libvgagl.so.${PV} /usr/lib/libvgagl.so
	preplib

	insinto /usr/include
	doins src/vga.h gl/vgagl.h src/mouse/vgamouse.h src/joystick/vgajoystick.h
	doins src/keyboard/vgakeyboard.h

	if [[ -e ${ROOT}/dev/.devfsd ]] ; then
		insinto /etc/devfs.d
		newins "${FILESDIR}"/svgalib.devfs svgalib
	elif [[ -e ${ROOT}/dev/.udev ]] ; then
		dodir /etc/udev/permissions.d
		echo "svga*:root:video:0660" > \
			"${D}"/etc/udev/permissions.d/30-${PN}.permissions
	fi

	exeinto /usr/lib/svgalib/demos
	for x in "${S}"/demos/* ; do
		[[ -x ${x} ]] && doexe ${x}
	done

	cd "${S}"/threeDKit
	exeinto /usr/lib/svgalib/threeDKit
	local THREED_PROGS="plane wrapdemo"
	doexe ${THREED_PROGS}

	cd "${S}"
	dodoc 0-README
	cd "${S}"/doc
	dodoc CHANGES DESIGN TODO
	docinto txt
	dodoc  Driver-programming-HOWTO README.* add_driver svgalib.lsm

	mv "${D}"/usr/man/* "${D}"/usr/share/man
	rmdir "${D}"/usr/man
}

pkg_postinst() {
	if [[ -e ${ROOT}/dev/.devfsd ]] ; then
		ebegin "Restarting devfsd to reread devfs rules"
		killall -HUP devfsd
		eend $?
	elif [[ -e ${ROOT}/dev/.udev ]] ; then
		ebegin "Restarting udev to reread udev rules"
		udevstart
		eend $?
	fi

	linux-mod_pkg_postinst
}
