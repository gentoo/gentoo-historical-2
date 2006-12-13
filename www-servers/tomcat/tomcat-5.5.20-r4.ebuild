# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tomcat/tomcat-5.5.20-r4.ebuild,v 1.2 2006/12/13 03:13:45 wltjr Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Apache Servlet-2.4/JSP-2.0 Container"

MY_P="apache-${P}-src"
SLOT="5.5"
SRC_URI="mirror://apache/${PN}/${PN}-5/v${PV}/src/${MY_P}.tar.gz"
HOMEPAGE="http://jakarta.apache.org/tomcat"
KEYWORDS="amd64 x86 -ppc -ppc64"
LICENSE="Apache-2.0"

IUSE="admin java5 doc examples source test"

RDEPEND="=dev-java/eclipse-ecj-3.1*
	=dev-java/commons-beanutils-1.7*
	>=dev-java/commons-collections-3.1
	>=dev-java/commons-daemon-1.0.1
	>=dev-java/commons-dbcp-1.2.1
	>=dev-java/commons-digester-1.7
	>=dev-java/commons-fileupload-1.1
	>=dev-java/commons-io-1.1
	>=dev-java/commons-el-1.0
	>=dev-java/commons-launcher-0.9
	>=dev-java/commons-logging-1.0.4
	>=dev-java/commons-modeler-1.1
	>=dev-java/commons-pool-1.2
	>=dev-java/log4j-1.2.9
	~dev-java/servletapi-2.4
	admin? ( =dev-java/struts-1.2* )
	dev-java/sun-javamail
	java5? ( >=virtual/jre-1.5 )
	!java5? (
		=virtual/jre-1.4*
		>=dev-java/commons-httpclient-2.0
		dev-java/sun-jaf
		>=dev-java/junit-3.8.1
		=dev-java/mx4j-3*
		>=dev-java/saxpath-1.0
		>=dev-java/xerces-2.7.1
	   	=dev-java/xml-commons-external-1.3*
	   )"
DEPEND="java5? ( >=virtual/jdk-1.5 )
	!java5? ( =virtual/jdk-1.4* )
	${RDEPEND}
	dev-java/ant"

if ! use java5; then
	JAVA_PKG_NV_DEPEND="=virtual/jdk-1.4*"
else
	JAVA_PKG_NV_DEPEND="=virtual/jdk-1.5*"
fi

S=${WORKDIR}/${MY_P}

TOMCAT_NAME="${PN}-${SLOT}"
WEBAPPS_DIR="/var/lib/${TOMCAT_NAME}/webapps"

pkg_setup() {
	# new user for tomcat
	enewgroup tomcat
	enewuser tomcat -1 -1 /dev/null tomcat

	java-pkg_filter-compiler ecj-3.1  ecj-3.2

	if use java5; then
		JAVA_PKG_WANT_SOURCE="1.5"
		JAVA_PKG_WANT_TARGET="1.5"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}

	local PATCHES="
		mainbuild-xml.patch
		tomcatbuild-xml.patch
		catalinabuild-xml.patch
		jasperbuild-xml.patch
	"
	for patch in ${PATCHES}; do
		epatch "${FILESDIR}/${PV}/${patch}"
	done
	if ! use examples; then
		epatch "${FILESDIR}/${PV}/jsr152build-xml-examples.patch"
		epatch "${FILESDIR}/${PV}/jsr154build-xml-examples.patch"
	fi

	# avoid packed jars :-)
	mkdir -p ${S}/build/build/common
	cd ${S}/build/build

	mkdir ./bin && cd ./bin
	java-pkg_jar-from commons-logging commons-logging-api.jar
	java-pkg_jar-from commons-daemon
	if ! use java5; then
		java-pkg_jar-from mx4j-3.0 mx4j.jar jmx.jar
		java-pkg_jar-from mx4j-3.0 mx4j-rjmx.jar jmx-remote.jar
	fi

	if ! use java5; then
		mkdir ${S}/build/build/common/endorsed && cd ${S}/build/build/common/endorsed
		java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
		java-pkg_jar-from xerces-2 xercesImpl.jar
	fi

	mkdir ${S}/build/build/common/lib && cd ${S}/build/build/common/lib
	java-pkg_jar-from ant-core
	java-pkg_jar-from commons-collections
	java-pkg_jar-from commons-dbcp
	java-pkg_jar-from commons-el
	java-pkg_jar-from commons-pool
	java-pkg_jar-from servletapi-2.4

	mkdir -p ${S}/build/build/server/lib && cd ${S}/build/build/server/lib
	java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	java-pkg_jar-from commons-digester
	java-pkg_jar-from commons-modeler

	mkdir -p ${S}/container/webapps/manager/WEB-INF/lib
	cd ${S}/container/webapps/manager/WEB-INF/lib
	java-pkg_jar-from commons-fileupload
	java-pkg_jar-from commons-io-1

}

src_compile(){
	local antflags="-Dbase.path=${T}"

	antflags="${antflags} -Dcommons-collections.jar=$(java-config -p commons-collections)"
	antflags="${antflags} -Dcommons-daemon.jar=$(java-config -p commons-daemon)"
	antflags="${antflags} -Dcommons-digester.jar=$(java-config -p commons-digester)"
	antflags="${antflags} -Dcommons-dbcp.jar=$(java-config -p commons-dbcp)"
	antflags="${antflags} -Dcommons-el.jar=$(java-config -p commons-el)"
	antflags="${antflags} -Dcommons-pool.jar=$(java-config -p commons-pool)"
	antflags="${antflags} -Dcommons-fileupload.jar=$(java-config -p commons-fileupload)"
	antflags="${antflags} -Dcommons-launcher.jar=$(java-config -p commons-launcher)"
	antflags="${antflags} -Dcommons-modeler.jar=$(java-config -p commons-modeler)"
	antflags="${antflags} -Djunit.jar=$(java-config -p junit)"
	antflags="${antflags} -Djdt.jar=$(java-pkg_getjar eclipse-ecj-3.1 ecj.jar)"
	antflags="${antflags} -Dlog4j.jar=$(java-config -p log4j)"
	antflags="${antflags} -Dcommons-beanutils.jar=$(java-pkg_getjar commons-beanutils-1.7 commons-beanutils.jar)"
	antflags="${antflags} -Dcommons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar)"
	antflags="${antflags} -Dcommons-logging-api.jar=$(java-pkg_getjar commons-logging commons-logging-api.jar)"
	antflags="${antflags} -Dmail.jar=$(java-pkg_getjar sun-javamail mail.jar)"
	if use admin; then
		antflags="${antflags} -Dstruts.jar=$(java-pkg_getjar struts-1.2 struts.jar)"
		antflags="${antflags} -Dstruts.home=/usr/share/struts"
	else
		antflags="${antflags} -Dadmin.build.notrequired=true"
		antflags="${antflags} -Dadmin.precompile.notrequired=true"
	fi
	if ! use examples; then
		antflags="${antflags} -Dexamples.precompile.notrequired=true"
	fi
	antflags="${antflags} -Djasper.home=${S}/jasper"
	if ! use java5; then
		antflags="${antflags} -Dcommons-httpclient.jar=$(java-config -p commons-httpclient)"
		antflags="${antflags} -Dactivation.jar=$(java-config -p sun-jaf)"
		antflags="${antflags} -Djmx.jar=$(java-pkg_getjar mx4j-3.0 mx4j.jar)"
		antflags="${antflags} -Djmx-remote.jar=$(java-pkg_getjar mx4j-3.0 mx4j-rjmx.jar)"
		antflags="${antflags} -Dsaxpath.jar=$(java-pkg_getjar saxpath saxpath.jar)"
		antflags="${antflags} -DxercesImpl.jar=$(java-pkg_getjar xerces-2 xercesImpl.jar)"
		antflags="${antflags} -Dxml-apis.jar=$(java-pkg_getjar xml-commons-external-1.3 xml-apis.jar)"
	fi

	eant ${antflags}

}

src_install() {
	cd ${S}/build/build

	# init.d, conf.d
	newinitd ${FILESDIR}/${PV}/tomcat.init ${TOMCAT_NAME}
	newconfd ${FILESDIR}/${PV}/tomcat.conf ${TOMCAT_NAME}

	# create dir structure
	diropts -m755 -o tomcat -g tomcat
	dodir /usr/share/${TOMCAT_NAME}
	keepdir /var/log/${TOMCAT_NAME}/
	keepdir /var/tmp/${TOMCAT_NAME}/
	keepdir /var/run/${TOMCAT_NAME}/

	local CATALINA_BASE=/var/lib/${TOMCAT_NAME}/
	dodir   ${CATALINA_BASE}
	keepdir ${CATALINA_BASE}/shared/lib
	keepdir ${CATALINA_BASE}/shared/classes

	keepdir /usr/share/${TOMCAT_NAME}/common/lib

	dodir   /etc/${TOMCAT_NAME}
	fperms  750 /etc/${TOMCAT_NAME}

	diropts -m0755

	# we don't need dos scripts
	rm -f bin/*.bat

	# copy the manager and admin context's to the right position
	mkdir -p conf/Catalina/localhost
	if use admin; then
		cp ${S}/container/webapps/admin/admin.xml \
			conf/Catalina/localhost
	fi
	cp ${S}/container/webapps/manager/manager.xml \
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
	if use admin; then
		cd server/webapps/admin/WEB-INF/lib
		rm -f struts.jar
		java-pkg_jar-from struts-1.2 struts.jar
		cd ${base}
	else
		rm -fR server/webapps/admin
	fi

	# replace the default pw with a random one, see #92281
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	sed -e s:SHUTDOWN:${randpw}: -i conf/{server,server-minimal}.xml

	# copy over the directories
	chown -R tomcat:tomcat webapps/* conf/*
	cp -pR conf/* ${D}/etc/${TOMCAT_NAME} || die "failed to copy conf"
	cp -R bin common server ${D}/usr/share/${TOMCAT_NAME} || die "failed to copy"

	keepdir               ${WEBAPPS_DIR}
	set_webapps_perms     ${D}/${WEBAPPS_DIR}

	# Copy over webapps, some controlled by use flags
	cp -p ../RELEASE-NOTES webapps/ROOT/RELEASE-NOTES.txt
	cp -pr webapps/ROOT ${D}${CATALINA_BASE}/webapps
	if use doc; then
		cp -pr webapps/tomcat-docs ${D}${CATALINA_BASE}/webapps
	fi
	if use examples; then
		cp -pr webapps/{jsp-examples,servlets-examples,webdav} \
			${D}${CATALINA_BASE}/webapps
	fi

	# symlink the directories to make CATALINA_BASE possible
	dosym /etc/${TOMCAT_NAME} ${CATALINA_BASE}/conf
	dosym /var/log/${TOMCAT_NAME} ${CATALINA_BASE}/logs
	dosym /var/tmp/${TOMCAT_NAME} ${CATALINA_BASE}/temp
	dosym /var/run/${TOMCAT_NAME} ${CATALINA_BASE}/work

	dodoc  ${S}/build/{RELEASE-NOTES,RUNNING.txt}
	fperms 640 /etc/${TOMCAT_NAME}/tomcat-users.xml
}

pkg_postinst() {
	#due to previous ebuild bloopers, make sure everything is correct
	chown root:root /etc/init.d/${TOMCAT_NAME}
	chown root:root /etc/conf.d/${TOMCAT_NAME}

	einfo
	ewarn " This ebuild implements a new filesystem layout for tomcat"
	ewarn " please read http://www.gentoo.org/proj/en/java/tomcat-guide.xml"
	ewarn " for more information!."
	einfo
	einfo " Please file any bugs at http://bugs.gentoo.org/ or else it"
	einfo " may not get seen.  Thank you."
	einfo

#	einfo "Run emerge --config =${PF}"
#	einfo "to configure Tomcat if you need to for example"
#	einfo "change the home directory of the Tomcat user."
}

#helpers
set_webapps_perms() {
	chown  tomcat:tomcat ${1} || die "Failed to change owner off ${1}."
	chmod  750           ${1} || die "Failed to change permissions off ${1}."
}

pkg_config() {
	# Better suggestions are welcome
	local currentdir="$(getent passwd tomcat | gawk -F':' '{ print $6 }')"

	einfo "The default home directory for Tomcat is /dev/null."
	einfo "You need to change it if your applications needs it to"
	einfo "be an actual directory. Current home directory:"
	einfo "${currentdir}"
	einfo ""
	einfo "Do you want to change it [yes/no]?"

	local answer
	read answer

	if [[ "${answer}" == "yes" ]]; then
		einfo ""
		einfo "Suggestions:"
		einfo "${WEBAPPS_DIR}"
		einfo ""
		einfo "If you want to suggest a directory, file a bug to"
		einfo "http://bugs.gentoo.org"
		einfo ""
		einfo "Enter home directory:"

		local homedir
		read homedir

		einfo ""
		einfo "Setting home directory to: ${homedir}"

		/usr/sbin/usermod -d"${homedir}" tomcat

		einfo "You can run emerge --config =${PF}"
		einfo "again to change to homedir"
		einfo "at any time."
	fi
}
