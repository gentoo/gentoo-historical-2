# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/siege/siege-2.55.ebuild,v 1.7 2003/09/06 22:14:37 msterret Exp $

DESCRIPTION="An http regression testing and benchmarking utility"
SRC_URI="ftp://ftp.armstrong.com/pub/siege/${P}.tar.gz"
HOMEPAGE="http://www.joedog.org/siege/"

SLOT="0"
KEYWORDS="x86 ppc"
LICENSE="GPL-2"
IUSE="ssl"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )"

src_compile() {
	local myconf
	use ssl && myconf="--with-ssl" || myconf="--with-ssl=off"
	econf ${myconf}
	emake || die

}

src_install() {
	# makefile tries to install into $HOME by default... bad monkey!
	dodir /usr/share/doc/${P}

	einstall SIEGERC="${D}/usr/share/doc/${P}/siegerc-example"

	# all non-html docs must be gzip'd
	gzip ${D}/usr/share/doc/${P}/siegerc-example

	dodoc AUTHORS COPYING INSTALL KNOWNBUGS NEWS MACHINES README
}
