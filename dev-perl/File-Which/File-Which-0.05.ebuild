# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Which/File-Which-0.05.ebuild,v 1.1 2004/08/17 17:34:11 agriffis Exp $

inherit perl-module

DESCRIPTION="Perl module implementing \`which' internally"
SRC_URI="http://www.cpan.org/authors/id/J/JM/JMUHLICH/${P}.tar.gz"
SRC_URI="http://www.cpan.org/authors/id/P/PE/PEREINAR/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/search?module=File::Which"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha"
IUSE=""

SRC_TEST="do"

mydoc="TODO"
