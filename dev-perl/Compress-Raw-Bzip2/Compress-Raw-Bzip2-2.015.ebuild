# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Compress-Raw-Bzip2/Compress-Raw-Bzip2-2.015.ebuild,v 1.5 2008/10/22 19:18:56 gmsoft Exp $

MODULE_AUTHOR=PMQS
inherit perl-module

DESCRIPTION="Low-Level Interface to bzip2 compression library"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 hppa ppc64 sparc ~x86"
IUSE="test"

RDEPEND="dev-lang/perl
	app-arch/bzip2"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST=do

src_compile(){
	BUILD_BZIP2=0 BZIP2_INCLUDE= BZIP2_LIB= \
		perl-module_src_compile
}
