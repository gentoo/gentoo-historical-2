# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-RegExp/XML-RegExp-0.03-r1.ebuild,v 1.19 2008/05/21 18:19:03 tove Exp $

MODULE_AUTHOR=TJMATHER
inherit perl-module

DESCRIPTION="Regular expressions for XML tokens"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/XML-Parser-2.29
	dev-lang/perl"
