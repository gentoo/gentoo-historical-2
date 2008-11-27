# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/spindown/spindown-0.2.2.ebuild,v 1.2 2008/11/27 14:25:25 wschlich Exp $

inherit eutils

DESCRIPTION="Spindown is a daemon that can spin down idle disks"
HOMEPAGE="http://code.google.com/p/spindown"
SRC_URI="http://spindown.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libc"
RDEPEND="${DEPEND}
	sys-apps/sg3_utils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-CFLAGS.patch
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	insinto /etc
	newins spindown.conf.example spindown.conf
	newinitd "${FILESDIR}"/spindownd.initd spindownd
	newconfd "${FILESDIR}"/spindownd.confd spindownd
	dosbin spindownd
	dodoc CHANGELOG README TODO spindown.conf.example
}

pkg_postinst() {
	elog "Before starting spindownd the first time"
	elog "you should modify /etc/spindown.conf"
	elog
	elog "To start spindownd by default"
	elog "you should add it to the default runlevel:"
	elog "  rc-update add spindownd default"
}
