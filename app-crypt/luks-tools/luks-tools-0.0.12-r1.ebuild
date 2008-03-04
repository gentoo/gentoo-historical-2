# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/luks-tools/luks-tools-0.0.12-r1.ebuild,v 1.2 2008/03/04 21:13:51 hanno Exp $

inherit eutils

DESCRIPTION="GUI frontend for dm-crypt/luks."
HOMEPAGE="http://www.flyn.org/projects/luks-tools/"
SRC_URI="http://www.flyn.org/projects/luks-tools/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-fs/cryptsetup
	>=dev-python/pygtk-2.8.0
	>=sys-apps/hal-0.5"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/luks-tools-0.0.12-pam-config.patch"
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS FAQ NEWS README TODO
}
