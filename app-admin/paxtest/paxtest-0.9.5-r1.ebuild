# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/paxtest/paxtest-0.9.5-r1.ebuild,v 1.7 2004/06/25 19:28:26 vapier Exp $

inherit eutils

# pax flags are not strip safe.
RESTRICT="nostrip"
FEATURES="-distcc"

DESCRIPTION="PaX regression test suite"
HOMEPAGE="http://pageexec.virtualave.net/"
SRC_URI="http://pageexec.virtualave.net/paxtest-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc
	>=sys-apps/chpax-0.5"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/paxtest-0.9.5.1.diff
	cp Makefile{,.orig}
	cp Makefile{.Gentoo-hardened,}
}

src_compile() {
	emake DESTDIR=${D} BINDIR=${D}/usr/bin RUNDIR=/usr/lib/paxtest || die
}

src_install() {
	emake DESTDIR=${D} BINDIR=/usr/bin RUNDIR=/usr/lib/paxtest install
	for doc in Changelog README ;do
		[ -f "${doc}" ] && dodoc ${doc}
	done
}
