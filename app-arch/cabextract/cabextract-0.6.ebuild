# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cabextract/cabextract-0.6.ebuild,v 1.14 2004/05/28 12:13:01 vapier Exp $

DESCRIPTION="Extracts files from Microsoft .cab files"
HOMEPAGE="http://www.kyz.uklinux.net/cabextract.php3"
SRC_URI="http://www.kyz.uklinux.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 ppc64"
IUSE=""

DEPEND="virtual/glibc"

src_install() {
	dobin cabextract || die
	doman cabextract.1
	dodoc NEWS README TODO AUTHORS
}
