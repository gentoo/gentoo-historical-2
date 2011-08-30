# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JavaScript-SpiderMonkey/JavaScript-SpiderMonkey-0.200.0.ebuild,v 1.1 2011/08/30 11:35:23 tove Exp $

EAPI=4

MODULE_AUTHOR=TBUSCH
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="Perl interface to the JavaScript Engine"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl
	>=dev-lang/spidermonkey-1.5"
DEPEND="${RDEPEND}"

SRC_TEST=do
