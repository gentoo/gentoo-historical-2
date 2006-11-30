# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-4.0-r2.ebuild,v 1.4 2006/11/30 16:03:05 caster Exp $

inherit eutils java-pkg

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
#
# Remove the unset DISPLAY line from src_compile to get graphical license dialogs and pause before
# unscramble

MY_PV=${PV/./_}

BASELOCATION="http://www.netbeans.org/download/${MY_PV}/fcs/200412081800/d5a0f13566068cb86e33a46ea130b207"
MAINTARBALL="netbeans-${MY_PV}-src-ide_sources.tar.bz2"
JAVADOCTARBALL="netbeans-${MY_PV}-docs-javadoc.tar.bz2"

SRC_URI="${BASELOCATION}/${MAINTARBALL}
		 doc? ( ${BASELOCATION}/${JAVADOCTARBALL} )"

LICENSE="Apache-1.1 Apache-2.0 SPL W3C sun-bcla-j2eeeditor sun-bcla-javac sun-javac as-is docbook sun-resolver"
SLOT="4.0"
KEYWORDS="~x86 ~amd64"
IUSE="debug doc"

# dev-java/xml-commons-resolver for future versions
RDEPEND=">=virtual/jre-1.4.2
		  =dev-java/commons-logging-1.0*
		   dev-java/commons-el
		  =dev-java/junit-3.8*
		  =dev-java/servletapi-2.2*
		  =dev-java/servletapi-2.3*
		  =dev-java/servletapi-2.4*
		 >=dev-java/xerces-2.7
		   dev-java/sac
		   dev-java/flute
		 >=dev-java/jmi-interface-1.0-r1
		 >=dev-java/javahelp-bin-2.0.02-r1
		  ~www-servers/tomcat-5.0.28
		   dev-java/sun-j2ee-deployment-bin
		   dev-java/xml-commons
		   dev-java/jakarta-jstl"
DEPEND="${RDEPEND}
		>=virtual/jdk-1.4.2
		>=dev-java/ant-1.6.1
		 =dev-java/jakarta-regexp-1.3*
		 =dev-java/xalan-2*
		  dev-java/jtidy
		 =dev-java/jaxen-1.1*
		  dev-java/saxpath
		  dev-java/javamake-bin
		  dev-util/pmd
		  dev-libs/libxslt"

TOMCATSLOT="5"

# Replacement JARs for Netbeans
COMMONS_LOGGING="commons-logging commons-logging.jar commons-logging-1.0.4.jar"
JASPERCOMPILER="tomcat-${TOMCATSLOT} jasper-compiler.jar jasper-compiler-5.0.28.jar"
JASPERRUNTIME="tomcat-${TOMCATSLOT} jasper-runtime.jar jasper-runtime-5.0.28.jar"
JH="javahelp-bin jh.jar jh-2.0_01.jar"
JMI="jmi-interface jmi.jar jmi.jar"
JSPAPI="servletapi-2.4 jsp-api.jar jsp-api-2.0.jar"
JSR="sun-j2ee-deployment-bin-1.1 sun-j2ee-deployment-bin.jar jsr88javax.jar"
JSTL="jakarta-jstl jstl.jar	jstl-1.1.2.jar"
JUNIT="junit junit.jar junit-3.8.1.jar"
MOF="jmi-interface mof.jar mof.jar"
PMD="pmd pmd.jar pmd-1.3.jar"
REGEXP="jakarta-regexp-1.3 jakarta-regexp.jar regexp-1.2.jar"
SERVLET22="servletapi-2.2 servlet.jar servlet-2.2.jar"
SERVLET23="servletapi-2.3 servlet.jar servlet-2.3.jar"
SERVLET24="servletapi-2.4 servlet-api.jar servlet-api-2.4.jar"
STANDARD="jakarta-jstl standard.jar standard-1.1.2.jar"
XERCES="xerces-2 xercesImpl.jar xerces-2.6.2.jar"
XMLCOMMONS="xml-commons xml-apis.jar xml-commons-dom-ranges-1.0.b2.jar"

S=${WORKDIR}/netbeans-src
BUILDDESTINATION="${S}/nbbuild/netbeans"
IDE_VERSION="4"
MY_FDIR="${FILESDIR}/4.0"
DESTINATION="${ROOT}usr/share/netbeans-${SLOT}"

antflags=""

set_env() {

	antflags=""

	if use debug; then
		antflags="${antflags} -Dbuild.compiler.debug=true"
		antflags="${antflags} -Dbuild.compiler.deprecation=true"
	else
		antflags="${antflags} -Dbuild.compiler.deprecation=false"
	fi

	antflags="${antflags} -Dnetbeans.no.pre.unscramble=true"
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

	if use doc; then
		mkdir javadoc && cd javadoc
		unpack ${JAVADOCTARBALL} || die "Unable to extract javadoc"
		rm -f *.zip
	fi

	cd ${S}/nbbuild
	# Disable the bundled Tomcat in favor of Portage installed version
	sed -i -e "s%tomcatint/tomcat5/bundled,%%g" *.properties

	einfo "Symlinking packed jars to system jars"

	set_env

	cd ${S}/ant/external/
	touch ant-api-1.6.2.zip
	touch ant-docs-1.6.2.zip
	unscramble_and_empty

	# We have ant libs here so using the system libs
	cd lib
	rm -fr *.jar
	java-pkg_jar-from ant-tasks
	java-pkg_jar-from ant-core

	cd ${S}/core/external
	unscramble_and_empty
	java-pkg_jar-from ${JH}

	cd ${S}/mdr/external/
	unscramble_and_empty
	java-pkg_jar-from ${JMI}
	java-pkg_jar-from ${MOF}

	cd ${S}/nbbuild/external
	unscramble_and_empty
	java-pkg_jar-from javahelp-bin jhall.jar jhall-2.0_01.jar

	cd ${S}/libs/external/
	unscramble_and_empty
	java-pkg_jar-from ${XERCES}
	java-pkg_jar-from ${COMMONS_LOGGING}
	java-pkg_jar-from xalan xalan.jar xalan-2.5.2.jar
	java-pkg_jar-from ${XMLCOMMONS}
	java-pkg_jar-from ${PMD}
	java-pkg_jar-from ${REGEXP}
	# j2eeeditor-1.0.jar is only used in Netbeans but licensed under
	# Sun's bcla + supplemental terms

	cd ${S}/xml/external/
	unscramble_and_empty
	java-pkg_jar-from sac
	java-pkg_jar-from xerces-2 xercesImpl.jar xerces2.jar
	java-pkg_jar-from flute
	# There's also resolver-1_1_nb.jar in this directory.
	# The implementation is from Sun and I haven't found it.
	# In later Netbeans versions xml-commons is used so we will use it
	# then.

	cd ${S}/httpserver/external/
	unscramble_and_empty
	java-pkg_jar-from ${SERVLET22}
	# The webserver.jar in here is a stripped down version of Tomcat 3.3.
	# We will use the included jar because we don't want to have Tomcat 3.X
	# in the tree and because maintaining it would probably be a pain.

	cd ${S}/j2eeserver/external
	unscramble_and_empty
	java-pkg_jar-from ${JSR}

	cd ${S}/java/external/
	unscramble_and_empty
	java-pkg_jar-from javamake-bin javamake.jar javamake-1.2.12.jar
	# gjast.jar is a mix of Netbeans stuff with sun javac stuff
	# It is not available elsewhere.

	cd ${S}/junit/external/
	touch junit-3.8.1-api.zip
	unscramble_and_empty
	java-pkg_jar-from ${JUNIT}

	cd ${S}/tasklist/external/
	unscramble_and_empty
	java-pkg_jar-from jtidy Tidy.jar Tidy-r7.jar

	cd ${S}/web/external
	touch jsp20-docs.zip
	touch jstl-1.1.2-javadoc.zip
	touch servlet24-docs.zip
	unscramble_and_empty
	java-pkg_jar-from ${SERVLET23}
	java-pkg_jar-from ${SERVLET24}
	java-pkg_jar-from commons-el
	java-pkg_jar-from jaxen-1.1 jaxen.jar jaxen-full.jar
	java-pkg_jar-from saxpath
	java-pkg_jar-from ${JASPERCOMPILER}
	java-pkg_jar-from ${JASPERRUNTIME}
	java-pkg_jar-from ${JSPAPI}
	java-pkg_jar-from ${JSTL}
	java-pkg_jar-from ${STANDARD}

}

src_compile() {

	set_env

	# The location of the main build.xml file
	cd ${S}/nbbuild

	# Specify the build-nozip target otherwise it will build
	# a zip file of the netbeans folder, which will copy directly.
	yes yes 2>/dev/null | ant ${antflags} build-nozip || die "Compiling failed!"

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
}

src_install() {
	insinto $DESTINATION

	einfo "Installing the program..."
	cd ${BUILDDESTINATION}
	doins -r *

	symlink_extjars ${D}/${DESTINATION}

	fperms 755 \
		   ${DESTINATION}/bin/netbeans \
		   ${DESTINATION}/platform${IDE_VERSION}/lib/nbexec

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
	doins ${S}/core/ide/release/bin/icons/*png

	for res in "16x16" "24x24" "32x32" "48x48" "128x128" ; do
		dodir /usr/share/icons/hicolor/${res}/apps
		dosym ${DESTINATION}/icons/nb${res}.png /usr/share/icons/hicolor/${res}/apps/netbeans.png
	done

	make_desktop_entry netbeans-${SLOT} "Netbeans ${SLOT}" netbeans Development
}

pkg_postinst () {
	einfo "Your tomcat directory might not have the right permissions."
	einfo "Please make sure that normal users can read the directory: "
	einfo "${ROOT}usr/share/tomcat-${TOMCATSLOT}                      "
	einfo "                                                           "
	einfo "The integrated Tomcat is not installed, but you can easily "
	einfo "use the system Tomcat. See Netbeans documentation if you   "
	einfo "don't know how to do that. The relevant settings are in the"
	einfo "runtime window.                                            "
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

function symlink_extjars() {
	einfo "Added symlinks to system jars inside"
	einfo "${DESTINATION}"

	cd ${1}/ide${IDE_VERSION}/modules/ext
	java-pkg_jar-from ${COMMONS_LOGGING}
	java-pkg_jar-from flute
	java-pkg_jar-from sac
	java-pkg_jar-from ${JMI}
	java-pkg_jar-from ${MOF}
	java-pkg_jar-from ${JUNIT}

	cd ${1}/ide${IDE_VERSION}/modules/autoload/ext
	java-pkg_jar-from commons-el
	java-pkg_jar-from ${SERVLET22}
	java-pkg_jar-from ${SERVLET23}
	java-pkg_jar-from ${SERVLET24}
	java-pkg_jar-from ${XERCES}
	java-pkg_jar-from ${JSR}
	java-pkg_jar-from ${JASPERCOMPILER}
	java-pkg_jar-from ${JASPERRUNTIME}
	java-pkg_jar-from ${XMLCOMMONS}
	java-pkg_jar-from ${JSPAPI}

	cd ${1}/ide4/config/TagLibraries/JSTL11
	java-pkg_jar-from jakarta-jstl jstl.jar
	java-pkg_jar-from jakarta-jstl standard.jar

	cd ${1}/platform${IDE_VERSION}/modules/ext
	java-pkg_jar-from ${JH}
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

	mv ${T}/out.xml ${file} \
		|| die "Failed to create a build.xml file without unscrambling"
}
