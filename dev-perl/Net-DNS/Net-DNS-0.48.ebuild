# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-DNS/Net-DNS-0.48.ebuild,v 1.1 2004/09/21 12:22:33 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl Net::DNS - Perl DNS Resolver Module"
SRC_URI="http://search.cpan.org/CPAN/authors/id/C/CR/CREIN/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~crein/${P}/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~ia64 ~hppa ~ppc64"
IUSE=""

SRC_TEST="do"


DEPEND="dev-perl/Digest-MD5
		dev-perl/Digest-HMAC
		dev-perl/MIME-Base64 || ( dev-perl/Test-Simple >=dev-lang/perl-5.8.0-r12 )"
mydoc="TODO"

src_compile() {

	echo "n" | perl-module_src_compile
}
