# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Atom/XML-Atom-0.37.ebuild,v 1.1 2009/12/30 17:32:28 tove Exp $

EAPI=2

MODULE_AUTHOR=MIYAGAWA
inherit perl-module

DESCRIPTION="Atom feed and API implementation"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/Class-Data-Inheritable
	>=dev-perl/XML-LibXML-1.69
	dev-perl/XML-XPath
	dev-perl/DateTime
	dev-perl/Digest-SHA1
	dev-perl/HTML-Parser
	dev-perl/LWP-Authen-Wsse
	virtual/perl-MIME-Base64"
RDEPEND="${DEPEND}"

SRC_TEST=do
