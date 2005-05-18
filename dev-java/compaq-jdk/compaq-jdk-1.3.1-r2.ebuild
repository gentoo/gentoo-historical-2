# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/compaq-jdk/compaq-jdk-1.3.1-r2.ebuild,v 1.6 2005/05/18 15:42:10 axxo Exp $

inherit java fixheadtails

S=${WORKDIR}/jdk${PV}
SRC_URI="ftp://ftp.compaq.com/pub/products/linuxdevtools/latest/jdk-${PV}-1-linux-alpha.rpm"
HOMEPAGE="ftp://ftp.compaq.com/pub/products/linuxdevtools/latest/"
DESCRIPTION="Compaq Java Development Kit ${PV} for Alpha/Linux/GNU"
DEPEND="virtual/libc
	app-arch/rpm2targz
	dev-libs/libots
	dev-libs/libcpml
	>=dev-java/java-config-0.2.5
	>=x11-libs/openmotif-2.1.30-r1
	doc? ( ~dev-java/java-sdk-docs-${PV} )"
RDEPEND="$DEPEND"
PROVIDE="virtual/jre
	virtual/jdk"
LICENSE="compaq-sdla"
SLOT="1.3"
KEYWORDS="-* alpha"
IUSE="doc"

src_unpack() {
	rpm2targz ${DISTDIR}/jdk-${PV}-1-linux-alpha.rpm
	tar xzf jdk-${PV}-1-linux-alpha.tar.gz >& /dev/null
	mv usr/java/jdk${PV} .
	ht_fix_file jdk${PV}/bin/.java_wrapper jdk${PV}/jre/bin/.java_wrapper
}

src_install () {
	dodir /opt/${P}
	cp -a bin include include-old jre lib ${D}/opt/${P}

	dodoc COPYRIGHT README LICENSE
	dohtml README.html
	doman man/man1/*.1

	dodir /opt/${P}/share
	cp -a demo src.jar ${D}/opt/${P}/share

	set_java_env ${FILESDIR}/${VMHANDLE} || die
}
