# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-alarm/xmms-alarm-0.3.6.ebuild,v 1.2 2004/06/18 05:57:44 eradicator Exp $

DESCRIPTION="An alarm plugin for XMMS"
HOMEPAGE="http://www.snika.uklinux.net/index.php?show=xmms-alarm"
SRC_URI="http://www.snika.uklinux.net/xmms-alarm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64"

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
	dodoc AUTHORS COPYING ChangeLog INSTALL README NEWS
}
