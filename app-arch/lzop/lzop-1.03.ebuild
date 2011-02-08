# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/lzop/lzop-1.03.ebuild,v 1.2 2011/02/08 20:31:01 tomka Exp $

EAPI=2

DESCRIPTION="Utility for fast (even real-time) compression/decompression"
HOMEPAGE="http://www.lzop.org/"
SRC_URI="http://www.lzop.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/lzo-2"
DEPEND="${RDEPEND}"

src_test() {
	einfo "compressing config.status to test"
	src/lzop config.status || die 'compression failed'
	ls -la config.status{,.lzo}
	src/lzop -t config.status.lzo || die 'lzo test failed'
	src/lzop -dc config.status.lzo | diff config.status - || die 'decompression generated differences from original'
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS
	dodoc doc/lzop.{txt,ps}
	dohtml doc/*.html
}
