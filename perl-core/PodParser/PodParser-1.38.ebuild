# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/PodParser/PodParser-1.38.ebuild,v 1.1 2009/02/10 13:30:30 tove Exp $

MODULE_AUTHOR=MAREKR
MY_PN=Pod-Parser
MY_P=${MY_PN}-${PV}

inherit perl-module

DESCRIPTION="Base class for creating POD filters and translators"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl"

S=${WORKDIR}/${MY_P}

SRC_TEST="do"
