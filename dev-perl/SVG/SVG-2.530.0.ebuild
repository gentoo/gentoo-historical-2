# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SVG/SVG-2.530.0.ebuild,v 1.1 2012/08/09 18:32:46 tove Exp $

EAPI=4

MODULE_AUTHOR=SZABGAB
MODULE_VERSION=2.53
inherit perl-module

DESCRIPTION="Perl extension for generating Scalable Vector Graphics (SVG) documents"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND="virtual/perl-parent"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST=do
