# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/netscape-flash/netscape-flash-6.0.81.ebuild,v 1.3 2004/06/25 01:07:26 agriffis Exp $

inherit nsplugins

#until a new package of gflashplayer is released
OLD_V="6.0.69"

IUSE="gtk"

S=${WORKDIR}/install_flash_player_6_linux
DESCRIPTION="Macromedia Shockwave Flash Player"
SRC_URI="mirror://macromedia/${P}.tar.gz
	gtk? mirror://macromedia/gflashplayer-${OLD_V}.tar.gz"
HOMEPAGE="http://www.macromedia.com/"

SLOT="0"
KEYWORDS="x86 amd64 -ppc -sparc"
LICENSE="Macromedia"

RDEPEND="!net-www/gplflash"

DEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs )
	!amd64? ( gtk? ( >=sys-libs/lib-compat-1.1
		=x11-libs/gtk+-1.2* )
		)"

RESTRICT=nostrip

src_install() {
	exeinto /opt/netscape/plugins
	doexe libflashplayer.so

	insinto /opt/netscape/plugins
	doins flashplayer.xpt

	inst_plugin /opt/netscape/plugins/libflashplayer.so
	inst_plugin /opt/netscape/plugins/flashplayer.xpt

	dodoc readme.txt
	dohtml ReadMe.htm

	# Optionally install the standalone GTK flash player
	if [ "${ARCH}" != "amd64" ]; then
		if use gtk
		then
			cd ${S}_sa
			docinto gflashplayer
			dodoc readme.txt
			dohtml ReadMe.htm
			dobin gflashplayer flashplayer-installer
		fi
	fi
}
