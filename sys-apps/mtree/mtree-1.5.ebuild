# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mtree/mtree-1.5.ebuild,v 1.9 2007/12/22 11:50:39 dertobi123 Exp $

inherit eutils

DESCRIPTION="check the permissions of a file system against a spec file"
HOMEPAGE="http://www.netbsd.org/"
SRC_URI="ftp://ftp.netbsd.org/pub/NetBSD/packages/bootstrap-pkgsrc.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ppc s390 x86"
IUSE=""
DEPEND=""

S=${WORKDIR}/bootstrap-pkgsrc

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gcc4.patch"
}

src_compile() {
	cd digest
	chmod +x configure
	econf || die "econf failed"
	emake || die
	cd ../mtree
	chmod +x configure
	econf || die "econf failed"
	emake || die
}

src_install() {
	cd mtree
	dosbin mtree || die
	doman mtree.8
}
