# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SNMP/Net-SNMP-6.0.0.ebuild,v 1.1 2009/09/14 07:17:17 tove Exp $

EAPI=2

MY_P=${PN}-v${PV}
S=${WORKDIR}/${MY_P}
MODULE_AUTHOR=DTOWN
inherit perl-module

DESCRIPTION="A SNMP Perl Module"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Math-BigInt
	>=dev-perl/Crypt-DES-2.03
	>=virtual/perl-Digest-MD5-2.11
	>=dev-perl/Digest-SHA1-1.02
	>=dev-perl/Digest-HMAC-1.0
	>=virtual/perl-libnet-1.0703"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST=do
