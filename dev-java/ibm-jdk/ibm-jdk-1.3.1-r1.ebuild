# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ibm-jdk/ibm-jdk-1.3.1-r1.ebuild,v 1.15 2003/02/13 10:09:23 vapier Exp $

IUSE="doc"

inherit java

At=IBMJava2-SDK-131.tgz
S=${WORKDIR}/IBMJava2-131
DESCRIPTION="IBM JDK 1.3.1"
SRC_URI=""
HOMEPAGE="http://www6.software.ibm.com/dl/dklx130/dklx130-p"

DEPEND="virtual/glibc
	>=dev-java/java-config-0.2.5
	doc? ( =dev-java/java-sdk-docs-1.3.1* )"
RDEPEND="$DEPEND"
PROVIDE="virtual/jre-1.3.1
	virtual/jdk-1.3.1
	virtual/java-scheme-2"
LICENSE="IBM-ILNWP"
SLOT="1.3"
KEYWORDS="x86 -ppc -sparc "

src_unpack() {
	if [ ! -f ${DISTDIR}/${At} ] ; then
		die "Please download ${At} from ${HOMEPAGE}"
	fi
	unpack ${At} || die
}


src_install () {

	dodir /opt/${P}
	for i in bin include jre lib ; do
		cp -dpR $i ${D}/opt/${P}/
	done

	dodir /opt/${P}/share
	for i in demo src.jar ; do
		cp -dpR $i ${D}/opt/${P}/share/
	done
	
	dohtml -a html,htm,HTML -r docs
	dodoc docs/COPYRIGHT

	# Plugin is disabled as it crashes all the time	
#	if [ "`use mozilla`" ] ; then
#		dodir /usr/lib/mozilla/plugins
#		dosym /opt/${P}/jre/bin/libjavaplugin_oji.so /usr/lib/mozilla/plugins/
#	fi

	set_java_env ${FILESDIR}/${VMHANDLE}
}

# NOTE: We don't install the plugin, as it always segfaults.
