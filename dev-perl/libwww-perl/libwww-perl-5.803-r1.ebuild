# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libwww-perl/libwww-perl-5.803-r1.ebuild,v 1.10 2006/02/06 20:35:36 blubb Exp $

inherit perl-module

DESCRIPTION="A collection of Perl Modules for the WWW"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~gaas/${P}/"
IUSE="ssl"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"

DEPEND=">=perl-core/libnet-1.0703
	>=dev-perl/HTML-Parser-3.34
	>=dev-perl/URI-1.10
	>=perl-core/Digest-MD5-2.12
	dev-perl/HTML-Tree
	>=perl-core/MIME-Base64-2.12
	dev-perl/Compress-Zlib
	ssl? ( dev-perl/Crypt-SSLeay )"

src_compile() {
	echo "y" | perl-module_src_compile
}

src_install() {
	perl-module_src_install
	dosym /usr/bin/lwp-request /usr/bin/GET
	dosym /usr/bin/lwp-request /usr/bin/POST
	dosym /usr/bin/lwp-request /usr/bin/HEAD
}
