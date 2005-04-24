# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CDDB/CDDB-1.12.ebuild,v 1.11 2005/04/24 13:01:49 hansmi Exp $

inherit perl-module

S=${WORKDIR}/CDDB-1.12
DESCRIPTION="high-level interface to cddb/freedb protocol"
SRC_URI="http://www.cpan.org/modules/by-authors/id/R/RC/RCAPUTO/CDDB-1.12.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/R/RC/RCAPUTO/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 ppc sparc amd64"
IUSE=""
