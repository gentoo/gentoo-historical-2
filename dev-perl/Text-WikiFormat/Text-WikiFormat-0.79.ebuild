# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-WikiFormat/Text-WikiFormat-0.79.ebuild,v 1.8 2010/01/14 15:51:57 grobian Exp $

MODULE_AUTHOR=CHROMATIC
inherit perl-module

DESCRIPTION="Translate Wiki formatted text into other formats"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

SRC_TEST="do"

RDEPEND="dev-perl/URI
	virtual/perl-Scalar-List-Utils
	dev-lang/perl"
DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.28"
