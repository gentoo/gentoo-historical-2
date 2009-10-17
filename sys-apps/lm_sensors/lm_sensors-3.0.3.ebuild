# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lm_sensors/lm_sensors-3.0.3.ebuild,v 1.2 2009/10/17 01:18:04 robbat2 Exp $

EAPI=2

inherit eutils flag-o-matic linux-info toolchain-funcs multilib

DESCRIPTION="Hardware Monitoring user-space utilities"
HOMEPAGE="http://www.lm-sensors.org/"
SRC_URI="http://dl.lm-sensors.org/lm-sensors/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="sensord"

COMMON="sensord? ( net-analyzer/rrdtool )"
DEPEND="${COMMON}
		sys-apps/sed"
RDEPEND="${COMMON}
		dev-lang/perl
		virtual/logger"

CONFIG_CHECK="~HWMON ~I2C_CHARDEV ~I2C"
WARNING_HWMON="${PN} requires CONFIG_HWMON to be enabled for use."
WARNING_I2C_CHARDEV="sensors-detect requires CONFIG_I2C_CHARDEV to be enabled."
WARNING_I2C="${PN} requires CONFIG_I2C to be enabled for most sensors."

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.3-sensors-detect-gentoo.patch

	if use sensord; then
		sed -i -e 's:^# \(PROG_EXTRA\):\1:' "${S}"/Makefile || die
	fi

	# Respect LDFLAGS
	sed -i -e 's/\$(LIBDIR)$/\$(LIBDIR) \$(LDFLAGS)/g' Makefile || die
	sed -i -e 's/\$(LIBSHSONAME) -o/$(LIBSHSONAME) \$(LDFLAGS) -o/g' lib/Module.mk || die
}

src_compile() {
	einfo
	einfo "You may safely ignore any errors from compilation"
	einfo "that contain \"No such file or directory\" references."
	einfo

	filter-flags -fstack-protector

	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr MANDIR=/usr/share/man LIBDIR=/usr/$(get_libdir) \
		install || die "emake install failed"

	newinitd "${FILESDIR}"/lm_sensors-3-init.d lm_sensors || die
	newinitd "${FILESDIR}"/fancontrol-init.d fancontrol || die

	if use sensord; then
		newconfd "${FILESDIR}"/sensord-conf.d sensord || die
		newinitd "${FILESDIR}"/sensord-init.d sensord || die
	fi

	dodoc CHANGES CONTRIBUTORS INSTALL README* || die

	dodoc doc/donations doc/fancontrol.txt doc/fan-divisors \
		doc/progs doc/temperature-sensors doc/vid || die

	docinto chips
	dodoc doc/chips/* || die

	docinto developers
	dodoc doc/developers/applications || die
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
	elog "<=${PN}-2, as the needed entries in /etc/conf.d/lm_sensors has"
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
