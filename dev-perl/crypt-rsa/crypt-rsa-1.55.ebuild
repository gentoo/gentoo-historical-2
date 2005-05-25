# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-rsa/crypt-rsa-1.55.ebuild,v 1.4 2005/05/25 09:09:06 mcummings Exp $

inherit perl-module

MY_P=Crypt-RSA-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Diffie-Hellman key exchange system"
HOMEPAGE="http://search.cpan.org/CPAN/authors/id/V/VI/VIPUL/${MY_P}.readme"
SRC_URI="mirror://cpan/authors/id/V/VI/VIPUL/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~hppa ~amd64 ~mips"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/math-pari-2.010603
	dev-perl/crypt-random
	dev-perl/Crypt-Blowfish
	dev-perl/Sort-Versions
	dev-perl/Digest-SHA1
	perl-core/Digest-MD5
	dev-perl/class-loader
	dev-perl/digest-md2
	dev-perl/convert-ascii-armour
	dev-perl/tie-encryptedhash
	dev-perl/crypt-primes
	dev-perl/data-buffer
	dev-perl/crypt-cbc"
