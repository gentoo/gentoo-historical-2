# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Term-ANSIColor/Term-ANSIColor-1.08.ebuild,v 1.1 2004/06/26 18:43:18 stuart Exp $

IUSE=""

inherit perl-module

MY_PN="ANSIColor"
MY_P="$MY_PN-$PV"
DESCRIPTION="Color screen output using ANSI escape sequences."
SRC_URI="http://www.cpan.org/authors/id/R/RR/RRA/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/dist/$MY_PN/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc"

SRC_TEST="do"
S="${WORKDIR}/$MY_P"
