# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MIME-tools/MIME-tools-5.411a-r2.ebuild,v 1.1 2002/11/26 14:31:22 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P/a/}

DESCRIPTION="A Perl module for parsing and creating MIME entities"
SRC_URI="http://www.cpan.org/modules/by-module/MIME/ERYQ/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/MIME/ERYQ/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="${DEPEND}
	>=dev-perl/IO-stringy-2.108
	dev-perl/MailTools"
