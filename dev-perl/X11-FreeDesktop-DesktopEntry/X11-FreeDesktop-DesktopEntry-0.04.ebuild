# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X11-FreeDesktop-DesktopEntry/X11-FreeDesktop-DesktopEntry-0.04.ebuild,v 1.7 2006/08/06 01:12:41 mcummings Exp $

inherit perl-module

DESCRIPTION="An interface to Freedesktop.org .desktop files."
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/G/GB/GBROWN/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="ia64 ppc x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
