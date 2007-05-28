# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tomcat/tomcat-6.0.13-r1.ebuild,v 1.3 2007/05/28 23:32:54 wltjr Exp $

WANT_ANT_TASKS="ant-trax"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Tomcat Servlet-2.5/JSP-2.1 Container"

MY_P="apache-${P}-src"
SLOT="6"
SRC_URI="mirror://apache/${PN}/${PN}-6/v${PV/_/-}/src/${MY_P}.tar.gz"
HOMEPAGE="http://tomcat.apache.org/"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
LICENSE="Apache-2.0"

IUSE="doc examples source test"

COMMON_DEPEND="=dev-java/eclipse-ecj-3.2*
	>=dev-java/commons-daemon-1.0.1
	>=dev-java/commons-dbcp-1.2.1
	>=dev-java/commons-logging-1.1
	>=dev-java/commons-pool-1.2
	~dev-java/tomcat-servlet-api-${PV}
	examples? ( dev-java/jakarta-jstl )"

RDEPEND=">=virtual/jre-1.5
	dev-java/ant-core
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}
	test? ( dev-java/junit )"

S=${WORKDIR}/${MY_P}

TOMCAT_NAME="${PN}-${SLOT}"
TOMCAT_HOME="/usr/share/${TOMCAT_NAME}"
WEBAPPS_DIR="/var/lib/${TOMCAT_NAME}/webapps"

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup tomcat 265
	enewuser tomcat 265 -1 /dev/null tomcat
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${SLOT}/build-xml.patch"

	cd webapps/examples/WEB-INF/lib/
	rm -v *.jar
}

src_compile(){
	# Fix for bug # 178980
	if use amd64 && [[ "${GENTOO_VM}" = "sun-jdk-1.5" ]] ; then
	        java-pkg_force-compiler ecj-3.2
	fi

	local antflags="build-jasper-jdt deploy -Dbase.path=${T}"
	antflags="${antflags} -Dcompile.debug=false"
	if ! use doc; then
		antflags="${antflags} -Dnobuild.docs=true"
	fi
	antflags="${antflags} -Dant.jar=$(java-pkg_getjar ant-core ant.jar)"
	antflags="${antflags} -Dcommons-daemon.jar=$(java-pkg_getjar commons-daemon commons-daemon.jar)"
	antflags="${antflags} -Djdt.jar=$(java-pkg_getjar eclipse-ecj-3.2 ecj.jar)"
	antflags="${antflags} -Djsp-api.jar=$(java-pkg_getjar tomcat-servlet-api-2.5 jsp-api.jar)"
	antflags="${antflags} -Dservlet-api.jar=$(java-pkg_getjar tomcat-servlet-api-2.5 servlet-api.jar)"
	eant ${antflags}
}

src_install() {
	cd "${S}/output/build/bin"
	rm -f *.bat commons-daemon.jar
	java-pkg_jar-from commons-daemon
	chmod 755 *.sh

	# register jars per bug #171496
	cd "${S}/output/build/lib/"
	for jar in *.jar; do
		java-pkg_dojar ${jar}
	done

	local CATALINA_BASE=/var/lib/${TOMCAT_NAME}/

	# init.d, conf.d
	newinitd ${FILESDIR}/${SLOT}/tomcat.init ${TOMCAT_NAME}
	newconfd ${FILESDIR}/${SLOT}/tomcat.conf ${TOMCAT_NAME}

	# create dir structure
	diropts -m755 -o tomcat -g tomcat
	dodir   /etc/${TOMCAT_NAME}/Catalina/localhost
	chown -R tomcat:tomcat ${D}/etc/${TOMCAT_NAME}
	fperms  750 /etc/${TOMCAT_NAME}
	dodir /usr/share/${TOMCAT_NAME}
	keepdir ${WEBAPPS_DIR}
	chown tomcat:tomcat ${D}/${WEBAPPS_DIR} || die "Failed to change owner off ${1}."
	chmod 750           ${D}/${WEBAPPS_DIR} || die "Failed to change permissions off ${1}."
	keepdir /var/log/${TOMCAT_NAME}/
	keepdir /var/tmp/${TOMCAT_NAME}/
	keepdir /var/run/${TOMCAT_NAME}/
	dodir   ${CATALINA_BASE}
	diropts -m0755

	cd "${S}"
	# fix context's so webapps will be deployed
	sed -i -e 's:Context a:Context docBase="${catalina.home}/webapps/host-manager"  a:' ${S}/webapps/host-manager/META-INF/context.xml
	sed -i -e 's:Context a:Context docBase="${catalina.home}/webapps/manager"  a:' ${S}/webapps/manager/META-INF/context.xml

	# replace the default pw with a random one, see #92281
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	sed -e s:SHUTDOWN:${randpw}: -i conf/server.xml

	# copy over the directories
	chown -R tomcat:tomcat webapps/* conf/*
	cp -pR conf/* ${D}/etc/${TOMCAT_NAME} || die "failed to copy conf"
	cp -pPR output/build/bin ${D}/usr/share/${TOMCAT_NAME} || die "failed to copy"

	# replace catalina.policy with gentoo specific one bug #176701
#	cp ${FILESDIR}/${SLOT}/catalina.policy ${D}/etc/${TOMCAT_NAME} || die "failed to replace catalina.policy"

	cp ${T}/tomcat6-deps/jdt/jasper-jdt.jar ${D}/usr/share/${TOMCAT_NAME}/lib \
		|| die "failed to copy"

	cd "${D}/usr/share/${TOMCAT_NAME}/lib"
	java-pkg_jar-from tomcat-servlet-api-2.5

	cd "${S}"

	# Copy over webapps, some controlled by use flags
	cp -p RELEASE-NOTES webapps/ROOT/RELEASE-NOTES.txt
	cp -pr webapps/ROOT ${D}${CATALINA_BASE}/webapps

	mkdir ${D}${TOMCAT_HOME}/webapps
	chown tomcat:tomcat ${D}${TOMCAT_HOME}/webapps
	cp -pr webapps/host-manager ${D}${TOMCAT_HOME}/webapps
	cp -pr webapps/manager ${D}${TOMCAT_HOME}/webapps

	if use doc; then
		cp -pr output/build/webapps/docs ${D}${CATALINA_BASE}/webapps
	fi
	if use examples; then
		cd output/build/webapps/examples/WEB-INF/lib
		java-pkg_jar-from jakarta-jstl jstl.jar
		java-pkg_jar-from jakarta-jstl standard.jar
		cd "${S}"
		cp -pPr output/build/webapps/examples ${D}${CATALINA_BASE}/webapps
	fi

	# symlink the directories to make CATALINA_BASE possible
	dosym /etc/${TOMCAT_NAME} ${CATALINA_BASE}/conf
	dosym /var/log/${TOMCAT_NAME} ${CATALINA_BASE}/logs
	dosym /var/tmp/${TOMCAT_NAME} ${CATALINA_BASE}/temp
	dosym /var/run/${TOMCAT_NAME} ${CATALINA_BASE}/work

	# link the manager's context to the right position
	dosym ${TOMCAT_HOME}/webapps/host-manager/META-INF/context.xml /etc/${TOMCAT_NAME}/Catalina/localhost/host-manager.xml
	dosym ${TOMCAT_HOME}/webapps/manager/META-INF/context.xml /etc/${TOMCAT_NAME}/Catalina/localhost/manager.xml

	dodoc  ${S}/{RELEASE-NOTES,RUNNING.txt}
	fperms 640 /etc/${TOMCAT_NAME}/tomcat-users.xml
}

pkg_postinst() {
	ewarn "Changing ownership recursively on /etc/${TOMCAT_NAME}"
	# temp fix for bug #176097	
	chown -fR tomcat:tomcat /etc/${TOMCAT_NAME}
	ewarn "Owner ship changed to tomcat:tomcat. Temp hack/fix."

	elog
	elog " This ebuild implements a FHS compliant layout for tomcat"
	elog " Please read http://www.gentoo.org/proj/en/java/tomcat6-guide.xml"
	elog " for more information."
	elog
	ewarn "tomcat-dbcp.jar is not built at this time. Please fetch jar"
	ewarn "from upstream binary if you need it. Gentoo Bug # 144276"
	elog
	elog " Please report any bugs to http://bugs.gentoo.org/"
	elog
}
