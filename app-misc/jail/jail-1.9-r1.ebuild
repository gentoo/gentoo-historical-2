# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/jail/jail-1.9-r1.ebuild,v 1.10 2004/04/18 03:29:34 dragonheart Exp $

inherit eutils

S="${WORKDIR}/${PN}_1-9_stable"
DESCRIPTION="Jail Chroot Project is a tool that builds a chrooted environment and automagically configures and builds all the required files, directories and libraries"
SRC_URI="mirror://sourceforge/jail/${PN}_${PV}.tar.gz"
HOMEPAGE="http://www.jmcresearch.com/projects/jail/"
RESTRICT="nomirror"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 -ppc -sparc"

DEPEND="virtual/glibc"
RDEPEND="dev-lang/perl
	dev-util/strace"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz
	cd ${S}
	epatch ${FILESDIR}/${PN}-gentoo.diff
	epatch ${FILESDIR}/wrongshell.patch
}

src_compile() {
	# configuration files should be installed in /etc not /usr/etc
	sed -i "s:\$4/etc:\${D}/etc:g" install.sh

	# the destination directory should be /usr not /usr/local
	cd ${S}/src
	sed -i "s:usr/local:${D}/usr:g" Makefile

	emake || die "make failed"
}

src_install() {
	cd ${S}/src
	einstall

	# remove //var/tmp/portage/jail-1.9/image//usr from files
	FILES="
	${D}/usr/bin/mkjailenv
	${D}/usr/bin/addjailsw
	${D}/usr/bin/addjailuser
	${D}/etc/jail.conf
	${D}/usr/lib/libjail.pm
	${D}/usr/lib/arch/generic/definitions
	${D}/usr/lib/arch/generic/functions
	${D}/usr/lib/arch/linux/definitions
	${D}/usr/lib/arch/linux/functions
	${D}/usr/lib/arch/freebsd/definitions
	${D}/usr/lib/arch/freebsd/functions
	${D}/usr/lib/arch/irix/definitions
	${D}/usr/lib/arch/irix/functions
	${D}/usr/lib/arch/solaris/definitions
	${D}/usr/lib/arch/solaris/functions"

	for f in ${FILES}; do
		# documentation says funtion 'dosed' is supposed to do this, but didn't know how to make it work :'(
		# dosed ${file} || die "error in dosed"
		sed -i "s:/${D}/usr:/usr:g" ${f}
	done

	cd ${D}/usr/lib
	sed -i "s:/usr/etc:/etc:" libjail.pm

	cd ${S}/doc
	dodoc CHANGELOG INSTALL README SECURITY VERSION
}
