# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-HTML/IO-HTML-0.40.0.ebuild,v 1.1 2012/10/07 15:16:10 tove Exp $

EAPI=4

MODULE_AUTHOR=CJM
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Open an HTML file with automatic charset detection"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-Encode-2.100.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Scalar-List-Utils
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.880.0
	)
"

SRC_TEST=do
