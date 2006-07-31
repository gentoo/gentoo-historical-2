# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/adtool/adtool-1.3.ebuild,v 1.2 2006/07/31 11:25:01 satya Exp $

inherit eutils

DESCRIPTION="adtool is a Unix command line utility for Active Directory administration"
SRC_URI="http://gp2x.org/adtool/${P}.tar.gz"
HOMEPAGE="http://gp2x.org/adtool/"

KEYWORDS="~x86 ~ppc"
SLOT="0"
LICENSE="GPL-2"
IUSE="ssl"

DEPEND="net-nds/openldap
	ssl?    ( dev-libs/openssl )"
RDEPEND=""

src_install() {
	einstall || die
}
