# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/string-crc32/string-crc32-1.2.ebuild,v 1.18 2006/08/06 03:09:57 mcummings Exp $

inherit perl-module

MY_P=String-CRC32-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl interface for cyclic redundancy check generation"
SRC_URI="mirror://cpan/authors/id/S/SO/SOENKE/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/S/SO/SOENKE/${MY_P}.readme"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ppc64 sparc x86"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
