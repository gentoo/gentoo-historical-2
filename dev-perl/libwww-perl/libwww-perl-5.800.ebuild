# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libwww-perl/libwww-perl-5.800.ebuild,v 1.14 2005/06/04 06:22:10 mcummings Exp $

inherit perl-module

DESCRIPTION="A collection of Perl Modules for the WWW"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~gaas/${P}/"
IUSE="ssl"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 sparc x86"

DEPEND=">=dev-perl/libnet-1.16
	>=dev-perl/HTML-Parser-3.34
	>=dev-perl/URI-1.10
	>=perl-core/Digest-MD5-2.12
	>=perl-core/MIME-Base64-2.12
	dev-perl/Compress-Zlib
	ssl? ( dev-perl/Crypt-SSLeay )"

src_compile() {
	yes "" | perl Makefile.PL ${myconf} \
		PREFIX=${D}/usr INSTALLDIRS=vendor
}

pkg_postinst() {
	perl-module_pkg_postinst
}
