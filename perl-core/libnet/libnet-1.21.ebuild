# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/libnet/libnet-1.21.ebuild,v 1.6 2007/08/25 13:29:40 vapier Exp $

inherit perl-module

DESCRIPTION="A URI Perl Module"
HOMEPAGE="http://search.cpan.org/~gbarr/"
SRC_URI="mirror://cpan/authors/id/G/GB/GBARR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="sasl"

SRC_TEST="do"

DEPEND="dev-lang/perl
		sasl? ( dev-perl/Authen-SASL )"

src_compile() {
	cp ${O}/files/libnet.cfg .
	perl-module_src_compile
}
