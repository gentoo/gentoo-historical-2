# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-DNS/Net-DNS-0.38.ebuild,v 1.16 2005/05/25 15:10:53 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl Net::DNS - Perl DNS Resolver Module"
SRC_URI="http://www.net-dns.org/download/${P}.tar.gz"
HOMEPAGE="http://www.fuhr.org/~mfuhr/perldns/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~amd64 ~ppc sparc ~alpha hppa mips"
IUSE=""

DEPEND="perl-core/Digest-MD5
		dev-perl/Digest-HMAC
		perl-core/MIME-Base64 || ( perl-core/Test-Simple >=dev-lang/perl-5.8.0-r12 )"
mydoc="TODO"

src_compile() {

	echo "n" | perl-module_src_compile
	perl-module_src_test
}
