# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netkit-fingerd/netkit-fingerd-0.17-r3.ebuild,v 1.2 2010/02/27 18:39:18 solar Exp $

inherit eutils toolchain-funcs

MY_PN="${PN/netkit/bsd}"
MY_PN="${MY_PN/rd/r}"
DESCRIPTION="Netkit - fingerd and finger client"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"
SRC_URI="mirror://debian/pool/main/b/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="xinetd"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^LDFLAGS=$/d' \
		-e '/CFLAGS/s:-O2::' \
		configure
	epatch "${FILESDIR}"/${P}-r2-gentoo.diff
	epatch "${FILESDIR}"/${P}-name-check.patch #80286
}

src_compile() {
	tc-export CC
	if tc-is-cross-compiler; then
		touch MCONFIG
	else
		./configure || die
	fi
	emake CC="${CC}" || die
}

src_install() {
	into /usr
	dobin finger/finger || die
	dosbin fingerd/fingerd || die
	dosym fingerd /usr/sbin/in.fingerd
	doman finger/finger.1 fingerd/fingerd.8
	dosym fingerd.8 /usr/share/man/man8/in.fingerd.8
	dodoc README ChangeLog BUGS

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/fingerd.xinetd fingerd
}
