# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Test-Harness/Test-Harness-2.64.ebuild,v 1.7 2007/04/15 21:07:56 corsair Exp $

inherit perl-module

DESCRIPTION="Runs perl standard test scripts with statistics"
HOMEPAGE="http://search.cpan.org/search?dist=Test-Harness"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 m68k ~mips ~ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl"

SRC_TEST="do"
mydoc="rfc*.txt"
