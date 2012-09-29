# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gptfdisk/gptfdisk-0.8.5.ebuild,v 1.2 2012/09/29 16:44:31 armin76 Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="gdisk - GPT partition table manipulator for Linux"
HOMEPAGE="http://www.rodsbooks.com/gdisk/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/icu
	dev-libs/popt
	>=sys-libs/ncurses-5.7-r7"
DEPEND="${RDEPEND}"

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	local app
	for app in gdisk sgdisk cgdisk fixparts; do
		dosbin ${app}
		doman ${app}.8
	done
	dodoc NEWS README
}
