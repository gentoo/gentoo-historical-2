# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/netpbm/netpbm-9.12-r4.ebuild,v 1.18 2004/06/25 03:07:32 agriffis Exp $

inherit flag-o-matic gcc

DESCRIPTION="A set of utilities for converting to/from the netpbm (and related) formats"
HOMEPAGE="http://netpbm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 hppa"
IUSE=""

DEPEND=">=media-libs/jpeg-6b
	>=media-libs/tiff-3.5.5
	>=media-libs/libpng-1.2.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	# 13/May/2003: Fix for bug #14392  by Jason Wever <weeve@gentoo.org>
	# start fix
	if [ ${ARCH} = "sparc" ]
	then
		filter-flags -O3 -O2 -O
	fi
	# end fix
	sed -e "s:-O3:${CFLAGS}:" ${FILESDIR}/${PV}/Makefile.config >Makefile.config
}

src_compile() {
	emake -j1 CC="$(gcc-getCC)" CXX="$(gcc-getCXX)" || die "emake failed"
}

src_install() {
	make INSTALL_PREFIX="${D}/usr/" install || die "Install failed"

	# fix broken symlinks
	dosym /usr/bin/gemtopnm /usr/bin/gemtopbm
	dosym /usr/bin/pnmtoplainpnm /usr/bin/pnmnoraw

	insinto /usr/include
	doins pnm/{pam,pnm}.h ppm/{ppm,pgm,pbm}.h
	doins pbmplus.h shhopt/shhopt.h
	dodoc COPYRIGHT.PATENT GPL_LICENSE.txt HISTORY \
		Netpbm.programming README* netpbm.lsm
}
