# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-Time-Local/perl-Time-Local-1.11.ebuild,v 1.5 2006/10/26 22:09:54 mcummings Exp $

DESCRIPTION="Virtual for Time-Local"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"

IUSE=""
DEPEND=""
RDEPEND="|| ( >=dev-lang/perl-5.8.8 ~perl-core/Time-Local-${PV} )"

