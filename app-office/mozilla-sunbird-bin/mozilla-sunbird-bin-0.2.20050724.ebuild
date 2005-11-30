# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/mozilla-sunbird-bin/mozilla-sunbird-bin-0.2.20050724.ebuild,v 1.1 2005/07/27 16:22:40 agriffis Exp $

inherit mozilla-launcher multilib

DESCRIPTION="The Mozilla Sunbird Calendar"
SRC_URI="mirror://gentoo/sunbird-${PV}.en-US.linux-i686.tar.gz"
HOMEPAGE="http://www.mozilla.org/projects/calendar/sunbird.html"
RESTRICT="nostrip"

KEYWORDS="-* ~x86 ~amd64"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"
IUSE=""

DEPEND="virtual/libc"
RDEPEND="virtual/x11
	x86? (
		>=sys-libs/lib-compat-1.0-r2
		>=x11-libs/gtk+-2.2
	)
	amd64? (
		>=app-emulation/emul-linux-x86-baselibs-1.0
		>=app-emulation/emul-linux-x86-gtklibs-1.0
	)
	>=www-client/mozilla-launcher-1.44"

S=${WORKDIR}/sunbird

# This is a binary x86 package => ABI=x86
# Please keep this in future versions
# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
has_multilib_profile && ABI="x86"

src_install() {
	declare MOZILLA_FIVE_HOME=/opt/sunbird

	# Install sunbird in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv ${S} ${D}${MOZILLA_FIVE_HOME}

	# Install initialization file that is normally created by root running
	# sunbird the first time
	insinto ${MOZILLA_FIVE_HOME}/chrome
	newins ${FILESDIR}/app-chrome.manifest-${PV} app-chrome.manifest
	keepdir ${MOZILLA_FIVE_HOME}/extensions		# required to run!

	# Create /usr/bin/sunbird-bin
	install_mozilla_launcher_stub sunbird-bin ${MOZILLA_FIVE_HOME}

	# Install icon and .desktop for menu entry
	insinto /usr/share/pixmaps
	doins ${FILESDIR}/icon/mozillasunbird-bin-icon.png
	insinto /usr/share/applications
	doins ${FILESDIR}/icon/mozillasunbird-bin.desktop
}

pkg_preinst() {
	declare MOZILLA_FIVE_HOME=/opt/sunbird

	# Remove entire installed instance to prevent all kinds of
	# problems... see bug 44772 for example
	rm -rf ${ROOT}${MOZILLA_FIVE_HOME}
}

pkg_postinst() {
	update_mozilla_launcher_symlinks
}

pkg_postrm() {
	update_mozilla_launcher_symlinks
}
