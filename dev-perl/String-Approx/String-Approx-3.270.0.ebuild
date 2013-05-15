# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/String-Approx/String-Approx-3.270.0.ebuild,v 1.2 2013/05/15 14:08:32 ago Exp $

EAPI=5

MODULE_AUTHOR=JHI
MODULE_VERSION=3.27
inherit perl-module

DESCRIPTION="Perl extension for approximate string matching (fuzzy matching)"

LICENSE="|| ( Artistic-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

SRC_TEST="do"
