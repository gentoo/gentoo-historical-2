# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/svgalib/svgalib-1.4.3-r2.ebuild,v 1.2 2002/12/09 04:26:14 manson Exp $

DESCRIPTION="A library for running svga graphics on the console"
HOMEPAGE="http://www.svgalib.org/"
LICENSE="BSD"

DEPEND="virtual/glibc"

SLOT="0"
KEYWORDS="x86 -ppc -sparc "

S=${WORKDIR}/${P}
SRC_URI="http://www.svgalib.org/${P}.tar.gz"


src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {

	make OPTIMIZE="${CFLAGS}" static shared textutils lrmi utils || die
	# Build the gl stuff tpp
	make OPTIMIZE="${CFLAGS}" -C gl || die
	make OPTIMIZE="${CFLAGS}" -C gl libvgagl.so.${PV} || die

	make OPTIMIZE="${CFLAGS}" LDFLAGS='-L ../sharedlib' demoprogs || die
	
	cp Makefile Makefile.orig
	sed 's/\(install: $(INSTALLAOUTLIB) \)installheaders \(.*\)/\1\2/g' \
		Makefile.orig > Makefile
}

src_install () {

	dodir /etc/{vga,svga} /usr/{include,lib,bin,share/man}
	make TOPDIR=${D} OPTIMIZE="${CFLAGS}" install || die
	insinto /usr/include
	doins gl/vgagl.h
	dolib.a gl/libvgagl.a
	dolib.so gl/libvgagl.so.${PV}
	dosym libvgagl.so.${PV} /usr/lib/libvgagl.so

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
