# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-SPF/Mail-SPF-2.007.ebuild,v 1.5 2010/07/06 20:56:05 ssuominen Exp $

EAPI=2

MODULE_AUTHOR="JMEHNLE"
MODULE_SECTION="mail-spf"
MY_P="${PN}-v${PV}"
S="${WORKDIR}/${MY_P}"

inherit perl-module

DESCRIPTION="Sender Permitted From - Object Oriented"

IUSE=""

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"

RDEPEND="dev-perl/Error
	dev-perl/URI
	>=dev-perl/Net-DNS-0.65
	>=dev-perl/NetAddr-IP-4.026
	>=dev-perl/Net-DNS-Resolver-Programmable-0.003
	virtual/perl-version
	!dev-perl/Mail-SPF-Query"

DEPEND="${RDEPEND}
		>=virtual/perl-Module-Build-0.33"

mydoc="TODO"

SRC_TEST="do"
