# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/net-server/net-server-0.87.ebuild,v 1.2 2004/06/25 00:49:53 agriffis Exp $

inherit perl-module

MY_P=Net-Server-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Extensible, general Perl server engine"
HOMEPAGE="http://search.cpan.org/~bbb/${MY_P}/"
SRC_URI="http://search.cpan.org/CPAN/authors/id/B/BB/BBB/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~hppa ~mips ~ppc ~sparc ~amd64"

SRC_TEST="do"

mydoc="README"
