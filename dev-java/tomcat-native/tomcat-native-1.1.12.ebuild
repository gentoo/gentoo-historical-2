# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/tomcat-native/tomcat-native-1.1.12.ebuild,v 1.2 2008/02/18 02:38:42 wltjr Exp $

inherit eutils java-pkg-2

DESCRIPTION="Native APR library for Tomcat"

SLOT="0"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/native/${P}-src.tar.gz"
HOMEPAGE="http://tomcat.apache.org/"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"

RDEPEND="=dev-libs/apr-1*
	dev-libs/openssl
	>=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	${RDEPEND}"

S=${WORKDIR}/${P}-src

src_compile(){
	cd "${S}"/jni/native
	econf --with-apr=/usr/bin/apr-1-config  \
		--with-ssl=/usr || die "Could not configure native sources"
	emake || die "Could not build libtcnative-1.so"
}

src_install() {
	cd "${S}"/jni/native
	emake DESTDIR="${D}" install || die "Could not install libtcnative-1.so"
}

pkg_postinst() {
	elog
	elog " APR should be available with Tomcat, for more information"
	elog " please see http://tomcat.apache.org/tomcat-6.0-doc/apr.html"
	elog
	elog " Please report any bugs to http://bugs.gentoo.org/"
	elog
}
