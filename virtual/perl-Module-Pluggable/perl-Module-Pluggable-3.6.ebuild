# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/perl-Module-Pluggable/perl-Module-Pluggable-3.6.ebuild,v 1.2 2008/11/03 16:47:02 mr_bones_ Exp $

DESCRIPTION="automatically give your module the ability to have plugins"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"

IUSE=""
DEPEND=""

RDEPEND="|| ( ~dev-lang/perl-5.10.0 ~perl-core/Module-Pluggable-${PV} )"
