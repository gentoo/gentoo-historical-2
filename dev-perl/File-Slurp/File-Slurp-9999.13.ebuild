# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Slurp/File-Slurp-9999.13.ebuild,v 1.2 2008/07/15 19:42:39 armin76 Exp $

inherit perl-module

DESCRIPTION="Efficient Reading/Writing of Complete Files"
HOMEPAGE="http://search.cpan.org/~uri/${P}/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl"

SRC_TEST="do"

mydoc="extras/slurp_article.pod"
