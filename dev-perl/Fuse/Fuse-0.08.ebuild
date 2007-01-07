# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Fuse/Fuse-0.08.ebuild,v 1.2 2007/01/07 23:43:03 mcummings Exp $

inherit perl-module

DESCRIPTION="Fuse module for perl"
SRC_URI="http://cpan.uwinnipeg.ca/cpan/authors/id/D/DP/DPAVLIN/${P}.tar.gz"
HOMEPAGE="http://cpan.uwinnipeg.ca/dist/Fuse"

DEPEND="sys-fs/fuse
	dev-lang/perl"

# Test is whack - ChrisWhite
#SRC_TEST="do"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
IUSE=""

