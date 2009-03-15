# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Font-TTF/Font-TTF-0.45.ebuild,v 1.11 2009/03/15 18:42:39 armin76 Exp $

MODULE_AUTHOR=MHOSKEN
inherit perl-module

DESCRIPTION="module for compiling and altering fonts"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/perl-Compress-Zlib
	dev-perl/XML-Parser
	dev-lang/perl"

SRC_TEST="do"
