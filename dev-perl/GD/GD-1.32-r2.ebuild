# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GD/GD-1.32-r2.ebuild,v 1.4 2002/10/05 05:39:11 drobbins Exp $

IUSE="X"

inherit perl-module

S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl DBI Module"
SRC_URI="http://www.cpan.org/modules/by-module/GD/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/GD/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="${DEPEND}
	>=media-libs/libgd-1.8.3
	X? ( virtual/x11 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp Makefile.PL Makefile.PL.orig
	sed -e "s:my \$JPEG.*:my \$JPEG='y';:" \
		-e "s:my \$TTF.*:my \$TTF='y';:" \
		Makefile.PL.orig > Makefile.PL

	use X && ( \
		cp Makefile.PL Makefile.PL.orig
		sed -e "s:my \$XPM.*:my \$XPM='y';:" \
			Makefile.PL.orig > Makefile.PL
	) || ( \
		cp Makefile.PL Makefile.PL.orig
		sed -e "s:my \$XPM.*:my \$XPM='n';:" \
			Makefile.PL.orig > Makefile.PL
	)

	perl-module_src_prep
}

src_install () {
	perl-module_src_install
	dohtml GD.html
}
