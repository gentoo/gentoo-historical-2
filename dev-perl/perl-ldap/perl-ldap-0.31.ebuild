# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perl-ldap/perl-ldap-0.31.ebuild,v 1.16 2006/08/06 03:00:26 mcummings Exp $

inherit perl-module

DESCRIPTION="A collection of perl modules which provide an object-oriented interface to LDAP servers."
HOMEPAGE="http://search.cpan.org/~gbarr/${P}/"
SRC_URI="mirror://cpan/authors/id/G/GB/GBARR/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm ia64 s390 hppa ppc64 amd64"
IUSE="sasl xml ssl"

DEPEND="dev-perl/Convert-ASN1
	dev-perl/URI
	sasl? ( virtual/perl-Digest-MD5 dev-perl/Authen-SASL )
	xml? ( dev-perl/XML-Parser )
	ssl? ( >=dev-perl/IO-Socket-SSL-0.81 )
	dev-lang/perl"
RDEPEND="${DEPEND}"

