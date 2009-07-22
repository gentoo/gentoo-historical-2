# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/BerkeleyDB/BerkeleyDB-0.39.ebuild,v 1.3 2009/07/22 04:16:57 darkside Exp $

EAPI=2

MODULE_AUTHOR=PMQS
inherit perl-module eutils db-use

DESCRIPTION="This module provides Berkeley DB interface for Perl."

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86"
IUSE="test"

# Install DB_File if you want older support. BerkleyDB no longer
# supports less than 2.0.

RDEPEND=">=sys-libs/db-2.0"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/Gentoo-config-0.26.diff
	# on Gentoo/FreeBSD we cannot trust on the symlink /usr/include/db.h
	# as for Gentoo/Linux, so we need to esplicitely declare the exact berkdb
	# include path
	sed -i -e "s:/usr/include:$(db_includedir):" "${S}"/config.in || die "berkdb include directory"
}
