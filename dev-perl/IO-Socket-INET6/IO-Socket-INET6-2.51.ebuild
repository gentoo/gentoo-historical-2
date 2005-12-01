# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Socket-INET6/IO-Socket-INET6-2.51.ebuild,v 1.2 2005/12/01 22:17:15 metalgod Exp $

inherit perl-module

DESCRIPTION="Work with IO sockets in ipv6"
HOMEPAGE="http://search.cpan.org/~mondejar/${P}"
SRC_URI="mirror://cpan/authors/id/M/MO/MONDEJAR/${P}.tar.gz"

LICENSE="|| (Artistic GPL-2)"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""
SRC_TEST="do"

RDEPEND="dev-perl/Socket6"

