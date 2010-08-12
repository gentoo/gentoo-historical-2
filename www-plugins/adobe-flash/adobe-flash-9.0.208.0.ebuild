# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-9.0.208.0.ebuild,v 1.3 2010/08/12 02:27:32 phajdan.jr Exp $

inherit nsplugins

DESCRIPTION="Adobe Flash Player"
SRC_URI="http://download.macromedia.com/pub/flashplayer/installers/current/9/install_flash_player_9.tar.gz"
HOMEPAGE="http://www.adobe.com/go/kb406791"
IUSE=""
SLOT="0"

KEYWORDS="-* amd64 x86"
LICENSE="AdobeFlash-9.0.31.0"
RESTRICT="strip mirror"

S=${WORKDIR}

RDEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs
			app-emulation/emul-linux-x86-gtklibs
			app-emulation/emul-linux-x86-soundlibs
			 app-emulation/emul-linux-x86-xlibs )
	x86? ( x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXt
		=x11-libs/gtk+-2*
		media-libs/freetype
		media-libs/fontconfig )
	|| ( media-fonts/liberation-fonts media-fonts/corefonts )"

# Where should this all go? (Bug #328639)
INSTALL_BASE="opt/Adobe/flash-player"

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	# Please keep this in future versions
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
	has_multilib_profile && ABI="x86"
}

src_install() {
	cd "${S}/install_flash_player_9_linux/"
	exeinto /${INSTALL_BASE}
	doexe libflashplayer.so
	inst_plugin /${INSTALL_BASE}/libflashplayer.so
}

pkg_postinst() {
	ewarn "Flash player is closed-source, with a long history of security"
	ewarn "issues.  Please consider only running flash applets you know to"
	ewarn "be safe."

	if has_version 'www-client/mozilla-firefox'; then
		elog "The firefox 'flashblock' extension may help:"
		elog "  https://addons.mozilla.org/en-US/firefox/addon/433"
	fi
}
