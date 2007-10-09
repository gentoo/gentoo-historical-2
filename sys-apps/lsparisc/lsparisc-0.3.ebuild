# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lsparisc/lsparisc-0.3.ebuild,v 1.3 2007/10/09 08:28:35 jer Exp $

DESCRIPTION="Like lspci but for PARISC devices"
HOMEPAGE="http://packages.debian.org/unstable/utils/lsparisc"
SRC_URI="http://ftp.debian.org/debian/pool/main/l/${PN}/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* hppa"
IUSE=""

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -e 's|"0.2"|"0.3"|g' -i lsparisc.c
}

src_install() {
	dobin lsparisc || die "Installing lsparisc executable failed."
	doman lsparisc.8 || die "Installing lsparisc man page failed."
	dodoc AUTHORS
}
