# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-nrpe/nagios-nrpe-1.5.ebuild,v 1.1 2002/11/02 05:55:41 alron Exp $
DESCRIPTION="Nagios $PV NRPE - Nagios Remote Plugin Executor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="http://telia.dl.sourceforge.net/sourceforge/nagios/nrpe-1.5.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=net-analyzer/nagios-plugins-1.3_beta1"
S="${WORKDIR}/nrpe-1.5"

src_compile() {
	./configure \
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
	dodoc LEGAL Changelog README
	insinto /etc/nagios
	doins ${FILESDIR}/nrpe.cfg
	exeinto /usr/nagios/bin
	doexe src/nrpe
	fowners nagios:nagios /usr/nagios/bin/nrpe
	exeinto /usr/nagios/libexec
	doexe src/check_nrpe
	fowners nagios:nagios /usr/nagios/libexec/check_nrpe
	exeinto /etc/init.d
	doexe ${FILESDIR}/nrpe
}
pkg_postinst() {
	einfo 
	einfo "If you are using the nrpe daemon, remember to edit"
	einfo "the config file /etc/nagios/nrpe.cfg"
	einfo
}
