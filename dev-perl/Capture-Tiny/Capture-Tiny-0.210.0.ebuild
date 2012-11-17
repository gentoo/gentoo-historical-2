# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Capture-Tiny/Capture-Tiny-0.210.0.ebuild,v 1.1 2012/11/17 20:01:30 tove Exp $

EAPI=4

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.21
inherit perl-module

DESCRIPTION="Capture STDOUT and STDERR from Perl, XS or external programs"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-perl/Inline
	)
"

SRC_TEST=do
