# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Path-Class/Path-Class-0.240.0.ebuild,v 1.3 2012/02/06 19:19:37 ranger Exp $

EAPI=4

MODULE_AUTHOR=KWILLIAMS
MODULE_VERSION=0.24
inherit perl-module

DESCRIPTION="Cross-platform path specification manipulation"

SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND=">=virtual/perl-File-Spec-0.87"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"
