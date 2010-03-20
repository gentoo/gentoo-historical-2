# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Twitter/Net-Twitter-3.12000.ebuild,v 1.1 2010/03/20 09:30:19 tove Exp $

EAPI=2

MODULE_AUTHOR=MMIMS
inherit perl-module

DESCRIPTION="A perl interface to the Twitter API"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/Moose-0.94
	dev-perl/Data-Visitor
	>=dev-perl/DateTime-0.51
	dev-perl/DateTime-Format-Strptime
	virtual/perl-Digest-SHA
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/JSON-Any
	dev-perl/JSON-XS
	virtual/perl-Scalar-List-Utils
	dev-perl/MooseX-MultiInitArg
	dev-perl/Net-OAuth
	dev-perl/namespace-autoclean"
DEPEND="${RDEPEND}"

# online test
SRC_TEST=skip
