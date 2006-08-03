# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/DB_File/DB_File-1.811.ebuild,v 1.5 2006/08/03 00:00:36 mcummings Exp $

inherit perl-module multilib eutils

DESCRIPTION="A Berkeley DB Support Perl Module"
HOMEPAGE="http://www.cpan.org/modules/by-module/DB_File/${P}.readme"
SRC_URI="mirror://cpan/authors/id/P/PM/PMQS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl
		sys-libs/db"
RDEPEND="${DEPEND}"

SRC_TEST="do"

mydoc="Changes"

src_unpack() {
	unpack ${A}
	if [ $(get_libdir) != "lib" ] ; then
		sed -i -e "s:^LIB.*:LIB = /usr/$(get_libdir):" \
		${S}/config.in || die
	fi
	cd ${S}
	epatch ${FILESDIR}/DB_File-MakeMaker.patch
}
