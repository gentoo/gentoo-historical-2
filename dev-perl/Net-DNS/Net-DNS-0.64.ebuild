# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-DNS/Net-DNS-0.64.ebuild,v 1.1 2008/12/31 16:51:09 tove Exp $

MODULE_AUTHOR=OLAF
inherit perl-module

DESCRIPTION="Perl Net::DNS - Perl DNS Resolver Module"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ipv6 test"

RDEPEND="virtual/perl-Digest-MD5
	dev-perl/Digest-HMAC
	dev-perl/Net-IP
	ipv6? ( dev-perl/IO-Socket-INET6 )
	virtual/perl-MIME-Base64
	dev-lang/perl"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple
		dev-perl/Test-Pod )"

SRC_TEST="do"
mydoc="TODO"
myconf="--no-online-tests"
