# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.60a.ebuild,v 1.2 2004/06/06 15:49:02 mcummings Exp $

IUSE=""

inherit perl-module

MY_PV=${PV/a//}
MY_P=SOAP-Lite-${MY_PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Provides a simple and lightweight interface to the SOAP protocol (sic) both on client and server side."

SRC_URI="http://cpan.valueclick.com/modules/by-module/SOAP/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/SOAP/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha"

SRC_TEST="do"

DEPEND="${DEPEND}
	dev-perl/XML-Parser
	dev-perl/libwww-perl
	dev-perl/libnet
	dev-perl/MIME-Lite
	dev-perl/MIME-Base64
	ssl? ( dev-perl/Crypt-SSLeay )
	jabber? ( dev-perl/Net-Jabber )
	ssl? ( dev-perl/IO-Socket-SSL )
	dev-perl/Compress-Zlib
	>=dev-perl/MIME-tools-6.2002"

src_compile() {
	(echo yes) | perl-module_src_compile || perl-module_src_compile || die "compile failed"
	perl-module_src_test || die "test failed"
}
