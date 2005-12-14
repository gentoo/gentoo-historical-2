# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/xorg-x11/xorg-x11-7.0.0_rc3.ebuild,v 1.3 2005/12/14 06:29:06 spyderous Exp $

inherit eutils

DESCRIPTION="An X11 implementation maintained by the X.Org Foundation (meta
package)"
HOMEPAGE="http://xorg.freedesktop.org"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"
IUSE="xprint"

# Collision protect will scream bloody murder if we install over old versions
RDEPEND="!<=x11-base/xorg-x11-6.9"

# Server
RDEPEND="${RDEPEND}
	>=x11-base/xorg-server-0.99.3"

# Common Applications
RDEPEND="${RDEPEND}
	>=x11-apps/setxkbmap-0.99.3
	>=x11-apps/xauth-0.99.3
	>=x11-apps/xhost-0.99.3
	>=x11-apps/xinit-0.99.4
	>=x11-apps/xmodmap-0.99.2
	>=x11-apps/xrandr-0.99.2"

# Common Libraries - move these to eclass eventually
RDEPEND="${RDEPEND}
	>=x11-libs/libSM-0.99.3
	>=x11-libs/libXcomposite-0.2.2.1
	>=x11-libs/libXcursor-1.1.5.1
	>=x11-libs/libXdamage-1.0.2.1
	>=x11-libs/libXfixes-3.0.1.1
	>=x11-libs/libXv-0.99.2
	>=x11-libs/libXxf86dga-0.99.3
	>=x11-libs/libXinerama-0.99.2
	>=x11-libs/libXScrnSaver-0.99.3
	xprint? ( >=x11-libs/libXp-0.99.2 )"

# Some fonts
RDEPEND="${RDEPEND}
	>=media-fonts/font-bh-ttf-0.99.1
	>=media-fonts/font-adobe-utopia-type1-0.99.1
	>=media-fonts/font-bitstream-type1-0.99.1"

DEPEND="${RDEPEND}"

src_install() {
	# Make /usr/X11R6 a symlink to ../usr.
	dodir /usr
	dosym ../usr /usr/X11R6
}

pkg_preinst() {
	# Check for /usr/X11R6 -> /usr symlink
	if [[ -e "/usr/X11R6" ]] &&
		[[ $(readlink "/usr/X11R6") != "../usr" ]]; then
			eerror "/usr/X11R6 isn't a symlink to ../usr. Please delete it."
			ewarn "First, save a list of all the packages installing there:"
			ewarn "		equery belongs /usr/X11R6 > usr-x11r6-packages"
			ewarn "This requires gentoolkit to be installed."
			die "/usr/X11R6 is not a symlink to ../usr."
	fi

	# Filter out ModulePath line since it often holds a now-invalid path
	# Bug #112924
	# For RC3 - filter out RgbPath line since it also seems to break things
	XORGCONF="/etc/X11/xorg.conf"
	if [ -e ${XORGCONF} ]; then
		mkdir -p "${IMAGE}/etc/X11"
		sed "/ModulePath/d" ${XORGCONF}	> ${IMAGE}${XORGCONF}
		sed -i "/RgbPath/d" ${IMAGE}${XORGCONF}
	fi
}

pkg_postinst() {
	# I'm not sure why this was added, but we don't inherit x-modular
	# x-modular_pkg_postinst

	echo
	einfo "Please note that the xcursors are in /usr/share/cursors/${PN}."
	einfo "Any custom cursor sets should be placed in that directory."
	echo
	einfo "If you wish to set system-wide default cursors, please create"
	einfo "/usr/local/share/cursors/${PN}/default/index.theme"
	einfo "with content: \"Inherits=theme_name\" so that future"
	einfo "emerges will not overwrite those settings."
	echo
	einfo "Listening on TCP is disabled by default with startx."
	einfo "To enable it, edit /usr/bin/startx."
	echo

	ewarn "Please read the modular X migration guide at"
	ewarn "http://dev.gentoo.org/~spyderous/xorg-x11/migrating_to_modular_x_howto.txt"
	echo
	einfo "If you encounter any non-configuration issues, please file a bug at"
	einfo "http://bugs.gentoo.org/enter_bug.cgi?product=Gentoo%20Linux"
	einfo "and attach /etc/X11/xorg.conf, /var/log/Xorg.0.log and emerge info"
	echo
	einfo "In the future, you will be able to affect which drivers are installed"
	einfo "with the VIDEO_CARDS and INPUT_DEVICES settings."
	echo

	# (#76985)
	einfo "Visit http://www.gentoo.org/doc/en/index.xml?catid=desktop"
	einfo "for more information on configuring X."
	echo

	# Try to get people to read this, pending #11359
	ebeep 5
	epause 10
}
