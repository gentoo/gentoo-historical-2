# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/jmol/jmol-11.0.3-r1.ebuild,v 1.2 2007/06/22 22:43:14 je_fro Exp $

inherit eutils webapp java-pkg-2 java-ant-2

DESCRIPTION="Jmol is a java molecular viever for 3-D chemical structures."
SRC_URI="mirror://sourceforge/${PN}/${P}-full.tar.gz"
HOMEPAGE="http://jmol.sourceforge.net/"
KEYWORDS="~x86"
LICENSE="LGPL-2.1"

IUSE="client-only vhosts"

WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

COMMON_DEP="dev-java/commons-cli
	dev-java/itext
	sci-libs/jmol-acme
	sci-libs/vecmath-objectclub"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	vhosts? ( app-admin/webapp-config )
	${COMMON_DEP}"

pkg_setup() {

	if ! use client-only ; then
		webapp_pkg_setup || die "Failed to setup webapp"
	fi

	java-pkg-2_pkg_setup

}

src_unpack() {

	unpack ${A}
	epatch "${FILESDIR}"/${P}-nointl.patch
	epatch "${FILESDIR}"/${P}-manifest.patch

	mkdir "${S}"/selfSignedCertificate || die "Failed to create Cert directory."
	cp "${FILESDIR}"/selfSignedCertificate.store "${S}"/selfSignedCertificate/ \
		|| die "Failed to install Cert file."

	rm -v "${S}"/*.jar "${S}"/plugin-jars/*.jar || die
	cd "${S}/jars"
	rm -v *.jar *.tar.gz || die

	java-pkg_jar-from vecmath-objectclub vecmath-objectclub.jar vecmath1.2-1.14.jar
	java-pkg_jar-from itext iText.jar itext-1.4.5.jar
	java-pkg_jar-from jmol-acme jmol-acme.jar Acme.jar
	java-pkg_jar-from commons-cli-1 commons-cli.jar commons-cli-1.0.jar

	mkdir -p "${S}/build/appjars" || die
}

src_compile() {
	# prevent absorbing dep's classes
	eant -Dlibjars.uptodate=true main
}

src_install() {

	java-pkg_dojar build/Jmol.jar
	dohtml -r  build/doc/* || die "Failed to install html docs."
	dodoc *.txt doc/*license* || die "Failed to install licenses."

	java-pkg_dolauncher ${PN} --main org.openscience.jmol.app.Jmol \
		--java_args "-Xmx512m"

	if ! use client-only ; then
		webapp_src_preinst || die "Failed webapp_src_preinst."
		cmd="cp Jmol.js build/Jmol.jar "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp build/JmolApplet*.jar "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp applet.classes "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp -r build/classes/* "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp -r build/appletjars/* "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp "${FILESDIR}"/caffeine.xyz "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."
		cmd="cp "${FILESDIR}"/index.html "${D}${MY_HTDOCSDIR}"" ; ${cmd} \
		|| die "${cmd} failed."

		webapp_src_install || die "Failed running webapp_src_install"
	fi
}

pkg_postinst() {

	if ! use client-only ; then
		webapp_pkg_postinst || die "webapp_pkg_postinst failed"
	fi

}

pkg_prerm() {

	if ! use client-only ; then
		webapp_pkg_prerm || die "webapp_pkg_prerm failed"
	fi

}
