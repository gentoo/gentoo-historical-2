# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sys-Statistics-Linux/Sys-Statistics-Linux-0.43.ebuild,v 1.1 2008/10/31 08:28:23 tove Exp $

MODULE_AUTHOR=BLOONIX
inherit perl-module

DESCRIPTION="Collect linux system statistics"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"
SRC_TEST="do"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	dev-perl/module-build
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"
