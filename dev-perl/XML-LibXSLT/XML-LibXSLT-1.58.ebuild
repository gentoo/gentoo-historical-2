# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-LibXSLT/XML-LibXSLT-1.58.ebuild,v 1.3 2005/10/03 12:45:52 agriffis Exp $

inherit perl-module

DESCRIPTION="A Perl module to parse XSL Transformational sheets using gnome's libXSLT"
SRC_URI="mirror://cpan/authors/id/M/MS/MSERGEANT/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~msergeant/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# Disabled for now. The tests generate errors on threaded perls due
# to returns coming back out of sequence.
#SRC_TEST="do"

DEPEND="${DEPEND}
	>=dev-libs/libxslt-1.1.2
	>=dev-perl/XML-LibXML-1.58"
