# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Tester/Test-Tester-0.107.ebuild,v 1.12 2009/05/16 08:12:54 aballier Exp $

MODULE_AUTHOR=FDALY
inherit perl-module

DESCRIPTION="Ease testing test modules built with Test::Builder"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
