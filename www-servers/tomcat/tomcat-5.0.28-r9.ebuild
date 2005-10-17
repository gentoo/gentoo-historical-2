# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tomcat/tomcat-5.0.28-r9.ebuild,v 1.1 2005/10/17 21:04:30 betelgeuse Exp $

inherit eutils java-pkg

DESCRIPTION="Apache Servlet-2.4/JSP-2.0 Container"

SLOT="${PV/.*}"
SRC_URI="mirror://apache/jakarta/tomcat-${SLOT}/v${PV}/src/jakarta-${P}-src.tar.gz"
HOMEPAGE="http://jakarta.apache.org/tomcat"
KEYWORDS="~x86 ~amd64 -ppc64 ~sparc"
LICENSE="Apache-2.0"
#only one accepted revision of struts to force upgrading because of slot changes
RDEPEND=">=virtual/jdk-1.4
	=dev-java/commons-beanutils-1.7*
	>=dev-java/commons-collections-3.1
	>=dev-java/commons-daemon-1.0
	>=dev-java/commons-dbcp-1.2.1
	>=dev-java/commons-digester-1.5
	>=dev-java/commons-fileupload-1.0
	=dev-java/commons-httpclient-2*
	>=dev-java/commons-el-1.0
	>=dev-java/commons-launcher-0.9
	>=dev-java/commons-logging-1.0.4
	>=dev-java/commons-modeler-1.1
	>=dev-java/commons-pool-1.2
	~dev-java/jaxen-1.0
	>=dev-java/junit-3.8.1
	dev-java/sun-jmx
	>=dev-java/log4j-1.2.8
	=dev-java/jakarta-regexp-1.3*
	>=dev-java/saxpath-1.0
	~dev-java/servletapi-2.4
	=dev-java/struts-1.1-r4
	dev-java/sun-jaf-bin
	>=dev-java/xerces-2.6.2-r1
	jikes? ( dev-java/jikes )"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	sys-apps/sed
	dev-java/ant"
IUSE="doc examples jikes"

S=${WORKDIR}/jakarta-${P}-src

TOMCAT_HOME="/usr/share/${PN}-${SLOT}"
TOMCAT_NAME="${PN}-${SLOT}"
WEBAPPS_DIR="/var/lib/${TOMCAT_NAME}/default/webapps"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}/build.xml-01.patch
	epatch ${FILESDIR}/${PV}/build.xml-02.patch
	epatch ${FILESDIR}/${PV}/gentoo.diff
	epatch ${FILESDIR}/${PV}/scripts.patch
	use jikes && epatch ${FILESDIR}/${PV}/jikes.diff

	# avoid packed jars :-)
	mkdir -p ${S}/jakarta-tomcat-5/build/common
	cd ${S}/jakarta-tomcat-5/build

	mkdir ./bin && cd ./bin
	java-pkg_jar-from commons-logging commons-logging-api.jar
	java-pkg_jar-from sun-jmx jmxri.jar jmx.jar
	java-pkg_jar-from commons-daemon

	mkdir ../common/endorsed && cd ../common/endorsed
	java-pkg_jar-from xerces-2 xml-apis.jar
	java-pkg_jar-from xerces-2 xercesImpl.jar

	mkdir ../lib && cd ../lib
	java-pkg_jar-from ant-core
	java-pkg_jar-from commons-collections
	java-pkg_jar-from commons-dbcp
	java-pkg_jar-from commons-el
	java-pkg_jar-from commons-pool
	java-pkg_jar-from servletapi-2.4

	mkdir -p ../../server/lib && cd ../../server/lib
	java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	java-pkg_jar-from commons-digester
	java-pkg_jar-from commons-fileupload
	java-pkg_jar-from commons-modeler
	java-pkg_jar-from jakarta-regexp-1.3
}

src_compile(){
	local antflags="-Dbase.path=${T}"
	use jikes && antflags="${antflags} -Dbuild.compiler=jikes"

	antflags="${antflags} -Dactivation.jar=$(java-config -p sun-jaf-bin)"
	antflags="${antflags} -Dcommons-collections.jar=$(java-config -p commons-collections)"
	antflags="${antflags} -Dcommons-daemon.jar=$(java-config -p commons-daemon)"
	antflags="${antflags} -Dcommons-digester.jar=$(java-config -p commons-digester)"
	antflags="${antflags} -Dcommons-dbcp.jar=$(java-config -p commons-dbcp)"
	antflags="${antflags} -Dcommons-el.jar=$(java-config -p commons-el)"
	antflags="${antflags} -Dcommons-httpclient.jar=$(java-config -p commons-httpclient)"
	antflags="${antflags} -Dcommons-pool.jar=$(java-config -p commons-pool)"
	antflags="${antflags} -Dcommons-fileupload.jar=$(java-config -p commons-fileupload)"
	antflags="${antflags} -Dcommons-launcher.jar=$(java-config -p commons-launcher)"
	antflags="${antflags} -Dcommons-modeler.jar=$(java-config -p commons-modeler)"
	antflags="${antflags} -Djunit.jar=$(java-config -p junit)"
	antflags="${antflags} -Dlog4j.jar=$(java-config -p log4j)"
	antflags="${antflags} -Dregexp.jar=$(java-config -p jakarta-regexp-1.3)"
	antflags="${antflags} -Dstruts.jar=$(java-pkg_getjar struts-1.1 struts.jar)"
	antflags="${antflags} -Dcommons-beanutils.jar=$(java-pkg_getjar commons-beanutils-1.7 commons-beanutils.jar)"
	antflags="${antflags} -Dcommons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar)"
	antflags="${antflags} -Dcommons-logging-api.jar=$(java-pkg_getjar commons-logging commons-logging-api.jar)"
	antflags="${antflags} -Djaxen.jar=$(java-pkg_getjar jaxen jaxen-full.jar)"
	antflags="${antflags} -Djmx.jar=$(java-pkg_getjar sun-jmx jmxri.jar)"
	antflags="${antflags} -Djmx-tools.jar=$(java-pkg_getjar sun-jmx jmxtools.jar)"
	antflags="${antflags} -Dsaxpath.jar=$(java-pkg_getjar saxpath saxpath.jar)"
	antflags="${antflags} -DxercesImpl.jar=$(java-pkg_getjar xerces-2 xercesImpl.jar)"
	antflags="${antflags} -Dxml-apis.jar=$(java-pkg_getjar xerces-2 xml-apis.jar)"
	antflags="${antflags} -Dstruts.home=/usr/share/struts-1.1/"

	ant ${antflags} || die "compile failed"

}
src_install() {
	# new user for tomcat
	enewgroup tomcat
	enewuser tomcat -1 -1 /dev/null tomcat

	cd ${S}/jakarta-tomcat-5/build

	# init.d, env.d, conf.d
	newinitd ${FILESDIR}/${PV}/tomcat.init ${TOMCAT_NAME}
	newconfd ${FILESDIR}/${PV}/tomcat.conf-r1 ${TOMCAT_NAME}
	newenvd ${FILESDIR}/${PV}/${PN}.env 21${PN}

	if use jikes; then
		sed -e "\cCATALINA_OPTScaCATALINA_OPTS=\"-Dbuild.compiler.emacs=true\"" \
			-i ${D}/etc/conf.d/${TOMCAT_NAME}
	fi

	# create dir structure
	diropts -m755 -o tomcat -g tomcat
	dodir   /usr/share/${TOMCAT_NAME}
	keepdir /var/log/${TOMCAT_NAME}/default
	keepdir /var/tmp/${TOMCAT_NAME}/default
	keepdir /var/run/${TOMCAT_NAME}/default

	local CATALINA_BASE=/var/lib/${TOMCAT_NAME}/default/
	dodir   ${CATALINA_BASE}
	keepdir ${CATALINA_BASE}/shared/lib
	keepdir ${CATALINA_BASE}/shared/classes

	dodir   /etc/${TOMCAT_NAME}/default
	fperms  440 /etc/${TOMCAT_NAME}/default

	diropts -m0755

	# we don't need dos scripts
	rm -f bin/*.bat

	# copy the manager and admin context's to the right position
	mkdir -p conf/Catalina/localhost
	cp ${S}/jakarta-tomcat-catalina/webapps/admin/admin.xml \
		conf/Catalina/localhost
	cp ${S}/jakarta-tomcat-catalina/webapps/manager/manager.xml \
		conf/Catalina/localhost

	# make the jars available via java-config -p and jar-from, etc
	base=$(pwd)
	libdirs="common/lib server/lib"
	for dir in ${libdirs}
	do
		cd ${dir}

		for jar in *.jar;
		do
			# replace the file with a symlink
			if [ ! -L ${jar} ]; then
				java-pkg_dojar ${jar}
				rm -f ${jar}
				ln -s ${DESTTREE}/share/${TOMCAT_NAME}/lib/${jar} ${jar}
			fi
		done

		cd ${base}
	done

	# replace a packed struts.jar
	cd server/webapps/admin/WEB-INF/lib
	rm -f struts.jar
	java-pkg_jar-from struts-1.1 struts.jar
	cd ${base}

	# replace the default pw with a random one, see #92281
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	sed -e s:SHUTDOWN:${randpw}: -i conf/{server,server-minimal}.xml

	# copy over the directories
	chmod -R 750 conf/*
	chown -R tomcat:tomcat webapps/* conf/*
	cp -pR conf/* ${D}/etc/${TOMCAT_NAME}/default || die "failed to copy conf"
	cp -R bin common server ${D}/usr/share/${TOMCAT_NAME} || die "failed to copy"

	keepdir               ${WEBAPPS_DIR}
	set_webapps_perms     ${D}/${WEBAPPS_DIR}

	# if the useflag is set, copy over the examples
	if use examples; then
		cp -p ../RELEASE-NOTES webapps/ROOT/RELEASE-NOTES.txt
		cp -pr webapps/{tomcat-docs,jsp-examples,servlets-examples,ROOT,webdav} \
			${D}${CATALINA_BASE}/webapps
	fi

	# symlink the directories to make CATALINA_BASE possible
	dosym /etc/${TOMCAT_NAME}/default ${CATALINA_BASE}/conf
	dosym /var/log/${TOMCAT_NAME}/default ${CATALINA_BASE}/logs
	dosym /var/tmp/${TOMCAT_NAME}/default ${CATALINA_BASE}/temp
	dosym /var/run/${TOMCAT_NAME}/default ${CATALINA_BASE}/work

	cp ${FILESDIR}/${PV}/log4j.properties ${D}/etc/${TOMCAT_NAME}/
	chown tomcat:tomcat ${D}/etc/${TOMCAT_NAME}/log4j.properties

	dodoc  ${S}/jakarta-tomcat-5/{RELEASE-NOTES,RUNNING.txt}
	fperms 640 /etc/${TOMCAT_NAME}/default/tomcat-users.xml
}

pkg_postinst() {
	#due to previous ebuild bloopers, make sure everything is correct
	chown root:0 /etc/init.d/${TOMCAT_NAME}
	chown root:0 /etc/conf.d/${TOMCAT_NAME}
	chmod -R 750 /etc/${TOMCAT_NAME}

	einfo
	einfo " NOTICE!"
	einfo " FILE LOCATIONS:"
	einfo " 1.  Tomcat home directory: ${TOMCAT_HOME}"
	einfo "     Contains application data, configuration files."
	einfo " 2.  Runtime settings: /etc/conf.d/${TOMCAT_NAME}"
	einfo "     Contains CLASSPATH and JAVA_HOME settings."
	einfo " 3.  Configuration:  /etc/${TOMCAT_NAME}/default"
	einfo " 4.  Logs:  /var/log/${TOMCAT_NAME}/default"
	einfo
	einfo
	einfo " STARTING AND STOPPING TOMCAT:"
	einfo "   /etc/init.d/${TOMCAT_NAME} start"
	einfo "   /etc/init.d/${TOMCAT_NAME} stop"
	einfo "   /etc/init.d/${TOMCAT_NAME} restart"
	einfo
	einfo
	ewarn " If you are upgrading from older ebuild do NOT use"
	ewarn " /etc/init.d/tomcat and /etc/conf.d/tomcat you probably"
	ewarn " want to remove these."
	einfo
	ewarn " This ebuild implements a new filesystem layout for tomcat"
	ewarn " please read http://gentoo-wiki.com/Tomcat_Gentoo_ebuild for"
	ewarn " more information!."
	einfo
	einfo " NETWORK CONFIGURATION:"
	einfo " By default, Tomcat runs on port 8080.  You can change this"
	einfo " value by editing /etc/${TOMCAT_NAME}/default/server.xml."
	einfo
	einfo " To test Tomcat while it's running, point your web browser to:"
	einfo " http://localhost:8080/"
	if ! use examples; then
		ewarn
		ewarn "You do not have the examples USE flag set, examples have NOT been installed."
		ewarn
	fi
	einfo
	einfo " BUGS:"
	einfo " Please file any bugs at http://bugs.gentoo.org/ or else it"
	einfo " may not get seen.  Thank you."
	einfo

	einfo "${WEBAPPS_DIR}"
	einfo "is now owned by tomcat:tomcat and has 750 as permissions."
	einfo "This is needed to deploy WAR files from the manager webapp."
	einfo "See bug 99704. If you are upgrading tomcat you need to manually"
	einfo "change the permissions."
}

#helpers
set_webapps_perms() {
	chown  tomcat:tomcat ${1} || die "Failed to change owner off ${1}."
	chmod  750           ${1} || die "Failed to change permissions off ${1}."
}
