# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Valid/Email-Valid-0.184.ebuild,v 1.8 2012/06/17 14:11:35 armin76 Exp $

EAPI=3

MODULE_AUTHOR=RJBS
inherit perl-module

DESCRIPTION="Check validity of Internet email addresses."

SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc ppc64 x86"
IUSE="test"

RDEPEND="dev-perl/MailTools
	dev-perl/Net-DNS"
DEPEND="test? ( ${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
PATCHES=( "${FILESDIR}/0.181-disable-online-test.patch" )
