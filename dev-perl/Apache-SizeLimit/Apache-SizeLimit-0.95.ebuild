# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Apache-SizeLimit/Apache-SizeLimit-0.95.ebuild,v 1.1 2011/03/15 16:59:02 idl0r Exp $

EAPI="3"

MODULE_AUTHOR="PHRED"

inherit perl-module

DESCRIPTION="Graceful exit for large children"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

# mod_perl < 2.0.5 bundles Apache-SizeLimit
DEPEND="dev-lang/perl
	dev-perl/Linux-Smaps
	dev-perl/Linux-Pid
	!<www-apache/mod_perl-2.0.5
	>=www-apache/mod_perl-2.0.5"
RDEPEND="${DEPEND}"
