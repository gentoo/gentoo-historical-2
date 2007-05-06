# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/wildfire/wildfire-3.2.0_rc2.ebuild,v 1.4 2007/05/06 12:11:45 genone Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Wildfire Jabber server"
HOMEPAGE="http://jivesoftware.org/messenger/"
SRC_URI="mirror://gentoo/${PN//-/_}_src_${PV//./_}.tar.gz"
RESTRICT=""
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"
IUSE="doc"

# For transports
PROVIDE="virtual/jabber-server"

RDEPEND=">=virtual/jre-1.5"
# Doesn't build against Java 1.6 due to changes in JDBC API
DEPEND="net-im/jabber-base
		=virtual/jdk-1.5*
		>=dev-java/ant-1.6
		dev-java/ant-contrib
		>=dev-java/commons-net-1.4"

S=${WORKDIR}/${PN//-/_}_src

pkg_setup() {
	if [ -f /etc/env.d/98wildfire ]; then
		einfo "This is an upgrade"
	else
		ewarn "If this is an upgrade stop right ( CONTROL-C ) and run the command:"
		ewarn "echo 'CONFIG_PROTECT=\"/opt/wildfire/resources/security/\"' > /etc/env.d/98wildfire "
		ewarn "For more info see bug #139708"
		epause 11
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/build.xml-${PV}.bz2 .
	bunzip2 build.xml-${PV}.bz2
	mv build.xml-${PV} build/build.xml
	# TODO should replace jars in build/lib with ones packaged by us -nichoj
}

src_compile() {
	# Jikes doesn't support -source 1.5
	java-pkg_filter-compiler jikes

	eant -f build/build.xml wildfire plugins plugins-dev $(use_doc)
}

src_install() {
	doinitd ${FILESDIR}/init.d/wildfire
	doconfd ${FILESDIR}/conf.d/wildfire

	insinto /opt/wildfire/conf
	newins target/wildfire/conf/wildfire.xml wildfire.xml.sample

	keepdir /opt/wildfire/logs

	insinto /opt/wildfire/lib
	doins target/wildfire/lib/*

	insinto /opt/wildfire/plugins
	doins -r target/wildfire/plugins/*

	insinto /opt/wildfire/resources
	doins -r target/wildfire/resources/*

	if use doc; then
		dohtml -r documentation/docs/*
	fi
	dodoc documentation/dist/*

	#Protect ssl key on upgrade
	dodir /etc/env.d/
	echo 'CONFIG_PROTECT="/opt/wildfire/resources/security/"' > ${D}/etc/env.d/98wildfire
}

pkg_postinst() {
	chown -R jabber:jabber /opt/wildfire

	ewarn "If this is a new install, please edit /opt/wildfire/conf/wildfire.xml.sample"
	ewarn "and save it as /opt/wildfire/conf/wildfire.xml"
	ewarn
	ewarn "The following must be be owned or writable by the jabber user."
	ewarn "/opt/wildfire/conf/wildfire.xml"
}
