# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Compress-Raw-Zlib/Compress-Raw-Zlib-2.005.ebuild,v 1.1 2008/11/02 07:17:55 tove Exp $

inherit perl-module multilib

DESCRIPTION="Low-Level Interface to zlib compression library"
HOMEPAGE="http://search.cpan.org/~pmqs"
SRC_URI="mirror://cpan/authors/id/P/PM/PMQS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/perl
		sys-libs/zlib"

DEPEND=${RDEPEND}

SRC_TEST="do"

src_unpack() {
	perl-module_src_unpack

	cat - > "${S}/config.in" <<EOF
BUILD_ZLIB = False
INCLUDE = /usr/include
LIB = /usr/${get_libdir}

OLD_ZLIB = False
GZIP_OS_CODE = AUTO_DETECT
EOF
}
