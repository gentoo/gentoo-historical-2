# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Digest-HMAC/Digest-HMAC-1.01-r1.ebuild,v 1.2 2002/12/09 04:21:06 manson Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Keyed Hashing for Message Authentication"
SRC_URI="http://www.cpan.org/authors/id/GAAS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/doc/GAAS/${P}/README"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc  alpha"

mydoc="rfc*.txt"

newdepend "dev-perl/Digest-MD5 dev-perl/Digest-SHA1"

src_compile() {
	perl-module_src_compile
	make test || die "Tests didn't work out. Aborting!"
}
