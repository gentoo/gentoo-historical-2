# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/ncftp/ncftp-3.1.8-r1.ebuild,v 1.9 2005/08/11 01:17:33 ka0ttic Exp $

inherit eutils

IPV6_P="ncftp-3181-v6-20040728"
DESCRIPTION="An extremely configurable ftp client"
HOMEPAGE="http://www.ncftp.com/"
SRC_URI="ftp://ftp.ncftp.com/ncftp/${P}-src.tar.bz2
	http://www.thrysoee.dk/ncftp/ncftp-${PV}_editcmd.patch
	ipv6? ( ftp://ftp.cc.chuo-u.ac.jp/pub/IPv6/kame/misc/${IPV6_P}.diff.gz )"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc-macos ppc64 s390 sparc x86"
IUSE="ipv6"

DEPEND=">=sys-libs/ncurses-5.2"

src_unpack() {
	unpack ${P}-src.tar.bz2
	cd ${S}
	use ipv6 && epatch ${DISTDIR}/${IPV6_P}.diff.gz
	epatch ${DISTDIR}/ncftp-${PV}_editcmd.patch
}

src_install() {
	dodir /usr/share
	einstall || die

	dodoc README.txt doc/*.txt
	dohtml doc/html/*.html
}
