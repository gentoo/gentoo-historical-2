# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-RSS-Feed/XML-RSS-Feed-2.2.ebuild,v 1.6 2007/07/10 23:33:29 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="Persistant XML RSS Encapsulation"
HOMEPAGE="http://search.cpan.org/~jbisbee/"
SRC_URI="mirror://cpan/authors/id/J/JB/JBISBEE/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/HTML-Parser
	dev-perl/XML-RSS
		dev-perl/Clone
		virtual/perl-Time-HiRes
		dev-perl/URI
		virtual/perl-Digest-MD5
	dev-lang/perl"
