# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Kismet/Net-Kismet-0.04.ebuild,v 1.2 2003/06/21 21:36:36 drobbins Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Module for writing perl Kismet clients"
SRC_URI="http://www.kismetwireless.net/code/${P}.tar.gz"
HOMEPAGE="http://www.kismetwireless.net"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64"

src_compile() {
	
	perl-module_src_compile
	perl-module_src_test
}
