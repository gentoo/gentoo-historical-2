# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lm_sensors/lm_sensors-2.10.8.ebuild,v 1.2 2009/10/17 01:18:04 robbat2 Exp $

inherit eutils flag-o-matic linux-info toolchain-funcs multilib

DESCRIPTION="Hardware Monitoring user-space utilities"

HOMEPAGE="http://www.lm-sensors.org/"
SRC_URI="http://dl.lm-sensors.org/lm-sensors/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

IUSE="sensord"

COMMON="sys-fs/sysfsutils
		!sys-apps/i2c-tools
		sensord? ( net-analyzer/rrdtool )"
DEPEND="${COMMON}
		sys-apps/sed
		ppc? ( >=virtual/linux-sources-2.5 )
		amd64? ( || ( >=virtual/linux-sources-2.5 >=sys-kernel/vserver-sources-2.0 ) )
		x86? ( || ( >=virtual/linux-sources-2.5 >=sys-kernel/vserver-sources-2.0 sys-apps/lm_sensors-modules ) )"
RDEPEND="${COMMON}
		dev-lang/perl
		>=x11-misc/read-edid-1.4.1-r1
		virtual/logger"

pkg_setup() {
	linux-info_pkg_setup

	if ! linux_config_src_exists; then
		CONFIG_CHECK="I2C_SENSOR HWMON I2C CONFIG_I2C_CHARDEV"
		ewarn "Unable to check for the following kernel config options due"
		ewarn "to absence of any configured kernel sources or compiled"
		ewarn "config:"
		for config in ${CONFIG_CHECK}; do
			ewarn " - ${config#\~}"
		done
		ewarn "You're on your own to make sure they are set if needed."
	elif kernel_is 2 4; then
		if use ppc || use amd64; then
			eerror
			eerror "${P} does not support kernel 2.4.x under PPC and AMD64."
			eerror
			eerror "${P} does not support kernel 2.4.x under PPC and AMD64."
		elif ! has_version =sys-apps/lm_sensors-modules-${PV}; then
			eerror
			eerror "${P} needs sys-apps/lm_sensors-modules-${PV} to be installed"
			eerror "for kernel 2.4.x"
			eerror
			eerror "sys-apps/lm_sensors-modules-${PV} not installed"
		fi
	else
		if kernel_is lt 2 6 14 && ! (linux_chkconfig_present I2C_SENSOR); then
			eerror
			eerror "${P} requires CONFIG_I2C_SENSOR to be enabled for non-2.4.x kernels."
			eerror
			ewarn "CONFIG_I2C_SENSOR not detected"
		elif kernel_is gt 2 6 13 && ! (linux_chkconfig_present HWMON); then
			eerror
			eerror "${P} requires CONFIG_HWMON to be enabled for 2.6.14+ kernels."
			eerror
			ewarn "CONFIG_HWMON not detected"
		fi
		if ! (linux_chkconfig_present I2C_CHARDEV); then
			ewarn
			ewarn "sensors-detect requires CONFIG_I2C_CHARDEV to be enabled for non-2.4.x kernels."
			ewarn
		fi
		if ! (linux_chkconfig_present I2C); then
			ewarn
			ewarn "${P} requires CONFIG_I2C to be enabled for non-2.4.x kernels for most sensors."
			ewarn
		fi
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${PN}-2.10.7-sensors-detect-gentoo.patch

	if use sensord; then
		sed -i -e 's:^# \(PROG_EXTRA\):\1:' Makefile
	fi

	# Respect LDFLAGS
	sed -i -e 's/\$(LIBDIR)$/\$(LIBDIR) \$(LDFLAGS)/g' Makefile
	sed -i -e 's/\$(LIBSHSONAME) -o/$(LIBSHSONAME) \$(LDFLAGS) -o/g' lib/Module.mk
}

src_compile()  {
	einfo
	einfo "You may safely ignore any errors from compilation"
	einfo "that contain \"No such file or directory\" references."
	einfo

	filter-flags -fstack-protector

	emake CC=$(tc-getCC) LINUX=${KV_DIR} I2C_HEADERS=${KV_DIR}/include user \
		|| die "emake user failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr MANDIR=/usr/share/man LIBDIR=/usr/$(get_libdir) \
		KERNELINCLUDEFILES="" user_install || die "emake user_install failed"

	newinitd "${FILESDIR}"/lm_sensors-init.d lm_sensors
	newinitd "${FILESDIR}"/fancontrol-init.d fancontrol

	if use sensord; then
		newconfd "${FILESDIR}"/sensord-conf.d sensord
		newinitd "${FILESDIR}"/sensord-init.d sensord
	fi

	dodoc BACKGROUND BUGS CHANGES CONTRIBUTORS INSTALL QUICKSTART \
		README* TODO

	dodoc doc/donations doc/fancontrol.txt doc/fan-divisors doc/FAQ \
		doc/progs doc/temperature-sensors doc/vid

	dohtml doc/lm_sensors-FAQ.html doc/useful_addresses.html

	docinto busses
	dodoc doc/busses/*

	docinto chips
	dodoc doc/chips/*

	docinto developers
	dodoc doc/developers/applications doc/developers/design \
		doc/developers/new_drivers doc/developers/proc \
		doc/developers/sysctl doc/developers/sysfs-interface
}

pkg_postinst() {
	elog
	elog "Please run \`/usr/sbin/sensors-detect' in order to setup"
	elog "/etc/conf.d/lm_sensors."
	elog
	elog "/etc/conf.d/lm_sensors is vital to the init-script."
	elog "Please make sure you also add lm_sensors to the desired"
	elog "runlevel. Otherwise your I2C modules won't get loaded"
	elog "on the next startup."
	elog
	elog "You will also need to run the above command if you're upgrading from"
	elog "<=${PN}-2.9.0, as the needed entries in /etc/conf.d/lm_sensors has"
	elog "changed."
	elog
	elog "Be warned, the probing of hardware in your system performed by"
	elog "sensors-detect could freeze your system. Also make sure you read"
	elog "the documentation before running lm_sensors on IBM ThinkPads."
	elog
	elog "Please refer to the lm_sensors documentation for more information."
	elog "(http://www.lm-sensors.org/wiki/Documentation)"
	elog
}
