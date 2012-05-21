# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Mini/CPAN-Mini-1.111.8.ebuild,v 1.3 2012/05/21 10:09:04 phajdan.jr Exp $

EAPI=4

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.111008
inherit perl-module

DESCRIPTION="create a minimal mirror of CPAN"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~sparc x86"
IUSE="test"

RDEPEND="dev-perl/libwww-perl
	>=virtual/perl-IO-Compress-1.20
	dev-perl/File-HomeDir
	>=virtual/perl-File-Path-2.08
	dev-perl/URI"
DEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.96 )"

SRC_TEST="do"
