# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AxKit/AxKit-1.6.2.ebuild,v 1.14 2005/05/29 16:12:29 corsair Exp $

inherit perl-module

front=${PV%\.*}
back=${PV##*\.}
MY_PV=${PV:0:${#front}}${back}
S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="The Apache AxKit Perl Module"
SRC_URI="http://axkit.org/download/${P}.tar.gz"
HOMEPAGE="http://axkit.org/"
IUSE="gnome"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha ~amd64 ~mips ~ppc ppc64 ~sparc ~x86"

DEPEND=">=www-apache/libapreq-1.0
	>=dev-perl/Compress-Zlib-1.10
	>=dev-perl/Error-0.13
	gnome? ( >=dev-perl/HTTP-GHTTP-1.06 )
	>=dev-perl/libwww-perl-5.64-r1
	>=perl-core/Storable-1.0.7
	>=dev-perl/XML-XPath-1.04
	>=dev-perl/XML-LibXML-1.31
	>=dev-perl/XML-LibXSLT-1.31
	>=dev-perl/XML-Parser-2.31
	>=dev-perl/XML-Sablot-0.50
	>=perl-core/Digest-MD5-2.09
	>=sys-apps/sed-4
	<www-apache/mod_perl-1.99"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -ie "s:0\.31_03:0.31:" Makefile.PL || die "makefile fix failed"
}

src_compile() {
	myconf="--defaultdeps" # eliminate interactivity if no gnome
	perl-module_src_compile
}

src_install() {
	perl-module_src_install

	diropts -o nobody -g nogroup
	dodir /var/cache/axkit
	dodir /home/httpd/htdocs/xslt
	insinto /etc/apache
	doins ${FILESDIR}/httpd.axkit
}
