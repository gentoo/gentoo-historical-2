# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-nsca/nagios-nsca-2.4.ebuild,v 1.6 2004/07/13 06:46:01 eldad Exp $

DESCRIPTION="Nagios NSCA  - Nagios Service Check Acceptor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/nsca-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND=">=net-analyzer/nagios-plugins-1.3.1
	>=dev-libs/libmcrypt-2.5.1-r4"
S="${WORKDIR}/nsca-${PV}"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr/nagios \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios \
		--with-nsca-user=nagios \
		--with-nsca-grp=nagios \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake all || die "emake failed"
}

src_install() {
	dodoc LEGAL Changelog README SECURITY
	insinto /etc/nagios
	doins ${FILESDIR}/nsca.cfg
	doins ${FILESDIR}/send_nsca.cfg
	exeinto /usr/nagios/bin
	doexe src/nsca
	fowners nagios:nagios /usr/nagios/bin/nsca
	exeinto /usr/nagios/libexec
	doexe src/send_nsca
	fowners nagios:nagios /usr/nagios/libexec/send_nsca
	exeinto /etc/init.d
	newexe ${FILESDIR}/nsca-2.3 nsca
}
pkg_postinst() {
	einfo
	einfo "If you are using the nsca daemon, remember to edit"
	einfo "the config file /etc/nagios/nsca.cfg"
	einfo
}
