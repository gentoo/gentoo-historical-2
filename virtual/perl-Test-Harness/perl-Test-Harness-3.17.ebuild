# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-Test-Harness/perl-Test-Harness-3.17.ebuild,v 1.2 2009/08/25 10:56:52 tove Exp $

DESCRIPTION="Virtual for Test-Harness"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| ( ~dev-lang/perl-5.10.1 ~perl-core/Test-Harness-${PV} )"
