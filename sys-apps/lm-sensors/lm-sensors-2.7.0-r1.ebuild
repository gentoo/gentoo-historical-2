# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lm-sensors/lm-sensors-2.7.0-r1.ebuild,v 1.5 2003/10/18 17:11:29 mholzer Exp $

inherit flag-o-matic

MY_P=${PN/-/_}-${PV}

S="${WORKDIR}/${MY_P}"
MYI2C="${WORKDIR}/i2c-headers"

DESCRIPTION="Hardware Sensors Monitoring by lm_sensors"
SRC_URI="http://www2.lm-sensors.nu/~lm78/archive/${MY_P}.tar.gz
	mirror://gentoo/${P}-sensors-detect-gentoo.diff.bz2"
HOMEPAGE="http://www2.lm-sensors.nu/~lm78"

SLOT="0"
# gentoo-sources-2.4.20-r1 and xfs-sources-2.4.20-r1 will
# have support for this package, do not change these to ~ 
# until your arch has i2c-2.7.0 in it's kernel.
KEYWORDS="x86 amd64 -ppc -sparc"
LICENSE="GPL-2"

DEPEND="|| (
	     >=sys-apps/i2c-2.7.0
	     >=sys-kernel/gentoo-sources-2.4.20-r1
	     >=sys-kernel/lolo-sources-2.4.20.1
	     >=sys-kernel/xfs-sources-2.4.20_pre4
	   )"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	patch -p 1 <../${P}-sensors-detect-gentoo.diff || die
	# get the right i2c includes without dropping the kernel includes
	mkdir -p ${MYI2C}/linux
	cp /usr/include/linux/i2c* ${MYI2C}/linux/
}

src_compile()  {
	check_KV

	filter-flags -fPIC

	emake I2C_HEADERS=${MYI2C} clean all || die "lm_sensors requires the source of a compatible kernel\nversion installed in /usr/src/linux and >=i2c-2.7.0 support built as a modules this support is included in gentoo-sources as of 2.4.20-r1"
}

src_install() {
	einstall DESTDIR=${D} PREFIX=/usr MANDIR=/usr/share/man || die "Install failed"
	exeinto /etc/init.d
	newexe ${FILESDIR}/rc lm_sensors
	dodoc BACKGROUND BUGS CHANGES CONTRIBUTORS COPYING INSTALL \
		QUICKSTART README* RPM TODO
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
