# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/netscape-flash/netscape-flash-9.0.48.0-r1.ebuild,v 1.1 2007/07/19 16:48:16 lack Exp $

inherit nsplugins rpm

DESCRIPTION="Adobe Flash Player"
SRC_URI="http://fpdownload.macromedia.com/get/flashplayer/current/flash-plugin-${PV}-release.i386.rpm"
HOMEPAGE="http://www.adobe.com/"
IUSE=""
SLOT="0"

KEYWORDS="-* amd64 x86"
LICENSE="AdobeFlash-9.0.31.0"
RESTRICT="strip mirror"

S=${WORKDIR}

DEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs
			app-emulation/emul-linux-x86-gtklibs
			app-emulation/emul-linux-x86-soundlibs
			 app-emulation/emul-linux-x86-xlibs )
	x86? ( x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXt
		=x11-libs/gtk+-2*
		media-libs/freetype
		media-libs/fontconfig )"

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	# Please keep this in future versions
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
	has_multilib_profile && ABI="x86"
}

src_install() {
	cd ${S}/usr/lib/flash-plugin
	exeinto /opt/netscape/plugins
	doexe libflashplayer.so
	inst_plugin /opt/netscape/plugins/libflashplayer.so

	dodoc README
	cd ${S}/usr/share/doc/flash-plugin-${PV}/
	dodoc readme.txt
}
