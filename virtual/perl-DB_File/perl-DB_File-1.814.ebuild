# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-DB_File/perl-DB_File-1.814.ebuild,v 1.6 2006/11/19 18:35:28 mcummings Exp $

inherit eutils

DESCRIPTION="Virtual for DB_File"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"

IUSE="berkdb"
DEPEND=""
RDEPEND="|| ( ~dev-lang/perl-5.8.8 ~perl-core/DB_File-${PV} )"

src_unpack() {
	if ! has_version '~perl-core/DB_File-${PV}' && ! built_with_use dev-lang/perl berkdb ; then
			die "You must build perl with USE=\"berkdb\" or install perl-core/DB_File-${PV}"
	fi
}

