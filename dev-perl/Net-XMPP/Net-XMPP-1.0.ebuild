# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-XMPP/Net-XMPP-1.0.ebuild,v 1.4 2005/03/27 14:23:39 kloeri Exp $

inherit perl-module

DESCRIPTION="Net::XMPP is a collection of Perl modules that provide a Perl Developer
access to the XMPP protocol."
SRC_URI="http://search.cpan.org/CPAN/authors/id/R/RE/REATMON/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~reatmon/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~sparc alpha ~ppc"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/XML-Stream-1.22
	dev-perl/Digest-SHA1"
