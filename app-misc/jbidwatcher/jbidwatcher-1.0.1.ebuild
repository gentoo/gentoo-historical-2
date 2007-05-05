# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/jbidwatcher/jbidwatcher-1.0.1.ebuild,v 1.1 2007/05/05 10:15:32 ali_bush Exp $

inherit java-pkg-2 java-ant-2 eutils

MY_PV=${PV/_/} # get rid of underscore between version and pre
MY_PN="JBidWatcher"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Java-based eBay bidding, sniping and tracking tool"
HOMEPAGE="http://www.jbidwatcher.com/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="doc"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Fix bad build.xml (used to be the sed)
	epatch "${FILESDIR}/${PN}-1.0-build_xml.patch"
	epatch "${FILESDIR}/${PN}-0.9.8-javadoc.patch"
	# jdictrayapi and tritonus are here
	#rm -fr org
	# apple stuff and pat stuff
	#rm -rf com
	#rm -fr javazoom
}

src_compile() {
	eant jar $(use_doc)
}

src_install() {
	java-pkg_newjar ${MY_PN}-${MY_PV}.jar ${PN}.jar

	use doc && java-pkg_dohtml -r docs/api

	java-pkg_dolauncher ${PN} --jar ${PN}.jar
	newicon jbidwatch64.jpg ${PN}.jpg
	make_desktop_entry ${PN} ${MY_PN}
}
