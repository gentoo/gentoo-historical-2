# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-MIME-Base64/perl-MIME-Base64-3.07.ebuild,v 1.16 2009/03/04 23:52:53 loki_val Exp $

DESCRIPTION="Virtual for MIME-Base64"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="|| ( >=dev-lang/perl-5.8.8 ~perl-core/MIME-Base64-${PV} )"
