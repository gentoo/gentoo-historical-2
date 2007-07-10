# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sys-Hostname-Long/Sys-Hostname-Long-1.2.ebuild,v 1.16 2007/07/10 23:33:27 mr_bones_ Exp $

inherit perl-module

DESCRIPTION="Try every conceivable way to get full hostname"
SRC_URI="mirror://cpan/authors/id/S/SC/SCOTT/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~scott/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha ~amd64 hppa ppc ppc64 sparc x86"
IUSE=""

mydoc="TODO"

DEPEND="dev-lang/perl"
