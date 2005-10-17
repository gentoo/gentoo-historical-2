# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-alarm/xmms-alarm-0.3.7.ebuild,v 1.1 2005/10/17 02:51:40 metalgod Exp $

DESCRIPTION="An alarm plugin for XMMS"
HOMEPAGE="http://www.snika.uklinux.net/index.php?show=xmms-alarm"
SRC_URI="http://www.snika.uklinux.net/xmms-alarm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND="=x11-libs/gtk+-1.2*
	media-sound/xmms"

IUSE=""

src_compile() {
	econf \
		--program-suffix=-dev \
		--program-transform-name=libalarm-dev \
		|| die "conf failed"
	emake || die "build failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog README NEWS
}
