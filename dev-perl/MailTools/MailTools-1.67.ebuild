# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MailTools/MailTools-1.67.ebuild,v 1.3 2005/10/18 15:22:25 ticho Exp $

inherit perl-module

DESCRIPTION="Manipulation of electronic mail addresses"
SRC_URI="mirror://cpan/authors/id/M/MA/MARKOV/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~markov/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND="${DEPEND}
	>=dev-perl/libnet-1.0703"
