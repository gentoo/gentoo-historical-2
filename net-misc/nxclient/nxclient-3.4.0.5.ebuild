# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxclient/nxclient-3.4.0.5.ebuild,v 1.3 2009/11/25 13:55:57 maekke Exp $

inherit eutils versionator

MAJOR_PV="$(get_version_component_range 1-3)"
FULL_PV="${MAJOR_PV}-$(get_version_component_range 4)"
DESCRIPTION="X11/VNC/NXServer client (remote desktops over low-bandwidth links)"
HOMEPAGE="http://www.nomachine.com/"
SRC_URI="amd64? ( http://64.34.161.181/download/${MAJOR_PV}/Linux/nxclient-${FULL_PV}.x86_64.tar.gz )
	x86? ( http://64.34.161.181/download/${MAJOR_PV}/Linux/nxclient-${FULL_PV}.i386.tar.gz )"
LICENSE="nomachine"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND="dev-libs/expat
	>=dev-libs/openssl-0.9.8e
	media-libs/audiofile
	|| ( media-libs/jpeg-compat <media-libs/jpeg-7 )
	media-libs/libpng
	media-libs/freetype
	media-libs/fontconfig
	net-print/cups
	x11-libs/libXft
	x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXext
	sys-libs/zlib
	!net-misc/nxclient-2xterminalserver"

S=${WORKDIR}/NX

src_install()
{
	# we install nxclient into /usr/NX, to make sure it doesn't clash
	# with libraries installed for FreeNX

	for x in nxclient nxesd nxkill nxprint nxservice nxssh ; do
		into /usr/NX
		dobin bin/$x
		into /usr
		make_wrapper $x ./$x /usr/NX/bin /usr/NX/lib || die
	done

	dodir /usr/NX/lib
	cp -P lib/libXcompsh.so* lib/libXcomp.so* "${D}"/usr/NX/lib

	dodir /usr/NX/share
	cp -R share "${D}"/usr/NX

	# Add icons/desktop entries (missing in the tarball)
	cd share/icons
	for size in *; do
		dodir /usr/share/icons/hicolor/${size}/apps
		for icon in admin desktop icon wizard; do
			dosym /usr/NX/share/icons/${size}/nxclient-${icon}.png \
				/usr/share/icons/hicolor/${size}/apps
			done
		done
	make_desktop_entry "nxclient" "NX Client" nxclient-icon
	make_desktop_entry "nxclient -admin" "NX Session Administrator" nxclient-admin
	make_desktop_entry "nxclient -wizard" "NX Connection Wizard" nxclient-wizard
}
