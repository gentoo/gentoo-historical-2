# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Pastebin-PastebinCom-Create/WWW-Pastebin-PastebinCom-Create-0.3.0.ebuild,v 1.1 2011/08/28 09:05:12 tove Exp $

EAPI=4

MODULE_AUTHOR=ZOFFIX
MODULE_VERSION=0.003
inherit perl-module

DESCRIPTION="paste to <http://pastebin.com> from Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-perl/URI-1.35
	>=dev-perl/libwww-perl-5.807"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? ( virtual/perl-Test-Simple
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
