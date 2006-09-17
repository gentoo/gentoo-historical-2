# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_jk/mod_jk-1.2.18.ebuild,v 1.1 2006/09/17 01:24:35 wltjr Exp $

inherit apache-module java-pkg-opt-2

MY_P="tomcat-connectors-${PV}-src"

DESCRIPTION="JK module for connecting Tomcat and Apache using the ajp13 protocol"
HOMEPAGE="http://tomcat.apache.org/connectors-doc"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/jk/source/jk-${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apache2 java"

DEPEND="java? >=virtual/jdk-1.4"
S="${WORKDIR}/${MY_P}/native"

APACHE1_MOD_FILE="${S}/apache-1.3/mod_jk.so"
APACHE1_MOD_CONF="88_${PN}"
APACHE1_MOD_DEFINE="JK"

APACHE2_MOD_FILE="${S}/apache-2.0/mod_jk.so"
APACHE2_MOD_CONF="88_${PN}"
APACHE2_MOD_DEFINE="JK"

DOCFILES="CHANGES.txt README"

need_apache

src_compile() {
	local apxs
	local java_args
	use apache2 && apxs="${APXS2}"
	use apache2 || apxs="${APXS1}"
	use java && java_args="--with-java-home=${JAVA_HOME} \
				--with-java-platform=2 --enable-jni"

	econf \
		--with-apxs=${apxs} \
		--with-apr-config=/usr/bin/apr-config \
		${java_args} \
		|| die "econf failed"
	emake LIBTOOL="/bin/sh $(pwd)/libtool --silent" || die "make failed"
}

src_install() {
	# install the workers.properties file
	insinto ${APACHE_CONFDIR}
	doins ${FILESDIR}/jk-workers.properties

	# if using java install the jni stuff
	if use java; then
		insinto ${APACHE_MODULESDIR}
		doins ${S}/jni/jk_jnicb.so
	fi

	# call the nifty default src_install :-)
	apache-module_src_install
}

pkg_postinst() {
	einfo "Tomcat is not a dependency of mod_jk any longer, if you intend"
	einfo "to use it with Tomcat, you have to merge www-servers/tomcat on"
	einfo "your own."
}
