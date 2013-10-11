# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xxdi/xxdi-1.0.0.ebuild,v 1.1 2013/10/11 12:09:01 hasufell Exp $

EAPI=5

MODULE_VERSION=001

DESCRIPTION="Simple alternative to vim's 'xxd -i' mode"
HOMEPAGE="https://github.com/gregkh/xxdi"
SRC_URI="https://github.com/gregkh/xxdi/archive/v${MODULE_VERSION}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/File-Slurp"

S=${WORKDIR}/${PN}-${MODULE_VERSION}

src_install() {
	dobin xxdi.pl
	dodoc README.md
}
