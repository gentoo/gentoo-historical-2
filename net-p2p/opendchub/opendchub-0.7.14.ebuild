# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/opendchub/opendchub-0.7.14.ebuild,v 1.5 2004/06/25 00:35:41 agriffis Exp $

inherit eutils

DESCRIPTION="hub software for Direct Connect"
HOMEPAGE="http://opendchub.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="perl"

DEPEND="virtual/glibc
	perl? ( dev-lang/perl )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/opendchub-gentoo.patch
}

src_install() {
	einstall || die "install failed"
	if use perl ; then
		exeinto /usr/bin
		doexe ${FILESDIR}/opendchub_setup.sh
		dodir /usr/share/opendchub/scripts
		insinto /usr/share/opendchub/scripts
		doins Samplescripts/*
	fi
	dodoc Documentation/*
}

pkg_postinst() {
	if use perl ; then
		einfo
		einfo "To set up perl scripts for opendchub to use, please run"
		einfo "opendchub_setup.sh as the user you will be using opendchub as."
		einfo
	fi
}
