# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-POP3Client/Mail-POP3Client-2.16.ebuild,v 1.5 2005/03/12 20:21:22 vapier Exp $

inherit perl-module

CATEGORY="dev-perl"
DESCRIPTION="POP3 client module for Perl"
HOMEPAGE="http://www.cpan.org/modules/by-module/Mail/${P}.readme"
SRC_URI="http://www.cpan.org/modules/by-module/Mail/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~s390 ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="${DEPEND}
	>=dev-perl/libnet-1.0703"

mydoc="FAQ"
