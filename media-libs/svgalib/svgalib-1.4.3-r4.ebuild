# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/svgalib/svgalib-1.4.3-r4.ebuild,v 1.18 2004/07/01 08:04:29 eradicator Exp $

inherit eutils flag-o-matic

DESCRIPTION="A library for running svga graphics on the console"
HOMEPAGE="http://www.svgalib.org/"
SRC_URI="http://www.svgalib.org/${P}.tar.gz
	mirror://gentoo/${P}-r128.c.bz2"
#	http://www.arava.co.il/matan/svgalib/r128.c"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* x86"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	epatch ${FILESDIR}/${P}-userpriv.patch
	epatch ${FILESDIR}/${P}-linux2.6.patch
	epatch ${FILESDIR}/${P}-gcc3.patch #23515

	# Update r128 driver, bug #10987.
	unpack ${P}-r128.c.bz2
	mv ${P}-r128.c ${S}/src/r128.c
}

src_compile() {
	filter-flags "-fPIC"

	make OPTIMIZE="${CFLAGS}" static shared textutils lrmi utils || die
	# Build the gl stuff tpp
	make OPTIMIZE="${CFLAGS}" -C gl || die
	make OPTIMIZE="${CFLAGS}" -C gl libvgagl.so.${PV} || die

	make OPTIMIZE="${CFLAGS}" LDFLAGS='-L ../sharedlib' demoprogs || die

	sed -i \
		's/\(install: $(INSTALLAOUTLIB) \)installheaders \(.*\)/\1\2/g' \
		Makefile
}

src_install() {
	dodir /etc/{vga,svga} /usr/{include,lib,bin,share/man}
	make TOPDIR=${D} OPTIMIZE="${CFLAGS}" install || die
	insinto /usr/include
	doins gl/vgagl.h
	dolib.a gl/libvgagl.a
	dolib.so gl/libvgagl.so.${PV}
	dosym libvgagl.so.${PV} /usr/lib/libvgagl.so
	preplib

	insinto /usr/include
	doins src/vga.h gl/vgagl.h src/mouse/vgamouse.h src/joystick/vgajoystick.h
	doins src/keyboard/vgakeyboard.h

	cd ${S}/demos
	exeinto /usr/lib/svgalib/demos
	local DEMO_PROGS="fun testgl speedtest mousetest vgatest scrolltest \
	    testlinear \
	    keytest testaccel accel forktest eventtest spin bg_test printftest \
	    joytest mjoytest bankspeed lineart linearspeed addmodetest \
	    svidtune linearfork vgatweak"
	doexe ${DEMO_PROGS}

	cd ${S}/threeDKit
	exeinto /usr/lib/svgalib/theeDKit
	local THREED_PROGS="plane wrapdemo"
	doexe ${THREED_PROGS}

	cd ${S}/doc
	dodoc 0-README CHANGES* DESIGN NEWS TODO
	docinto txt
	dodoc  Driver-programming-HOWTO README.* add_driver svgalib.lsm
}

pkg_postinst() {
	# we chown/chmod outside userpriv
	for x in /usr/lib/svgalib/demos/* /usr/lib/svgalib/theeDKit/*; do
		chown root ${x}
		chmod u+s ${x}
	done
}
