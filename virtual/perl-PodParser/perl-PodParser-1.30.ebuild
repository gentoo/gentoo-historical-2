# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-PodParser/perl-PodParser-1.30.ebuild,v 1.2 2006/02/13 19:50:29 mcummings Exp $

DESCRIPTION="Virtual for PodParser"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"

IUSE=""
DEPEND=""
RDEPEND="|| ( ~dev-lang/perl-5.8.7 ~perl-core/PodParser-${PV} )"

