# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Pastebin-PastebinCom-Create/WWW-Pastebin-PastebinCom-Create-0.002.ebuild,v 1.1 2009/06/27 05:52:06 robbat2 Exp $
EAPI=2
MODULE_AUTHOR=ZOFFIX
inherit perl-module

DESCRIPTION="paste to <http://pastebin.com> from Perl"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
COMMON_DEPEND="
	>=dev-perl/URI-1.35
	>=dev-perl/libwww-perl-2.036
"
DEPEND="
	${COMMON_DEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"
RDEPEND="
	${COMMON_DEPEND}
"
SRC_TEST="do"
