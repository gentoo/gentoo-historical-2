# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Feed/XML-Feed-0.41.ebuild,v 1.1 2008/12/15 16:07:19 tove Exp $

MODULE_AUTHOR=SIMONW
inherit perl-module

DESCRIPTION="Syndication feed parser and auto-discovery"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/Class-ErrorHandler
	dev-perl/Feed-Find
	dev-perl/URI-Fetch
	>=dev-perl/XML-RSS-1.40
	>=dev-perl/XML-Atom-0.32
	dev-perl/DateTime
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	virtual/perl-Module-Pluggable"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

SRC_TEST=do
