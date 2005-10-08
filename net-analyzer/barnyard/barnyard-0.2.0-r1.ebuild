# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/barnyard/barnyard-0.2.0-r1.ebuild,v 1.1 2005/10/08 13:48:01 strerror Exp $

DESCRIPTION="Fast output system for Snort"
SRC_URI="mirror://sourceforge/barnyard/barnyard-${PV/_/-}.tar.gz"
HOMEPAGE="http://www.snort.org/dl/barnyard/"

SLOT="0"
LICENSE="QPL"
KEYWORDS="x86 -sparc"
IUSE="mysql postgres sguil"

DEPEND="virtual/libc
	virtual/libpcap
	postgres? ( >=dev-db/postgresql-7.2 )
	mysql? ( >=dev-db/mysql-3.23.26 )"

RDEPEND="${DEPEND}
	net-analyzer/snort"

S=${WORKDIR}/${P/_/-}

src_compile() {
	local myconf

	econf \
		--sysconfdir=/etc/snort \
		$(use_enable postgres) \
		$(use_enable mysql)|| die "bad ./configure"
	emake || die "compile problem"
}

src_install () {

	make DESTDIR=${D} install || die

	dodoc docs/*
	dodoc AUTHORS README

	keepdir /var/log/snort
	keepdir /var/log/snort/archive

	insinto /etc/snort
	newins etc/barnyard.conf barnyard.conf
	if use sguil ; then
		sed -i -e "/config hostname:/s%snorthost%$(hostname)%" \
		-e "/config interface/s:fxp0:eth0:" \
		-e "s:output alert_fast:#output alert_fast:" \
		-e "s:output log_dump:#output log_dump:" \
			"${D}/etc/snort/barnyard.conf" || die "sed failed"
	fi

	newconfd ${FILESDIR}/barnyard.confd barnyard
	if use sguil ; then
		sed -i -e s:/var/log/snort:/var/lib/sguil/$(hostname): \
		-e s:/var/run/barnyard.pid:/var/run/sguil/barnyard.pid: \
			"${D}/etc/conf.d/barnyard" || die "sed failed"
	fi

	newinitd ${FILESDIR}/barnyard.rc6 barnyard
	if use sguil ; then
		sed -i -e "/start-stop-daemon --start/s:--exec:-c sguil --exec:" \
			"${D}/etc/init.d/barnyard" || die "sed failed"
	fi
}

pkg_postinst() {
	if use sguil ; then
		einfo
		einfo "Make sure to edit /etc/snort/barnyard.conf and uncomment the"
		einfo "sguil section along with supplying the appropriate database"
		einfo "information."
		einfo
	fi
}
