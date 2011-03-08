# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/CPAN-Meta/CPAN-Meta-2.110.580.ebuild,v 1.2 2011/03/08 14:37:39 jer Exp $

EAPI=3

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=2.110580
inherit perl-module

DESCRIPTION="The distribution metadata for a CPAN dist"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~ppc-aix ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=virtual/perl-CPAN-Meta-YAML-0.2.0
	>=virtual/perl-Parse-CPAN-Meta-1.440
	>=virtual/perl-JSON-PP-2.271.30
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Version-Requirements-0.101.20
	>=virtual/perl-version-0.82"
DEPEND="${RDEPEND}
	virtual/perl-File-Spec
	>=virtual/perl-File-Temp-0.20
	virtual/perl-IO
	>=virtual/perl-Test-Simple-0.96
	>=virtual/perl-ExtUtils-MakeMaker-6.56"

SRC_TEST="do"
