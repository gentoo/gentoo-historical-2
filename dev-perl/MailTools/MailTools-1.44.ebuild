# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MailTools/MailTools-1.44.ebuild,v 1.6 2002/08/01 03:10:13 cselkirk Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Basic mail modules for Perl"
SRC_URI="http://www.cpan.org/modules/by-module/Mail/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Mail/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc"

DEPEND="${DEPEND}
	>=dev-perl/libnet-1.0703"
