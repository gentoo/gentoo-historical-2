# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Sys-Syslog/Sys-Syslog-0.27.ebuild,v 1.1 2008/10/11 08:17:59 tove Exp $

MODULE_AUTHOR=SAPER
inherit perl-module

DESCRIPTION="Provides same functionality as BSD syslog"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl"

# Tests disabled - they attempt to verify on the live system
#SRC_TEST="do"
