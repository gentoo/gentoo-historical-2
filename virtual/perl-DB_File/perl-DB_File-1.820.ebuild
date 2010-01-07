# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-DB_File/perl-DB_File-1.820.ebuild,v 1.11 2010/01/07 20:05:55 tove Exp $

inherit eutils

DESCRIPTION="Virtual for DB_File"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="|| ( ~dev-lang/perl-5.10.1 ~perl-core/DB_File-${PV} )"

pkg_setup() {
	if ! has_version "~perl-core/DB_File-${PV}" && ! built_with_use dev-lang/perl berkdb ; then
		die "You must build perl with USE=\"berkdb\" or install perl-core/DB_File-${PV}"
	fi
}
