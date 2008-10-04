# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Z3950-ZOOM/Net-Z3950-ZOOM-1.25.ebuild,v 1.2 2008/10/04 21:40:13 tove Exp $

MODULE_AUTHOR="MIRK"

inherit perl-module

DESCRIPTION="Perl extension for invoking the ZOOM-C API"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="dev-lang/perl
	>=dev-libs/yaz-2.1.50"
