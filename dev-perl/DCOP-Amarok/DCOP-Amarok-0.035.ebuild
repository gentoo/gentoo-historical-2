# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DCOP-Amarok/DCOP-Amarok-0.035.ebuild,v 1.4 2007/05/01 10:12:08 corsair Exp $

inherit perl-module

DESCRIPTION="Perl Interface to Amarok via system's dcop"
SRC_URI="mirror://cpan/authors/id/J/JC/JCMULLER/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~jcmuller/"

RDEPEND="dev-perl/DCOP
	media-sound/amarok"

IUSE=""

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~ppc64 x86"

SRC_TEST="do"
