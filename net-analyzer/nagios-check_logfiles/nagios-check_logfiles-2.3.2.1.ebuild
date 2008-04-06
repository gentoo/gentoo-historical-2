# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-check_logfiles/nagios-check_logfiles-2.3.2.1.ebuild,v 1.2 2008/04/06 15:05:20 caleb Exp $

inherit eutils
DESCRIPTION="A nagios plugin for checking logfiles"
HOMEPAGE="http://www.consol.com/opensource/nagios/check-logfiles"

MY_P=${P/nagios-/}

SRC_URI="http://www.consol.com/fileadmin/opensource/Nagios/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~x86 amd64"

DEPEND="net-analyzer/nagios-plugins"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf --prefix=/usr/nagios || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
