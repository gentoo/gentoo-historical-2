# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/speex/speex-1.1.11.1.ebuild,v 1.1 2006/01/03 03:31:33 matsuu Exp $

inherit eutils

DESCRIPTION="Speech encoding library"
HOMEPAGE="http://www.speex.org/"
SRC_URI="http://downloads.xiph.org/releases/speex/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="ogg sse"

DEPEND="virtual/libc
	ogg? ( >=media-libs/libogg-1.0 )"

src_compile() {
	# ogg autodetect only
	econf $(use_enable sse) || die
	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README* TODO NEWS
}
