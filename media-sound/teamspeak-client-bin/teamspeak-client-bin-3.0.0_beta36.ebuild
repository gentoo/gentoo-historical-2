# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/teamspeak-client-bin/teamspeak-client-bin-3.0.0_beta36.ebuild,v 1.3 2012/02/05 06:31:11 vapier Exp $

# NOTE: The comments in this file are for instruction and documentation.
# They're not meant to appear with your final, production ebuild.  Please
# remember to remove them before submitting or committing your ebuild.  That
# doesn't mean you can't add your own comments though.

# The 'Header' on the third line should just be left alone.  When your ebuild
# will be committed to cvs, the details on that line will be automatically
# generated to contain the correct data.

EAPI=1

inherit eutils unpacker

DESCRIPTION="TeamSpeak Client - Voice Communication Software"
HOMEPAGE="http://teamspeak.com/"
LICENSE="teamspeak3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="strip"
PROPERTIES="interactive"

SRC_URI="
	amd64? ( http://ftp.4players.de/pub/hosted/ts3/releases/beta-${PV/3.0.0_beta/}/TeamSpeak3-Client-linux_amd64-${PV/_/-}.run )
	x86? ( http://ftp.4players.de/pub/hosted/ts3/releases/beta-${PV/3.0.0_beta/}/TeamSpeak3-Client-linux_x86-${PV/_/-}.run )
"

DEPEND=""
RDEPEND="${DEPEND}
		x11-libs/qt-gui:4
		>=x11-libs/libXinerama-1.0.2"

src_install() {
	local dest="${D}/opt/teamspeak3-client"

	mkdir -p "${dest}"

	# remove the qt-libraries as they just cause trouble with the system's Qt
	# see bug #328807
	rm "${WORKDIR}"/libQt* || die

	cp -R "${WORKDIR}/"* "${dest}/" || die

	exeinto /usr/bin
	doexe "${FILESDIR}/teamspeak3"

	mv "${dest}/ts3client_linux_"* "${dest}/ts3client"

	make_desktop_entry teamspeak3 TeamSpeak3 \
		"/opt/teamspeak3-client/gfx/default/24x24_connect.png" \
		Network
}
