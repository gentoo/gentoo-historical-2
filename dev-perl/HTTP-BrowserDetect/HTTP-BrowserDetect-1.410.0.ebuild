# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-BrowserDetect/HTTP-BrowserDetect-1.410.0.ebuild,v 1.3 2012/02/17 11:53:36 ago Exp $

EAPI=4

MODULE_AUTHOR=OALDERS
MODULE_VERSION=1.41
inherit perl-module

DESCRIPTION="Detect browser, version, OS from UserAgent"

SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="virtual/perl-Module-Build
	test? (
		dev-perl/Data-Dump
		dev-perl/File-Slurp
		virtual/perl-JSON-PP
	)"

SRC_TEST="do"
