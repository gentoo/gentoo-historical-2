# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-nrpe/nagios-nrpe-2.0.ebuild,v 1.11 2005/05/03 16:35:38 eldad Exp $

inherit eutils

DESCRIPTION="Nagios $PV NRPE - Nagios Remote Plugin Executor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/nrpe-${PV}.tar.gz"

RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86 ~ppc sparc amd64"

IUSE="ssl"
DEPEND=">=net-analyzer/nagios-plugins-1.3.0
	ssl? ( dev-libs/openssl )"
S="${WORKDIR}/nrpe-${PV}"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /dev/null nagios
}

src_compile() {
	local myconf

	myconf="${myconf} `use_enable ssl`"

	# Generate the dh.h header file for better security (2005 Mar 20 eldad)
	if useq ssl ; then
		openssl dhparam -C 512 | sed -n '1,/BEGIN DH PARAMETERS/p' | grep -v "BEGIN DH PARAMETERS" > ${S}/src/dh.h
	fi

	./configure ${myconf} \
		--host=${CHOST} \
		--prefix=/usr/nagios \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios \
		--with-nrpe-user=nagios \
		--with-nrpe-grp=nagios \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake all || die
}

src_install() {
	dodoc LEGAL Changelog README SECURITY README.SSL

	insinto /etc/nagios
	newins ${FILESDIR}/nrpe-${PV}.cfg nrpe.cfg
	fowners root:nagios /etc/nagios/nrpe.cfg
	fperms 0640 /etc/nagios/nrpe.cfg

	exeinto /usr/nagios/bin
	doexe src/nrpe

	exeinto /usr/nagios/libexec
	doexe src/check_nrpe

	fowners nagios:nagios	/usr/nagios/libexec/check_nrpe /usr/nagios/bin/nrpe
	fperms 0750		/usr/nagios/libexec/check_nrpe /usr/nagios/bin/nrpe

	exeinto /etc/init.d
	newexe ${FILESDIR}/nrpe-${PV} nrpe
}
pkg_postinst() {
	einfo
	einfo "If you are using the nrpe daemon, remember to edit"
	einfo "the config file /etc/nagios/nrpe.cfg"
	einfo
}
