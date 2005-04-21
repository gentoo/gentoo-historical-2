# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/jail/jail-1.9-r1.ebuild,v 1.15 2005/04/21 19:19:04 blubb Exp $

inherit eutils

S="${WORKDIR}/${PN}_1-9_stable"
DESCRIPTION="Jail Chroot Project is a tool that builds a chrooted environment and automagically configures and builds all the required files, directories and libraries"
HOMEPAGE="http://www.jmcresearch.com/projects/jail/"
SRC_URI="mirror://sourceforge/jail/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="virtual/libc"
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
