# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libx86/libx86-1.1-r1.ebuild,v 1.1 2008/09/10 05:00:49 pva Exp $

inherit eutils multilib

DESCRIPTION="A hardware-independent library for executing real-mode x86 code"
HOMEPAGE="http://www.codon.org.uk/~mjg59/libx86"
SRC_URI="http://www.codon.org.uk/~mjg59/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix compile failure with linux-headers-2.6.26, bug 235599
	epatch "${FILESDIR}"/${PN}-0.99-ifmask.patch
	sed -i 's:\($(CC) $(CFLAGS)\)\( -o libx86.so.1\):\1 $(LDFLAGS)\2:' Makefile #236888
}

src_compile() {
	local ARGS
	if use amd64; then
		ARGS="BACKEND=x86emu"
	fi
	emake ${ARGS} || die
}

src_install() {
	emake LIBDIR="/usr/$(get_libdir)" DESTDIR="${D}" install || die
}
