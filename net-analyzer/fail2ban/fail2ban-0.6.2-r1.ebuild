# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/fail2ban/fail2ban-0.6.2-r1.ebuild,v 1.1 2007/02/01 17:25:07 jokey Exp $

DESCRIPTION="Bans IP that make too many password failures"
HOMEPAGE="http://fail2ban.sourceforge.net/"
SRC_URI="mirror://sourceforge/fail2ban/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc ~ppc64 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND=${DEPEND}

src_install() {
	# Use python setup
	python setup.py install --root="${D}" || die

	# Use fail2ban.conf.default as default config file
	insinto /etc
	newins config/fail2ban.conf.iptables fail2ban.conf
	# Install initd scripts
	exeinto /etc/init.d
	newexe config/gentoo-initd fail2ban
	insinto /etc/conf.d
	newins config/gentoo-confd fail2ban
	# Doc
	doman man/*.[0-9]
	dodoc CHANGELOG README TODO
}

pkg_postinst() {
	einfo "Please edit /etc/fail2ban.conf with parameters"
	einfo "that correspond to your system."
}
