# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/libnet/libnet-1.16.ebuild,v 1.2 2003/07/27 10:43:49 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A URI Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-category/05_Networking_Devices_IPC/Net/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-category/05_Networking_Devices_IPC/Net/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~amd64 ~ppc ~sparc ~alpha ~hppa ~arm"

src_compile() {
	cp ${O}/files/libnet.cfg .
	perl-module_src_compile
}
