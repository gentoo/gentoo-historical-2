# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/siege/siege-2.58.ebuild,v 1.5 2004/06/24 21:29:04 agriffis Exp $

DESCRIPTION="An http regression testing and benchmarking utility"
HOMEPAGE="http://www.joedog.org/siege/"
SRC_URI="ftp://sid.joedog.org/pub/siege/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="ssl"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )"

src_compile() {
	has_version '=dev-libs/openssl-0.9.7*' \
		&& sed -i -e "s:^# include <openssl/e_os.h>::" src/ssl.h
	local myconf
	use ssl && myconf="--with-ssl" || myconf="--with-ssl=off"
	econf ${myconf} || die "econf failed"
	emake || die

}

src_install() {
	# makefile tries to install into $HOME by default... bad monkey!
	dodir /usr/share/doc/${P}

	einstall SIEGERC="${D}/usr/share/doc/${P}/siegerc-example"

	# all non-html docs must be gzip'd
	gzip ${D}/usr/share/doc/${P}/siegerc-example

	dodoc AUTHORS INSTALL KNOWNBUGS NEWS MACHINES README
}
