# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gamix/gamix-1.99_p14-r2.ebuild,v 1.9 2006/10/28 01:32:03 flameeyes Exp $

MY_P=${P/_p/.p}
S=${WORKDIR}/${MY_P}
DESCRIPTION="GTK ALSA audio mixer"
HOMEPAGE="http://www1.tcnet.ne.jp/fmurata/linux/down"
SRC_URI="http://www1.tcnet.ne.jp/fmurata/linux/down/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc ppc64 -sparc x86"
IUSE="nls"

DEPEND="media-libs/alsa-lib
	>=x11-libs/gtk+-2"
RDEPEND="${DEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf \
		$(use_enable nls) \
		--with-gtk-target=-2.0 || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README README.euc TODO NEWS AUTHORS
}
