# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lm_sensors/lm_sensors-2.6.3-r1.ebuild,v 1.2 2002/08/14 04:40:34 murphy Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="Hardware Sensors Monitoring by lm_sensors"
SRC_URI="http://www2.lm-sensors.nu/~lm78/archive/${P}.tar.gz"
HOMEPAGE="http://www2.lm-sensors.nu/~lm78"
KEYWORDS="x86 ppc sparc sparc64"
LICENSE="GPL-2"

SLOT="0"

DEPEND="virtual/linux-sources"

src_compile ()  {

	emake clean all || die "lm_sensors requires the source of a compatible kernel\nversion installed in /usr/src/linux and i2c support built as a modules"
	
}

src_install () {
	emake DESTDIR=${D} PREFIX=/usr MANDIR=/usr/share/man install || die
	exeinto /etc/init.d
	newexe ${FILESDIR}/rc_lm_sensors lm_sensors
}

pkg_postinst() {

	[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules

	einfo
	einfo "The lm_sensors hardware sensors package has been installed."
	einfo
	einfo "It is recommended that you read the lm_sensors documentation."
	einfo "To enable lm_sensors you will need to compile i2c support in"
	einfo "your kernel as a module and run /usr/sbin/sensors-detect to"
	einfo "detect the hardware in your system."
	einfo
	einfo "Be warned, the probing of hardware in your system performed by"
	einfo "sensors-detect could freeze your system.  Also do not use"
	einfo "lm_sensors on certain laptop models from IBM.  See the lm_sensors"
	einfo "documentation and website for more information."
	einfo
	einfo "IMPORTANT: When you merge this package it installs kernel modules"
	einfo "that can only be used with the specific kernel version whose"
	einfo "source is located in /usr/src/linux.  If you upgrade to a new"
	einfo "kernel, you will need to remerge the lm_sensors package to build"
	einfo "new kernel modules."
	einfo

}
