# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Term-ANSIColor/Term-ANSIColor-2.00.ebuild,v 1.2 2009/06/19 22:14:19 ranger Exp $

MY_PN="ANSIColor"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"
MODULE_AUTHOR=RRA
inherit perl-module

DESCRIPTION="Color screen output using ANSI escape sequences."

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
