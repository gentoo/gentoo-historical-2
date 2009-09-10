# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Digest-SHA/Digest-SHA-5.47.ebuild,v 1.3 2009/09/10 08:35:50 fauli Exp $

MODULE_AUTHOR=MSHELOR
inherit perl-module

DESCRIPTION="Perl extension for SHA-1/224/256/384/512"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND="dev-lang/perl"

SRC_TEST="do"
