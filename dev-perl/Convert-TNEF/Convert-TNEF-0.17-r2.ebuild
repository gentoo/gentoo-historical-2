# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-TNEF/Convert-TNEF-0.17-r2.ebuild,v 1.1 2002/11/26 17:29:49 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}

DESCRIPTION="A Perl module for reading TNEF files"
SRC_URI="http://www.cpan.org/modules/by-module/Convert/DOUGW/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Convert/DOUGW/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="${DEPEND} 
	dev-perl/MIME-tools"
