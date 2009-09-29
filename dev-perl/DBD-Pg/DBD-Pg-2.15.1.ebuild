# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBD-Pg/DBD-Pg-2.15.1.ebuild,v 1.4 2009/09/29 17:57:42 klausman Exp $

MODULE_AUTHOR=TURNSTEP
inherit perl-module eutils

DESCRIPTION="The Perl DBD::Pg Module"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/perl-Test-Simple
	virtual/perl-version
	>=virtual/perl-Test-Harness-2.03
	>=dev-perl/DBI-1.52
	>=virtual/postgresql-base-7.3"

mydoc="README"

# testcases require a local database with an
# open password for the postgres user.
SRC_TEST="skip"

src_compile() {
	postgres_include="$(readlink -f /usr/include/postgresql)"
	postgres_lib="${postgres_include//include/lib}"
	# Fall-through case is the non-split postgresql
	# The active cases instead get us the matching libdir for the includedir.
	for i in lib lib64 ; do
		if [ -d ${postgres_lib}/${i} ]; then
			postgres_lib="${postgres_lib}/${i}"
			break
		fi
	done

	# env variables for compilation:
	export POSTGRES_INCLUDE="${postgres_include}"
	export POSTGRES_LIB="${postgres_lib}"
	perl-module_src_compile
}
