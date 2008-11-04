# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/libnet/libnet-1.22.ebuild,v 1.3 2008/11/04 09:49:00 vapier Exp $

inherit perl-module

DESCRIPTION="A URI Perl Module"
HOMEPAGE="http://search.cpan.org/~gbarr/"
SRC_URI="mirror://cpan/authors/id/G/GB/GBARR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ia64 ~mips ~ppc ~ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="sasl"

SRC_TEST="do"

DEPEND="dev-lang/perl
		sasl? ( dev-perl/Authen-SASL )"

src_unpack() {
	perl-module_src_unpack
	cp "${FILESDIR}"/libnet.cfg "${S}"
}
