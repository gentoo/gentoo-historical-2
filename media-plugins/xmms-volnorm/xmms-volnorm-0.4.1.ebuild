# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-volnorm/xmms-volnorm-0.4.1.ebuild,v 1.8 2005/09/04 09:54:17 flameeyes Exp $

IUSE=""

MY_P=${P/xmms-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Plugin for XMMS, music will be played at the same volume even if it
is recorded at a different volume level"
SRC_URI="http://download.sourceforge.net/volnorm/${MY_P}.tar.gz"
HOMEPAGE="http://volnorm.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="media-sound/xmms"

src_compile() {

	econf --enable-one-plugin-dir || die
	emake || die
}

src_install() {

	einstall \
		libdir=${D}/usr/lib/xmms/Plugins || die

	# Don't know if this is useful, but let's try it anyway
	dodoc AUTHORS BUGS ChangeLog NEWS README RELEASE TODO
}
