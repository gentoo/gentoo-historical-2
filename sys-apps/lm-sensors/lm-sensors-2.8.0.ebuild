# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lm-sensors/lm-sensors-2.8.0.ebuild,v 1.3 2003/09/10 04:41:17 msterret Exp $

inherit flag-o-matic

MY_P=${PN/-/_}-${PV}
S="${WORKDIR}/${MY_P}"
MYI2C="${WORKDIR}/i2c-headers"

DESCRIPTION="Hardware Sensors Monitoring by lm_sensors"
SRC_URI="http://www.lm-sensors.nu/archive/${MY_P}.tar.gz"
HOMEPAGE="http://www2.lm-sensors.nu/~lm78"

SLOT="0"
# gentoo-sources-2.4.20-r1 and xfs-sources-2.4.20-r1 will
# have support for this package, do not change these to ~
# until your arch has i2c-2.7.0 in it's kernel.
KEYWORDS="~x86 ~amd64 -ppc -sparc"
LICENSE="GPL-2"

DEPEND=">=sys-apps/i2c-2.8.0"

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	epatch ${FILESDIR}/${P}-sensors-detect-gentoo.diff || die

	# get the right i2c includes without dropping the kernel includes
	mkdir -p ${MYI2C}/linux
	cp /usr/include/linux/i2c* ${MYI2C}/linux/
}

src_compile()  {
	echo
	einfo "*****************************************************************"
	einfo
	einfo "This ebuild assumes your /usr/src/linux kernel is the one you"
	einfo "used to build i2c-2.8.0. and is >=2.4.9 && < 2.5+"
	einfo
	einfo "For 2.5+ series kernels, use the support already in the kernel"
	einfo "under 'Character devices' -> 'I2C support'."
	einfo
	einfo "To cross-compile, 'export LINUX=\"/lib/modules/<version>/build\"'"
	einfo "or symlink /usr/src/linux to another kernel."
	einfo
	einfo "*****************************************************************"
	echo

	if [ "$LINUX" != "" ]; then
		einfo "Cross-compiling using:- $LINUX"
		einfo "Using headers from:- `echo $LINUX/include/linux | sed 's/\/\//\//'`"
		LINUX=`echo $LINUX | sed 's/build\//build/'`
	else
		einfo "You are running:- `uname -r`"
		check_KV || die "Cannot find kernel in /usr/src/linux"
		einfo "Using kernel in /usr/src/linux/:- ${KV}"

		echo ${KV} | grep 2.4. > /dev/null
		if [ $? == 1 ]; then
			eerror "Kernel version in /usr/src/linux is not 2.4.x"
			eerror "Please specify a 2.4.x kernel!"
			die "Incompatible Kernel"
		else
			LINUX='/usr/src/linux'
		fi

		if [ "${KV}" != "`uname -r`" ]; then
			ewarn "WARNING:- kernels do not match!"
		fi
	fi

	echo
	sleep 2

	check_KV
	filter-flags -fPIC

	cd ${S}
	emake clean
	emake I2C_HEADERS=${MYI2C} LINUX=$LINUX || die "lm_sensors requires the source of a compatible kernel version in /usr/src/linux or specified in \$LINUX and >=i2c-2.8.0 support built as modules. This support is included in gentoo-sources as of 2.4.20-r1"
}

src_install() {

	einstall LINUX=$LINUX DESTDIR=${D} PREFIX=/usr MANDIR=/usr/share/man || die "Install failed"
	exeinto /etc/init.d
	newexe ${FILESDIR}/rc lm_sensors

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
