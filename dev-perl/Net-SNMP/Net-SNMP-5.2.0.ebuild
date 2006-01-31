# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SNMP/Net-SNMP-5.2.0.ebuild,v 1.6 2006/01/31 21:35:04 agriffis Exp $

inherit perl-module

DESCRIPTION="A SNMP Perl Module"
SRC_URI="mirror://cpan/authors/id/D/DT/DTOWN/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Net/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha ~amd64 ~ia64 ppc ~ppc64 sparc x86"
IUSE=""

DEPEND="${DEPEND}
	>=perl-core/libnet-1.0703
	>=perl-core/Digest-MD5-2.11
	>=dev-perl/Digest-SHA1-1.02
	>=dev-perl/Digest-HMAC-1.0
	>=dev-perl/Crypt-DES-2.03"
