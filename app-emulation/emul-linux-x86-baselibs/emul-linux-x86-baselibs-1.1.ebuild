# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-baselibs/emul-linux-x86-baselibs-1.1.ebuild,v 1.3 2004/04/15 01:54:02 kugelfang Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Base libraries for emulation of 32bit x86 on amd64"
SRC_URI="mirror://gentoo/distfiles/emul-linux-x86-baselibs-1.1.tar.bz2"
HOMEPAGE=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64"

DEPEND="virtual/glibc"

src_unpack () {
	unpack ${A}
}

src_install() {
	cd ${WORKDIR}
	mkdir -p ${D}/emul/linux/x86
	mkdir -p ${D}/emul/linux/x86/lib/dev-state
	mkdir -p ${D}/emul/linux/x86/lib/security/pam_filter
	mkdir -p ${D}/emul/linux/x86/lib/rcscripts/sh
	mkdir -p ${D}/emul/linux/x86/lib/rcscripts/awk
	mkdir -p ${D}/emul/linux/x86/usr/lib/misc
	mkdir -p ${D}/emul/linux/x86/usr/lib/awk
	mkdir -p ${D}/emul/linux/x86/usr/lib/gcc-config
	mkdir -p ${D}/emul/linux/x86/usr/lib/gcc-lib/i686-pc-linux-gnu/3.3.2
	mkdir -p ${D}/emul/linux/x86/usr/lib/gettext
	mkdir -p ${D}/emul/linux/x86/usr/lib/gconv
	mkdir -p ${D}/emul/linux/x86/usr/lib/nsbrowser/plugins
	mkdir -p ${D}/emul/linux/x86/usr/lib/glib/include
	mkdir -p ${D}/emul/linux/x86/usr/lib/pkgconfig
	mkdir -p ${D}/etc/env.d
	mv ${WORKDIR}/etc/env.d/75emul-linux-x86-baselibs ${D}/etc/env.d/
	rm -Rf ${WORKDIR}/etc
	cp -RPvf ${WORKDIR}/* ${D}/emul/linux/x86/

	# Fixes BUG #47817
	cd ${D}/emul/linux/x86/usr/lib
	sed -e "s/\/lib\//\/lib32\//g" libc.so > libc.so.new
	mv libc.so.new libc.so

	ln -sf /emul/linux/x86/lib/ld-linux.so.2 ${D}/lib/ld-linux.so.2
	ln -sf /emul/linux/x86/lib ${D}/lib32
	ln -sf /emul/linux/x86/usr/lib ${D}/usr/lib32
}
