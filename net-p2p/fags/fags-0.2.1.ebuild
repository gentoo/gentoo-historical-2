# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/fags/fags-0.2.1.ebuild,v 1.2 2002/06/25 11:12:27 bangert Exp $


S=${WORKDIR}/${P}
DESCRIPTION="The Free AudioGalaxy Satellite.  An open source alternative"
HOMEPAGE="http://cljwwqelyxosotul.sess.tty0.org/page/fags"
SRC_URI="http://cljwwqelyxosotul.sess.tty0.org/files/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

DEPEND="oggvorbis? ( media-libs/libvorbis )
	media-sound/mp3info"

src_compile() {

	local myconf

	use oggvorbis || myconf="${myconf} --disable-vorbis"

	econf ${myconf} || die
	emake || die
}

src_install() {

	einstall || die
	dodoc AUTHORS README COPYING INSTALL ChangeLog NEWS TODO

}

pkg_postinst() {

	einfo "Run this once, then change the settings in ~/.fags/config"
	einfo "Then run it again."

}
