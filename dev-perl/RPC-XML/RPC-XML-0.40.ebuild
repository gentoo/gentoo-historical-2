# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/RPC-XML/RPC-XML-0.40.ebuild,v 1.6 2002/08/01 04:07:06 cselkirk Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A  Perl extension interface to James Clark's XML parser, expat."
SRC_URI="http://cpan.valueclick.com/modules/by-module/RPC/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/RPC/${PN}.${PV}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc"

DEPEND="${DEPEND}
	dev-perl/XML-Parser
	dev-perl/mod_perl"
