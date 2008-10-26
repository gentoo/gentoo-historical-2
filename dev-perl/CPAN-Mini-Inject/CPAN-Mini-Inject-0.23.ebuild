# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/CPAN-Mini-Inject/CPAN-Mini-Inject-0.23.ebuild,v 1.1 2008/10/26 09:57:01 tove Exp $

MODULE_AUTHOR=SSORICHE
inherit perl-module

DESCRIPTION="Inject modules into a CPAN::Mini mirror. "

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~ia64 ~sparc ~x86"
IUSE=""

# Disabled
#SRC_TEST="do"

DEPEND="dev-perl/libwww-perl
	dev-perl/Compress-Zlib
	dev-perl/Archive-Tar
	>=dev-perl/CPAN-Mini-0.32
	dev-perl/CPAN-Checksums
	dev-lang/perl"
#	test? ( dev-perl/HTTP-Server-Simple )"
RDEPEND="${DEPEND}"
