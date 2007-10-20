# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gtk2-Sexy/Gtk2-Sexy-0.02.ebuild,v 1.1 2007/10/20 17:35:33 ian Exp $

inherit perl-module

DESCRIPTION="Perl interface to the sexy widget collection"
HOMEPAGE="http://search.cpan.org/search?query=Gtk2-Sexy&mode=dist"
SRC_URI="mirror://cpan/authors/id/F/FL/FLORA/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/gtk2-perl
	dev-lang/perl"
RDEPEND=${DEPEND}
