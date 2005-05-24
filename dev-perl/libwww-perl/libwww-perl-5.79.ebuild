# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libwww-perl/libwww-perl-5.79.ebuild,v 1.11 2005/05/24 15:51:15 mcummings Exp $

inherit perl-module

DESCRIPTION="A collection of Perl Modules for the WWW"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~gaas/${P}/"
IUSE="ssl"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha hppa ia64 ~mips"

DEPEND=">=dev-perl/libnet-1.0703
	>=dev-perl/HTML-Parser-3.34
	>=dev-perl/URI-1.0.9
	>=perl-core/Digest-MD5-2.12
	>=dev-perl/MIME-Base64-2.12
	ssl? ( dev-perl/Crypt-SSLeay )"

src_compile() {
	yes "" | perl Makefile.PL ${myconf} \
		PREFIX=${D}/usr INSTALLDIRS=vendor
}

pkg_postinst() {
	perl-module_pkg_postinst
}
