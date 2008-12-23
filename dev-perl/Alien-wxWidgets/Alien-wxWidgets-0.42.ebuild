# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Alien-wxWidgets/Alien-wxWidgets-0.42.ebuild,v 1.1 2008/12/23 18:44:17 robbat2 Exp $

MODULE_AUTHOR=MBARBON
inherit perl-module wxwidgets

DESCRIPTION="Building, finding and using wxWidgets binaries"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE="unicode"

SRC_TEST="do"

RDEPEND="dev-lang/perl
	=x11-libs/wxGTK-2.8*
	>=virtual/perl-Module-Pluggable-3.1-r1"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

perl-module_src_prep() {
	perlinfo

	WX_GTK_VER="2.8"

	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi

	echo no | perl Build.PL --installdirs=vendor \
		--destdir="${D}" \
		--libdoc= || die "perl Build.PL has failed!"
}
