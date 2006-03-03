# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shoutcast-server-bin/shoutcast-server-bin-1.9.5.ebuild,v 1.5 2006/03/03 14:00:37 blubb Exp $

IUSE=""

inherit eutils

SVER=${PV//./-}
RESTRICT="fetch nostrip"
DESCRIPTION="${PN} is a network streaming server by Nullsoft."
HOMEPAGE="http://www.shoutcast.com/download/license.phtml"
SRC_URI="shoutcast-${SVER}-linux-glibc6.tar.gz"
LICENSE="shoutcast"
SLOT="0"
KEYWORDS="-* amd64 x86"
DEPEND=""

S="${WORKDIR}/shoutcast-${SVER}-linux-glibc6"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	# install executable
	einfo "Installing Executable"
	dodir /opt/shoutcast
	exeinto /opt/shoutcast
	doexe sc_serv

	#install shoutcast init.d script
	doinitd ${FILESDIR}/shoutcast

	# install configuration file
	sed -e "s/LogFile=sc_serv\.log/LogFile=\/dev\/null/" -e "s/W3CLog=sc_w3c\.log/W3CLog=\/dev\/null/" -i sc_serv.conf

	# sets screen logging and real time output off since we're running this as a deamon
	sed -e "s:RealTime=1:RealTime=0:" -e "s:ScreenLog=1:ScreenLog=0:" -i sc_serv.conf

	# fixes up messed up example as directories for on demand 
	# streaming need a trailing slash at the end of directories
	sed -e "s:; Default is ./content:; Default is ./content/:" -i sc_serv.conf

	# sets up a default content directory for on demand streaming
	dodir /opt/shoutcast/content
	sed -e "s:; ContentDir=./content:ContentDir=/opt/shoutcast/content/:" -i sc_serv.conf

	#install the configuration file
	dodir /etc/shoutcast
	insinto /etc/shoutcast
	doins sc_serv.conf

	# install documentation
	dodoc README
	cp sc_serv.conf sc_serv.conf.example
	dodoc sc_serv.conf.example

	# Fix permissions - security bug #63551
	fperms 600 /etc/shoutcast/sc_serv.conf
}

pkg_postinst() {
	einfo
	einfo "To start shoutcast, use the init.d script by running"
	einfo "/etc/init.d/shoutcast."
	einfo
	einfo "On demand content should be stored in /opt/shoutcast/content"
	einfo "See http://forums.winamp.com/showthread.php?threadid=75736 for"
	einfo "more information on setting up on demand content"
	einfo
	einfo "FAQ's can be found at:"
	einfo "http://forums.winamp.com/showthread.php?threadid=75736 "
	einfo "and can help you with server setup."
	einfo
	einfo "An Gentoo Linux shoutcast guide can be found at "
	einfo "http://www.gentoo.org/doc/en/shoutcast-config.xml"
	einfo
}
