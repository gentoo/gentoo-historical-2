# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Which/File-Which-0.05.ebuild,v 1.6 2006/08/05 03:55:46 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl module implementing \`which' internally"
SRC_URI="mirror://cpan/authors/id/P/PE/PEREINAR/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/search?module=File::Which"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha ia64 ppc64"
IUSE=""

SRC_TEST="do"

mydoc="TODO"


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
