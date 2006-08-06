# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Iconv/Text-Iconv-1.4.ebuild,v 1.13 2006/08/06 00:26:11 mcummings Exp $

inherit perl-module

DESCRIPTION="A Perl interface to the iconv() codeset conversion function"
HOMEPAGE="http://cpan.org/modules/by-module/Text/${P}.readme"
SRC_URI="mirror://cpan/authors/id/M/MP/MPIOTR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
