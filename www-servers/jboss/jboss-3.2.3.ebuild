# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/jboss/jboss-3.2.3.ebuild,v 1.8 2007/04/28 17:28:43 swegener Exp $

inherit eutils java-pkg

MY_P="${P}-src"

DESCRIPTION="The JBoss/Server is the leading Open Source, standards-compliant, J2EE based application server implemented in 100% Pure Java."
SRC_URI="mirror://sourceforge/jboss/${MY_P}.tar.bz2"
RESTRICT="nomirror"
HOMEPAGE="http://www.jboss.org"
LICENSE="LGPL-2"
IUSE=""
SLOT="0"
KEYWORDS="x86 ppc ~amd64"

RDEPEND=">=virtual/jdk-1.3"
DEPEND="${RDEPEND}
	app-text/sgml-common
	dev-java/ant"

# This was once an installation into /opt.  It has been changed to
# /usr/share/jboss so it conforms to the Linux Filesytem Hierarchy
# Standards.

INSTALL_DIR=/usr/share/jboss
# INSTALL_DIR=/opt/${P}

S=${WORKDIR}/${MY_P}

src_compile() {
	[ -n ${JDK_HOME} ] || JDK_HOME=$(java-config --jdk-home)
	export JAVA_HOME=${JDK_HOME}
	cd build
	# For more options on the "groups" parameter, see build/build.xml
	sh build.sh -Dgroups=all || die
#	sh build.sh || die
}

src_install() {
	dodir ${INSTALL_DIR}
	dodir ${INSTALL_DIR}/bin

	for f in run.sh shutdown.sh run.jar shutdown.jar; do
		cp build/output/${P}/bin/${f} ${D}/${INSTALL_DIR}/bin
	done

	doinitd ${FILESDIR}/${PV}/init.d/jboss
	dodir /etc/conf.d
	cp ${FILESDIR}/${PV}/conf.d/jboss ${D}/etc/conf.d
	dodir /etc/env.d
	cp ${FILESDIR}/${PV}/env.d/50jboss ${D}/etc/env.d
	sed "s#@JBOSSPREFIX@#${INSTALL_DIR}#" \
		<${FILESDIR}/${PV}/env.d/50jboss \
		>${D}/etc/env.d/50jboss
	echo 'CONFIG_PROTECT="/var/lib/jboss"' >>${D}/etc/env.d/50jboss

	for i in build/output/${P}/server \
		build/output/${P}/lib \
		build/output/${P}/client
	do
		cp -a $i ${D}/${INSTALL_DIR}/
	done

	dodir /var/lib/jboss
	mv ${D}/${INSTALL_DIR}/server/{all,default,minimal} ${D}/var/lib/jboss
	for server in all default minimal; do
		cp ${FILESDIR}/${PV}/log4j.xml ${D}/var/lib/jboss/${server}/conf/
	done
	rmdir ${D}/${INSTALL_DIR}/server

	local classpath
	classpath=$(find ${D}/${INSTALL_DIR}/client -type f -name \*.jar |sed "s,${D}/,,g")
	classpath=$(echo ${classpath})
	cat >${D}/usr/share/jboss/package.env <<EOF
DESCRIPTION=Client side libraries for JBoss
CLASSPATH=${classpath// /:}
EOF

	dodoc server/src/docs/LICENSE.txt ${FILESDIR}/README.gentoo
	cp -r build/output/${P}/docs/examples ${D}/usr/share/doc/${PF}/

	insinto /usr/share/sgml/jboss/
	doins build/output/${P}/docs/dtd/*
	doins ${FILESDIR}/${PV}/catalog

	keepdir /var/log/jboss
	keepdir /var/tmp/jboss
	keepdir /var/cache/jboss
}

without_error() {
	$@ &>/dev/null || true
}

pkg_postinst() {
	without_error userdel jboss
	without_error groupdel jboss
	if ! enewgroup jboss || ! enewuser jboss -1 /bin/sh /dev/null jboss; then
		die "Unable to add jboss user and jboss group."
	fi

	for dir in /var/log/jboss /var/tmp/jboss /var/cache/jboss /var/lib/jboss; do
		chown -R jboss:jboss ${dir}
		chmod o-rwx ${dir}
	done

	install-catalog --add /etc/sgml/jboss.cat /usr/share/sgml/jboss/catalog
}

pkg_prerm() {
	if [ -e /etc/sgml/jboss.cat ]; then
		install-catalog --remove /etc/sgml/jboss.cat /usr/share/sgml/jboss/catalog
	fi
}

