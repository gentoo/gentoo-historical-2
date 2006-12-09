# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-5.5-r1.ebuild,v 1.5 2006/12/09 09:29:34 flameeyes Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="NetBeans IDE for Java"
HOMEPAGE="http://www.netbeans.org"

# ant-mis is stuff we never use put instead of pactching we let the build process use this file
# so adding the license just to be sure
# The list of files in here is not complete but just some I listed.
# Apache-1.1: webserver.jar
# Apache-2.0: ant-misc-1.6.2.zip
# as-is: docbook-xsl-1.65.1.zip, pmd-netbeans35-bin-0.91.zip

# There are many other scrambled files in Netbeans but the
# default module configuration doesn't use all of them.
#
# Check the experimental tree for useful stuff.
# https://gentooexperimental.org/svn/java/gentoo-java-experimental/dev-util/netbeans/files
#
# This command should be run after ebuild <pkg> unpack in the source root
# 'ebuild netbeans-${PVR}.ebuild compile | grep Unscrambling | grep "\.jar"'
# Check which jars are actually being used to compile Netbeans
#
# This command should be run after ebuild <pkg> install in the image root
# 'find . -name "*.jar" -type f | less'
# Check the list to see that no packed jars get copied to the image
# To list the contents
# ( for zip in $(find -name "*.jar" -type f); do unzip -l $zip; done ) | less
#
# Remove the unset DISPLAY line from src_compile to get graphical license dialogs and pause before
# unscramble

MY_PV=${PV/_/-}
MY_PV=${MY_PV/./_}

BASELOCATION="http://us1.mirror.netbeans.org/download/${MY_PV/-//}/fcs/200610171010"
MAINTARBALL="netbeans-${MY_PV}-ide_sources.tar.bz2"
JAVADOCTARBALL="netbeans-${MY_PV}-javadoc.tar.bz2"

SRC_URI="${BASELOCATION}/${MAINTARBALL}
	 doc? ( ${BASELOCATION}/${JAVADOCTARBALL} )"

LICENSE="Apache-1.1 Apache-2.0 SPL W3C sun-bcla-j2eeeditor sun-bcla-javac sun-javac as-is docbook sun-resolver"
SLOT="5.5"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="debug doc"

RDEPEND=">=virtual/jre-1.5
		dev-java/antlr
		dev-java/commons-el
		=dev-java/commons-beanutils-1.6*
		=dev-java/commons-beanutils-1.7*
		dev-java/commons-beanutils
		dev-java/commons-digester
		>=dev-java/commons-fileupload-1.1
		>=dev-java/commons-io-1.2
		>=dev-java/commons-logging-1.1
		dev-java/commons-validator
		=dev-java/gnu-jaf-1*
		dev-java/jakarta-jstl
		dev-java/jakarta-oro
		>=dev-java/javahelp-bin-2.0.02-r1
		dev-java/jgoodies-forms
		>=dev-java/jmi-interface-1.0-r1
		>=dev-java/jsch-0.1.24
		=dev-java/junit-3.8*
		dev-java/flute
		dev-java/sac
		=dev-java/servletapi-2.2*
		=dev-java/servletapi-2.3*
		=dev-java/servletapi-2.4*
		=dev-java/struts-1.2*
		dev-java/sun-j2ee-deployment-bin
		dev-java/sun-javamail
		dev-java/sun-jmx
		>=dev-java/xerces-2.8.0
		=dev-java/swing-layout-1*
		dev-java/xml-commons
		=www-servers/tomcat-5.5*
		   "
DEPEND="${RDEPEND}
		>=virtual/jdk-1.5
		>=dev-java/ant-1.6.2
		  dev-util/pmd
		  dev-libs/libxslt
		 =dev-java/xalan-2*
"

TOMCATSLOT="5.5"

# Replacement JARs for Netbeans used more than once
COMMONS_LOGGING="commons-logging commons-logging.jar commons-logging-1.0.4.jar"
JAVAHELP_VERSION="2.0_03"
JH="javahelp-bin jh.jar jh-${JAVAHELP_VERSION}.jar"
JHALL="javahelp-bin jhall.jar jhall-${JAVAHELP_VERSION}.jar"
JMI="jmi-interface jmi.jar jmi.jar"
JSCH="jsch jsch.jar jsch-0.1.24.jar"
JSPAPI="servletapi-2.4 jsp-api.jar jsp-api-2.0.jar"
JSR="sun-j2ee-deployment-bin-1.1 sun-j2ee-deployment-bin.jar jsr88javax.jar"
JSTL="jakarta-jstl jstl.jar	jstl-1.1.2.jar"
JUNIT="junit junit.jar junit-3.8.1.jar"
MOF="jmi-interface mof.jar mof.jar"
SERVLET22="servletapi-2.2 servlet.jar servlet-2.2.jar"
SERVLET23="servletapi-2.3 servlet.jar servlet-2.3.jar"
SERVLET24="servletapi-2.4 servlet-api.jar servlet-api-2.4.jar"
XERCES="xerces-2 xercesImpl.jar xerces-2.8.0.jar"
XMLCOMMONS="xml-commons xml-apis.jar xml-commons-dom-ranges-1.0.b2.jar"
SWINGLAYOUT="swing-layout-1 swing-layout.jar swing-layout-1.0.jar"

S=${WORKDIR}/netbeans-src
BUILDDESTINATION="${S}/nbbuild/netbeans"
ENTERPRISE="3"
IDE_VERSION="7"
PLATFORM="6"
MY_FDIR="${FILESDIR}/${SLOT}"
DESTINATION="${ROOT}usr/share/netbeans-${SLOT}"
JAVA_PKG_BSFIX="off"

antflags=""

set_env() {

	antflags=""

	if use debug; then
		antflags="${antflags} -Dbuild.compiler.debug=true"
		antflags="${antflags} -Dbuild.compiler.deprecation=true"
	else
		antflags="${antflags} -Dbuild.compiler.deprecation=false"
	fi

	antflags="${antflags} -Dstop.when.broken.modules=true"

	# The build will attempt to display graphical
	# dialogs for the licence agreements if this is set.
	unset DISPLAY

	# -Xmx1g: Increase Java maximum heap size, otherwise ant will die with
	#         an OutOfMemoryError while building.
	# -Djava.awt.headless=true: Sun JDK doesnt like that very much, so
	#                           lets pleasure them too ;-)
	#
	# We use the ANT_OPTS environment variable because other ways seem to
	# fail.
	#
	export ANT_OPTS="${ANT_OPTS} -Xmx1g -Djava.awt.headless=true"

}

src_unpack () {
	unpack ${MAINTARBALL}

	epatch "${MY_FDIR}/jdbcstorage-build.xml-comments.patch"
	epatch "${MY_FDIR}/mdrant-build.xml-comments.patch"

	if use doc; then
		mkdir javadoc && cd javadoc
		unpack ${JAVADOCTARBALL} || die "Unable to extract javadoc"
		rm -f *.zip
	fi

	cd ${S}/nbbuild
	# Disable the bundled Tomcat in favor of Portage installed version
	sed -i -e "s%tomcatint/tomcat5/bundled,%%g" *.properties

	set_env
	place_symlinks
}

src_compile() {

	set_env

	# The location of the main build.xml file
	cd ${S}/nbbuild

	# Specify the build-nozip target otherwise it will build
	# a zip file of the netbeans folder, which will copy directly.
	eant ${antflags} build-nozip

	# Remove non-x86 Linux binaries
	find ${BUILDDESTINATION} -type f \
		-name "*.exe" -o \
		-name "*.cmd" -o \
		-name "*.bat" -o \
		-name "*.dll"	  \
		| xargs rm -f

	# Removing external stuff. They are api docs from external libs.
	cd ${BUILDDESTINATION}/ide${IDE_VERSION}/docs
	rm -f *.zip

	# The next directory seems to be empty
	if ! rmdir doc 2> /dev/null; then
		use doc || rm -fr ./doc
	fi

	# Use the system ant
	cd ${BUILDDESTINATION}/ide${IDE_VERSION}/ant

	rm -fr ./lib
	rm -fr ./bin

	# Set a initial default jdk
	echo "netbeans_jdkhome=\"\$(java-config -O)\"" >> ${BUILDDESTINATION}/etc/netbeans.conf
}

src_install() {
	insinto $DESTINATION

	einfo "Installing the program..."
	cd ${BUILDDESTINATION}
	doins -r *

	symlink_extjars ${D}/${DESTINATION}

	fperms 755 \
		   ${DESTINATION}/bin/netbeans \
		   ${DESTINATION}/platform${PLATFORM}/lib/nbexec

	# The wrapper wrapper :)
	newbin ${MY_FDIR}/startscript.sh netbeans-${SLOT}

	# Ant installation
	local ANTDIR="${DESTINATION}/ide${IDE_VERSION}/ant"
	cd ${D}/${ANTDIR}

	dodir /usr/share/ant-core/lib
	dosym /usr/share/ant-core/lib ${ANTDIR}/lib

	dodir /usr/share/ant-core/bin
	dosym /usr/share/ant-core/bin  ${ANTDIR}/bin

	# Documentation
	einfo "Installing Documentation..."

	cd ${D}/${DESTINATION}

	use doc && java-pkg_dohtml -r ${WORKDIR}/javadoc/*

	dodoc build_info
	dohtml CREDITS.html README.html netbeans.css

	rm -f build_info CREDITS.html README.html netbeans.css

	# Icons and shortcuts
	einfo "Installing icons..."

	dodir ${DESTINATION}/icons
	insinto ${DESTINATION}/icons
	doins ${S}/ide/branding/release/*png

	for res in "16x16" "24x24" "32x32" "48x48" "128x128" ; do
		dodir /usr/share/icons/hicolor/${res}/apps
		dosym ${DESTINATION}/icons/netbeans.png /usr/share/icons/hicolor/${res}/apps/netbeans.png
	done

	make_desktop_entry netbeans-${SLOT} "Netbeans ${SLOT}" netbeans Development
}

pkg_postinst () {
	elog "The integrated Tomcat is not installed, but you can easily "
	elog "use the system Tomcat. See Netbeans documentation if you   "
	elog "don't know how to do that. The relevant settings are in the"
	elog "runtime window.                                            "
	elog
	elog "If you are using some packages on top of Netbeans, you have"
	elog "to re-emerge them now.                                     "
}

pkg_postrm() {
#	einfo "Removing symlinks to jars from"
#	einfo "${DESTINATION}"
#	find ${DESTINATION} -type l | xargs rm -fr

	if ! test -e /usr/bin/netbeans-${SLOT}; then
		einfo "Because of the way Portage works at the moment"
		einfo "symlinks to the system jars are left to:"
		einfo "${DESTINATION}"
		einfo "If you are uninstalling Netbeans you can safely"
		einfo "remove everything in this directory"
	fi
}

# Supporting functions for this ebuild

function fix_manifest() {
	sed -i "s%ext/${1}%$(java-pkg_getjar ${2} ${3})%" ${4}
}

function place_symlinks() {
	einfo "Symlinking scrambled jars to system jars"

	cd ${S}/apisupport/external
	java-pkg_jar-from javahelp-bin jsearch.jar jsearch-${JAVAHELP_VERSION}.jar

	cd ${S}/mdr/external/
	hide jmi.jar mof.jar || die
	java-pkg_jar-from ${JMI} || die
	java-pkg_jar-from ${MOF} || die

	cd ${S}/nbbuild/external
	hide jhall*.jar || die
	java-pkg_jar-from ${JHALL} || die

	cd ${S}/libs/external/
	hide xerces*.jar commons-logging*.jar xml-commons*.jar pmd*.jar  || die
	java-pkg_jar-from ${XERCES} || die
	java-pkg_jar-from ${COMMONS_LOGGING} || die
	java-pkg_jar-from ${XMLCOMMONS} || die
	java-pkg_jar-from pmd pmd.jar pmd-1.3.jar || die
	java-pkg_jar-from ${SWINGLAYOUT} || die
	java-pkg_jar-from ${JSCH} || die
	java-pkg_jar-from jgoodies-forms forms.jar forms-1.0.5.jar || die

	cd ${S}/httpserver/external/
	hide servlet*.jar || die
	java-pkg_jar-from ${SERVLET22} || die

	cd ${S}/j2eeserver/external
	hide jsr*.jar || die
	java-pkg_jar-from ${JSR} || die

	cd ${S}/junit/external/
	hide junit*.jar || die
	java-pkg_jar-from ${JUNIT} || die

	cd ${S}/web/external
	hide servlet-*.jar  jstl*.jar standard*.jar commons-el*.jar || die
	java-pkg_jar-from ${SERVLET23} || die
	java-pkg_jar-from ${SERVLET24} || die
	java-pkg_jar-from ${JSPAPI} || die
	java-pkg_jar-from ${JSTL} || die
	java-pkg_jar-from jakarta-jstl standard.jar standard-1.1.2.jar || die
	java-pkg_jar-from commons-el || die

	cd ${S}/xml/external/
	hide flute*.jar sac*.jar || die
	java-pkg_jar-from sac || die
	java-pkg_jar-from flute || die
}

function symlink_extjars() {
	einfo "Added symlinks to system jars inside"
	einfo "${DESTINATION}"

	cd ${1}/enterprise${ENTERPRISE}/modules/ext
	java-pkg_jar-from ${JSR}
	java-pkg_jar-from jakarta-jstl jstl.jar
	java-pkg_jar-from jakarta-jstl standard.jar

	cd ${1}/enterprise${ENTERPRISE}/modules/ext/blueprints/
	java-pkg_jar-from commons-fileupload commons-fileupload.jar commons-fileupload-1.1.1.jar
	java-pkg_jar-from commons-io-1 commons-io.jar commons-io-1.2.jar
	java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.1.jar

	cd ${1}/enterprise${ENTERPRISE}/modules/ext/jsf
	java-pkg_jar-from commons-beanutils-1.6 commons-beanutils.jar
	java-pkg_jar-from commons-collections commons-collections.jar
	java-pkg_jar-from commons-digester commons-digester.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	#java-pkg_jar-from ? jsf-api.jar
	#java-pkg_jar-from ? jsf-impl.jar

	cd ${1}/enterprise${ENTERPRISE}/modules/ext/struts
	java-pkg_jar-from antlr antlr.jar
	java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	java-pkg_jar-from commons-digester commons-digester.jar
	java-pkg_jar-from commons-fileupload commons-fileupload.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from commons-validator commons-validator.jar
	java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar
	java-pkg_jar-from struts-1.2 struts.jar

	cd ${1}/ide${IDE_VERSION}/modules/ext
	java-pkg_jar-from ${COMMONS_LOGGING}
	java-pkg_jar-from flute
	java-pkg_jar-from sac
	java-pkg_jar-from ${JMI}
	java-pkg_jar-from ${JSCH}
	java-pkg_jar-from ${MOF}
	java-pkg_jar-from ${JUNIT}
	java-pkg_jar-from ${SERVLET22}
	java-pkg_jar-from ${XERCES}
	java-pkg_jar-from ${XMLCOMMONS}

	cd "${1}/ide${IDE_VERSION}/modules/ext/jaxrpc16/"
	java-pkg_jar-from gnu-jaf-1 activation.jar activation.jar
	java-pkg_jar-from sun-javamail mail.jar

	cd "${1}/ide${IDE_VERSION}/modules/ext/jaxws20/"
	java-pkg_jar-from gnu-jaf-1 activation.jar activation.jar

# Commented out JHALL till 2.0_03 is released
	cd ${1}/platform${PLATFORM}/modules/ext
	java-pkg_jar-from ${SWINGLAYOUT}
#	java-pkg_jar-from ${JHALL}
}

function hide() {
	for x in $@ ; do
		mv $x _$x
	done
}

function unscramble_and_empty() {
	echo $(pwd)
	yes yes 2> /dev/null | ant ${antflags} unscramble > /dev/null || die "Failed to unscramble"
	remove_unscrambling
}

function remove_unscrambling() {
	local file=${1}

	[ -z ${file} ] && file="build.xml"

	xsltproc -o ${T}/out.xml ${FILESDIR}/emptyunscramble.xsl ${file} \
		|| die "Failed to remove unscrambling from one of the build.xml files"
	mv ${T}/out.xml ${file}
}
