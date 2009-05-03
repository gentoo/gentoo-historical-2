# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-LibIDN/Net-LibIDN-0.12.ebuild,v 1.5 2009/05/03 17:39:34 maekke Exp $

MODULE_AUTHOR=THOR
inherit perl-module

DESCRIPTION="Perl bindings for GNU Libidn"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl
	net-dns/libidn"
RDEPEND="${DEPEND}"

SRC_TEST=do
