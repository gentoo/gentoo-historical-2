# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Eval-Closure/Eval-Closure-0.30.0.ebuild,v 1.2 2011/04/15 14:30:18 mr_bones_ Exp $

EAPI=4

MODULE_AUTHOR=DOY
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="safely and cleanly create closures via string eval"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Sub-Exporter
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
	)
"

SRC_TEST="do"
