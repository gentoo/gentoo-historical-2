# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/kexec-tools/kexec-tools-1.101-r2.ebuild,v 1.1 2006/03/04 20:16:02 genstef Exp $

inherit eutils

DESCRIPTION="Load another kernel from the currently executing Linux kernel"
HOMEPAGE="http://www.xmission.com/~ebiederm/files/kexec/"
SRC_URI="http://www.xmission.com/~ebiederm/files/kexec/${P}.tar.gz
	http://lse.sourceforge.net/kdump/patches/1.101-kdump7/kexec-tools-1.101-kdump7.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zlib"
DEPEND="zlib? ( sys-libs/zlib )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${DISTDIR}"/kexec-tools-1.101-kdump7.patch
	epatch "${FILESDIR}"/${P}-LDFLAGS.patch
	epatch "${FILESDIR}"/${P}-ppc64.patch
}

src_compile() {
	econf $(use_with zlib) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	doman kexec/kexec.8
	dodoc News AUTHORS TODO

	newinitd "${FILESDIR}"/kexec.init kexec
	newconfd "${FILESDIR}"/kexec.conf kexec
}
