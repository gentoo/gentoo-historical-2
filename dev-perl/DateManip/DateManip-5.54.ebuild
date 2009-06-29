# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateManip/DateManip-5.54.ebuild,v 1.5 2009/06/29 23:37:46 jer Exp $

inherit perl-module

DESCRIPTION="Perl date manipulation routines"
HOMEPAGE="http://search.cpan.org/dist/Date-Manip"
SRC_URI="mirror://cpan/authors/id/S/SB/SBECK/Date-Manip-${PV}.tar.gz"
SRC_TEST="do"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"

S=${WORKDIR}/Date-Manip-${PV}

mydoc="HISTORY TODO"
