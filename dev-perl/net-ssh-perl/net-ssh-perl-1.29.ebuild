# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/net-ssh-perl/net-ssh-perl-1.29.ebuild,v 1.4 2006/01/31 23:02:38 agriffis Exp $

inherit perl-module

MY_P=Net-SSH-Perl-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl client Interface to SSH"
HOMEPAGE="http://search.cpan.org/~drolsky/${MY_P}.tar.gz"
SRC_URI="mirror://cpan/authors/id/D/DB/DBROBINS/${MY_P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~mips ~ppc ~sparc x86"
IUSE=""

DEPEND=">=dev-perl/Math-GMP-1.04
		>=dev-perl/string-crc32-1.2
		>=dev-perl/math-pari-2.001804
		perl-core/Digest-MD5
		>=dev-perl/Digest-SHA1-2.10
		dev-perl/Digest-HMAC
		dev-perl/crypt-dh
		>=dev-perl/crypt-dsa-0.11
		perl-core/MIME-Base64
		>=dev-perl/convert-pem-0.05
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
		dev-perl/crypt-idea
		dev-perl/Crypt-OpenSSL-RSA
		dev-perl/crypt-rsa
		dev-perl/digest-bubblebabble"

src_compile() {
	echo "" | perl-module_src_compile
}
