# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-LibIDN/Net-LibIDN-0.10.ebuild,v 1.2 2008/08/24 12:41:19 maekke Exp $

MODULE_AUTHOR=THOR
inherit perl-module

DESCRIPTION="Perl bindings for GNU Libidn"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	net-dns/libidn"

SRC_TEST=do
