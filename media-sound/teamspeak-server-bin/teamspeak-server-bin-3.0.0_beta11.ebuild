# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/teamspeak-server-bin/teamspeak-server-bin-3.0.0_beta11.ebuild,v 1.1 2009/12/29 22:55:37 trapni Exp $

# NOTE: The comments in this file are for instruction and documentation.
# They're not meant to appear with your final, production ebuild.  Please
# remember to remove them before submitting or committing your ebuild.  That
# doesn't mean you can't add your own comments though.

# The 'Header' on the third line should just be left alone.  When your ebuild
# will be committed to cvs, the details on that line will be automatically
# generated to contain the correct data.

EAPI=1

inherit eutils

DESCRIPTION="TeamSpeak Server - Voice Communication Software"
HOMEPAGE="http://teamspeak.com/"
LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"

SRC_URI="
	amd64? ( http://ftp.4players.de/pub/hosted/ts3/releases/beta-11/teamspeak3-server_linux-amd64-${PV/_/-}.tar.gz )
	x86? ( http://ftp.4players.de/pub/hosted/ts3/releases/beta-11/teamspeak3-server_linux-x86-${PV/_/-}.tar.gz )
"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	enewuser teamspeak3
}

src_install() {
	local dest="${D}/opt/teamspeak3-server"

	mkdir -p "${dest}"
	cp -R "${WORKDIR}/teamspeak3-server_linux-amd64/"* "${dest}/" || die

	mv "${dest}/ts3server_linux_"* "${dest}/ts3server-bin" || die

	exeinto /usr/sbin || die
	doexe "${FILESDIR}/ts3server" || die

	# runtime FS layout ...
	insinto /etc/teamspeak3-server
	doins "${FILESDIR}/server.conf"
	newinitd "${FILESDIR}/teamspeak3-server.rc" teamspeak3-server

	keepdir /{etc,var/{lib,log,run}}/teamspeak3-server
	fowners teamspeak3 /{etc,var/{lib,log,run}}/teamspeak3-server
	fperms 700 /{etc,var/{lib,log,run}}/teamspeak3-server

	fowners teamspeak3 /opt/teamspeak3-server
	fperms 755 /opt/teamspeak3-server
}
