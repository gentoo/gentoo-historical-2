# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/mercury-bin/mercury-bin-1709_beta7.ebuild,v 1.1 2005/03/01 01:16:16 humpback Exp $

inherit eutils java-pkg

MY_PV="1709_B7"
DESCRIPTION="MSN and Jabber client in Java"

HOMEPAGE="http://www.mercury.to/"
##Mercury.to dos not provided http or ftp links so i did a mirror
SRC_URI="http://www.gentoo-pt.org/~humpback/${MY_PV}.zip"

LICENSE="mercury"

SLOT="0"

KEYWORDS="~x86"

DEPEND="app-arch/unzip
		>=virtual/jdk-1.4"

RDEPEND=">=virtual/jre-1.4
		dev-java/jmf-bin
		dev-java/jdictrayapi
		=dev-java/jdom-1.0_beta6"

IUSE=""

src_unpack() {
	mkdir ${P}
	cd ${S}
	unpack ${A}
	#Clean the dllStuff.jar from things we dont need
	cd lib
	mkdir dllStuff
	cd dllStuff
	unzip ../dllStuff.jar
	rm -rf ../dllStuff.jar org/jdesktop x10gimli/platform
	cd ${S}
	rm lib/XML.jar
}

src_install() {

	#rebuild the dllStuff.jar
	cd ${S}/lib/dllStuff
	jar cvf ../dllStuff.jar *
	cd ${S}
	rm -rf lib/dllStuff

	#Start installing stuff
	insinto /opt/${PN}/resources
	doins -r resources/*
	java-pkg_dojar lib/*

	insinto /opt/${PN}/
	exeinto /opt/${PN}/
	doins  ${FILESDIR}/icon32.gif
	newexe ${FILESDIR}/mercury.sh mercury

	make_desktop_entry mercury "Mercury MSN client" /opt/${PN}/icon32.gif
	dodir /opt/bin
	dosym /opt/${PN}/mercury /opt/bin/mercury
}
