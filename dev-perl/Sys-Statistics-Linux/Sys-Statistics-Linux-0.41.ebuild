# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sys-Statistics-Linux/Sys-Statistics-Linux-0.41.ebuild,v 1.1 2008/10/02 05:36:57 tove Exp $

MODULE_AUTHOR=BLOONIX
inherit perl-module

DESCRIPTION="Collect linux system statistics"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"
SRC_TEST="do"

RDEPEND="dev-lang/perl
	dev-perl/UNIVERSAL-require"
DEPEND="${RDEPEND}
	dev-perl/module-build
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"
