# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-SSLeay/Crypt-SSLeay-0.51-r1.ebuild,v 1.2 2006/09/08 23:12:54 tcort Exp $

inherit perl-module

DESCRIPTION="Crypt::SSLeay module for perl"
SRC_URI="mirror://cpan/authors/id/C/CH/CHAMAS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~chamas/${P}/"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

# Disabling tests for now. Opening a port always leads to mixed results for
# folks - bug 59554
#SRC_TEST="do"

DEPEND="virtual/libc
	>=dev-lang/perl-5
	dev-perl/libwww-perl
	>=dev-libs/openssl-0.9.7c"
RDEPEND="${DEPEND}"

export OPTIMIZE="${CFLAGS}"
myconf="${myconf} /usr"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Without the SSL_library_init() before you will get a segfault with
	# openssl 0.9.8a and later versions - bug 142703
	epatch ${FILESDIR}/rt-15241.patch
}
