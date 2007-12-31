# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ncftp/ncftp-3.2.1.ebuild,v 1.8 2007/12/31 01:17:27 vapier Exp $

inherit eutils

IPV6_P="ncftp-321-v6-20070822"
DESCRIPTION="An extremely configurable ftp client"
HOMEPAGE="http://www.ncftp.com/"
SRC_URI="ftp://ftp.ncftp.com/ncftp/${P}-src.tar.bz2
	ipv6? ( ftp://ftp.kame.net/pub/kame/misc/${IPV6_P}.diff.gz )"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="ipv6"

DEPEND=">=sys-libs/ncurses-5.2"

src_unpack() {
	unpack ${A}
	cd "${S}"
	use ipv6 && epatch "${DISTDIR}"/${IPV6_P}.diff.gz
	epatch "${FILESDIR}"/${P}-build.patch #147371
	sed -i \
		-e 's:@SFLAG@::' \
		-e 's:@STRIP@:true:' \
		Makefile.in */Makefile.in || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc README.txt doc/*.txt
	dohtml doc/html/*.html
}
