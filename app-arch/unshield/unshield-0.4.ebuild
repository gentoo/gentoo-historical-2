# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unshield/unshield-0.4.ebuild,v 1.9 2006/07/13 20:48:48 liquidx Exp $

inherit eutils

DESCRIPTION="InstallShield CAB file extractor."
HOMEPAGE="http://synce.sourceforge.net/synce/unshield.php"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

DEPEND=">=sys-libs/zlib-1.1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/unshield-gcc-3.4.patch
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}
