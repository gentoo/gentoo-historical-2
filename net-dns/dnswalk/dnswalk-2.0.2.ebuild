# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnswalk/dnswalk-2.0.2.ebuild,v 1.8 2002/12/09 04:33:11 manson Exp $

S=${WORKDIR}
DESCRIPTION="dnswalk is a DNS database debugger"
SRC_URI="http://www.visi.com/~barr/dnswalk/${P}.tar.gz"
HOMEPAGE="http://www.visi.com/~barr/dnswalk/"

DEPEND=">=dev-perl/Net-DNS-0.12"  


SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc "

src_compile() {

	mv dnswalk dnswalk.orig
	sed 's:#!/usr/contrib/bin/perl:#!/usr/bin/perl:' \
		dnswalk.orig > dnswalk

}

src_install () {

	dobin dnswalk

	dodoc CHANGES README TODO \
		do-dnswalk makereports sendreports rfc1912.txt dnswalk.errors
	doman dnswalk.1

}
