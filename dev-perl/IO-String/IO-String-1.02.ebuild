# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-String/IO-String-1.02.ebuild,v 1.1 2003/06/08 13:39:55 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="IO::File interface for in-core strings"
SRC_URI="http://www.cpan.org/modules/by-module/IO/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/IO/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~ppc ~sparc ~alpha"
