# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.4.1_beta.ebuild,v 1.4 2002/08/26 16:47:25 karltk Exp $

. /usr/portage/eclass/inherit.eclass
inherit java

At="j2sdk-1_4_1-beta-linux-i586.bin"
S=${WORKDIR}/j2sdk1.4.1
SRC_URI=""
DESCRIPTION="Sun's J2SE Development Kit, version 1.4.1"
HOMEPAGE="http://java.sun.com/j2se/1.4.1/download.html"
LICENSE="sun-bcla"
SLOT="1.4"
KEYWORDS="x86 -ppc"
DEPEND="virtual/glibc
	>=dev-java/java-config-0.2.3
	doc? ( =dev-java/java-sdk-docs-1.4.0* )"
RDEPEND="$DEPEND"

PROVIDE="virtual/jre-1.4
	virtual/jdk-1.4
	virtual/java-scheme-2"
	
src_unpack() {
	if [ ! -f ${DISTDIR}/${At} ] ; then
		die "Please download ${At} from ${HOMEPAGE} (select the \"Linux GNUZIP Tar shell script\" package format of the SDK) and move it to ${DISTDIR}"
	fi
	tail +273 ${DISTDIR}/${At} > install.sfx
	chmod +x install.sfx
	./install.sfx || die
	rm install.sfx
}

src_install () {
	local dirs="bin include jre lib"
	dodir /opt/${P}
	
	
	for i in $dirs ; do
		cp -a $i ${D}/opt/${P}/
	done
	
	dodoc COPYRIGHT README LICENSE
	dohtml README.html
	
	doman man/man1/*.1
	
	dodir /opt/${P}/share/
	cp -a demo src.zip ${D}/opt/${P}/share/
	
	if [ "`use mozilla`" ] ; then
		dodir /usr/lib/mozilla/plugins
		dosym /opt/${P}/jre/plugin/i386/ns610/libjavaplugin_oji.so /usr/lib/mozilla/plugins/
	fi
	
	set_java_env ${FILESDIR}/${VMHANDLE} || die
}

pkg_postinst () {        
	# Set as default system VM if none exists
	java_pkg_postinst

	if [ "`use mozilla`" ] ; then                                           
		einfo "The Mozilla browser plugin has been installed as /usr/lib/mozilla/plugins/libjavaplugin_oji140.so"
	else                                                                    
		einfo "To install the Java plugin for Mozilla manually, do:"
		einfo "ln -s /opt/${P}/jre/plugin/i386/ns610/libjavaplugin_oji.so /usr/lib/mozilla/plugins/"
		einfo "(Make certain the directory /usr/lib/mozilla/plugins exists first)"
	fi
}
