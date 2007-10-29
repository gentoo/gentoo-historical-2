# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_sha512/pam_sha512-0.1.2.ebuild,v 1.3 2007/10/29 20:18:14 cla Exp $

inherit flag-o-matic pam toolchain-funcs

DESCRIPTION="Pam module to allow authentication via sha512 hash'ed passwords."
HOMEPAGE="http://hollowtube.mine.nu/wiki/index.php?n=Projects.PamSha512"
SRC_URI="http://hollowtube.mine.nu/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}
	app-crypt/hashalot"

src_compile() {
	# fix strict aliasing problems, using -fno-strict-aliasing
	append-flags "-fPIC -c -Wall -Wformat-security -fno-strict-aliasing"
	emake CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		CFLAGS="${CFLAGS}" || die "emake failed"
		# CFLAGS="${CFLAGS}" is required
}

src_install() {
	dopammod pam_sha512.so
	dodoc README
	dosbin hashpass
}

pkg_postinst() {
	elog "See /usr/share/doc/${PF}/README.bz2 for configuration info"
	elog ""
}
