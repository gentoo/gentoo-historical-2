# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/teamspeak2-client-bin/teamspeak2-client-bin-2.0.32.60-r3.ebuild,v 1.13 2007/02/09 05:17:12 flameeyes Exp $

MY_PV=rc2_2032
DESCRIPTION="The TeamSpeak voice communication tool"
HOMEPAGE="http://www.goteamspeak.com"
SRC_URI="ftp://ftp.freenet.de/pub/4players/teamspeak.org/releases/ts2_client_${MY_PV}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86 amd64"

IUSE="kde imagemagick"

DEPEND=""

RDEPEND="${DEPEND}
	|| ( ( x11-libs/libXt ) virtual/x11 )
	kde? ( >=kde-base/kdelibs-3.1.0 )
	imagemagick? ( media-gfx/imagemagick )
	amd64? ( >=app-emulation/emul-linux-x86-baselibs-1.0
			 >=app-emulation/emul-linux-x86-xlibs-1.0 )"

S="${WORKDIR}/ts2_client_${MY_PV}/setup.data/image"

dir="/opt/teamspeak2-client"

src_compile() {
	if use imagemagick; then
		convert icon.xpm teamspeak.png
	fi
}

src_install() {
	newdoc Readme.txt README
	dodoc client_sdk/SDK_readme.txt
	dohtml manual/*

	into /opt
	dobin ${FILESDIR}/TeamSpeak
	dosed "s:%installdir%:/opt/teamspeak2-client:g" /opt/bin/TeamSpeak

	exeinto ${dir}
	doexe TeamSpeak.bin *.so*

	insinto ${dir}/sounds
	doins sounds/*

	insinto ${dir}/client_sdk
	exeinto ${dir}/client_sdk
	doins client_sdk/*.pas client_sdk/*.dpr
	doexe client_sdk/tsControl client_sdk/*.so*

	#Install the teamspeak icon.
	insinto /usr/share/pixmaps
	if use imagemagick; then
		doins teamspeak.png
	fi
	newins icon.xpm teamspeak.xpm

	if use kde ; then
		# Install a teamspeak.protocol file for kde/konqueror to accept
		# teamspeak:// links
		insinto /usr/share/services/
		doins ${FILESDIR}/teamspeak.protocol
	fi

	# Fix bug #489010
	dosym /usr/share/doc/${PF}/html ${dir}/manual
}

pkg_postinst() {

	echo
	elog
	elog "Please Note: The new Teamspeak2 Release Candidate 2 Client"
	elog "will not be able to connect to any of the *old* rc1 servers."
	elog "if you get 'Bad response' from your server check if your"
	elog "server is running rc2, which is a version >= 2.0.19.16."
	elog "Also note this release supports the new speex codec, "
	elog "so if you got unsupported codec messages, you need this :D"
	echo
	elog "Note: If you just upgraded from a version less than 2.0.32.60-r1,"
	elog "your users' config files will incorrectly point to non-existant"
	elog "soundfiles because they've been moved from their old location."
	elog "You may want to perform the following commands:"
	elog "# mkdir /usr/share/teamspeak2-client"
	elog "# ln -s ${dir}/sounds /usr/share/teamspeak2-client/sounds"
	elog "This way, each user won't have to modify their config files to"
	elog "reflect this move."
	echo
}

