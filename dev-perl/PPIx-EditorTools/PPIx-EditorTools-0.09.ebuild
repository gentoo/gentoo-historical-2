# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PPIx-EditorTools/PPIx-EditorTools-0.09.ebuild,v 1.1 2010/02/15 13:57:10 tove Exp $

EAPI=2

MODULE_AUTHOR=AZAWAWI
inherit perl-module

DESCRIPTION="Utility methods and base class for manipulating Perl via PPI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-perl/Class-XSAccessor-1.02
	>=dev-perl/PPI-1.203"
DEPEND="test? ( ${RDEPEND}
		>=dev-perl/Test-Differences-0.48.01 )"

SRC_TEST=no
