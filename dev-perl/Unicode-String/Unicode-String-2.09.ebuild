# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-String/Unicode-String-2.09.ebuild,v 1.17 2010/01/29 14:19:46 tove Exp $

EAPI=2

MODULE_AUTHOR=GAAS
inherit perl-module

DESCRIPTION="String manipulation for Unicode strings"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=">=virtual/perl-MIME-Base64-2.11"
DEPEND="${RDEPEND}"
