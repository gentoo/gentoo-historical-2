# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Alien-wxWidgets/Alien-wxWidgets-0.21.ebuild,v 1.4 2007/04/22 21:57:43 dirtyepic Exp $

inherit perl-module wxwidgets

MY_P=Alien-wxWidgets-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Building, finding and using wxWidgets binaries"
SRC_URI="mirror://cpan/authors/id/M/MB/MBARBON/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~mbarbon/${P}/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ~ia64 ~x86"
IUSE="unicode"

SRC_TEST="do"

DEPEND="dev-lang/perl
	=x11-libs/wxGTK-2.6*
	>=dev-perl/module-build-0.26
	>=dev-perl/Module-Pluggable-3.1-r1"

perl-module_src_prep() {
	perlinfo

	WX_GTK_VER="2.6"

	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi

	echo no | perl Build.PL --installdirs=vendor \
		--destdir=${D} \
		--libdoc= || die "perl Build.PL has failed!"
}
