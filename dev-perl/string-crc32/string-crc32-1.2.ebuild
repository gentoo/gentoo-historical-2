# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/string-crc32/string-crc32-1.2.ebuild,v 1.3 2004/02/21 09:46:30 vapier Exp $

inherit perl-module

MY_P=String-CRC32-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl interface for cyclic redundency check generation"
SRC_URI="http://www.cpan.org/modules/by-authors/id/S/SO/SOENKE/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/S/SO/SOENKE/${MY_P}.readme"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha hppa ~amd64"
