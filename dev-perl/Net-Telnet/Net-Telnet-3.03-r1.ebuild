# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Telnet/Net-Telnet-3.03-r1.ebuild,v 1.14 2005/11/27 22:06:13 tgall Exp $

inherit perl-module

DESCRIPTION="A Telnet Perl Module"
HOMEPAGE="http://www.cpan.org/modules/by-module/Net/${P}.readme"
SRC_URI="mirror://cpan/authors/id/J/JR/JROGERS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=dev-perl/libnet-1.0703"
