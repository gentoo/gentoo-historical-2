# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-stringy/IO-stringy-2.109.ebuild,v 1.1 2004/06/06 12:30:17 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}

DESCRIPTION="A Perl module for I/O on in-core objects like strings and arrays"
SRC_URI="http://www.cpan.org/modules/by-module/IO/ERYQ/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/IO/ERYQ/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~s390"

SRC_TEST="do"
