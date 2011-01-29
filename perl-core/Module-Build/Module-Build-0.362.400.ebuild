# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Module-Build/Module-Build-0.362.400.ebuild,v 1.1 2011/01/29 09:56:33 tove Exp $

EAPI=3

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.3624
inherit perl-module

DESCRIPTION="Build and install Perl modules"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=virtual/perl-CPAN-Meta-YAML-0.2
	>=virtual/perl-Module-Metadata-1.0.2
	>=virtual/perl-Perl-OSType-1
	>=virtual/perl-ExtUtils-CBuilder-0.27
	>=virtual/perl-ExtUtils-ParseXS-2.22.05
	>=virtual/perl-Archive-Tar-1.09
	>=virtual/perl-Test-Harness-3.16
	>=virtual/perl-version-0.87
"
RDEPEND="${DEPEND}"

SRC_TEST="do"
