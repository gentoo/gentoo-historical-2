# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unarj/unarj-2.63a-r2.ebuild,v 1.11 2005/11/29 03:00:54 vapier Exp $

inherit eutils

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://ibiblio.org/pub/Linux/utils/compress/"
SRC_URI="http://ibiblio.org/pub/Linux/utils/compress/${P}.tar.gz"

LICENSE="arj"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ppc ppc64 sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i "/^CFLAGS/s:-O2:${CFLAGS}:" ${S}/Makefile
	epatch ${FILESDIR}/unarj-2.65-CAN-2004-0947.patch
	epatch ${FILESDIR}/unarj-2.65-sanitation.patch
}

src_compile() {
	emake || die
}

src_install() {
	dobin unarj || die
	dodoc unarj.txt technote.txt readme.txt
}
