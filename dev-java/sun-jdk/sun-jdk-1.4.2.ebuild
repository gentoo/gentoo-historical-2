# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.4.2.ebuild,v 1.2 2003/07/30 05:31:03 strider Exp $

# Since This Ebuild Has FETCH restrictions:
# You need to download this file from 
# http://java.sun.com/j2se/1.4.2/download.html 
# and copy it on your distfiles directory and emerge it again

inherit java nsplugins

A="j2sdk-1_4_2-linux-i586.bin"
S="${WORKDIR}/j2sdk1.4.2"
DESCRIPTION="Sun's J2SE Development Kit, version 1.4.2"
HOMEPAGE="http://java.sun.com/j2se/1.4.2/download.html"
SRC_URI=""
DEPEND=">=dev-java/java-config-0.2.5
	sys-apps/sed
	doc? ( =dev-java/java-sdk-docs-1.4.2* )"
RDEPEND="sys-libs/lib-compat"
PROVIDE="virtual/jre-1.4.2
	virtual/jdk-1.4.2
	virtual/java-scheme-2"
LICENSE="sun-bcla-java-vm"
SLOT="1.4"
KEYWORDS="~x86 -ppc -sparc -alpha -mips -hppa -arm"
IUSE="doc gnome kde mozilla"
RESTRICT="fetch"

PACKED_JARS="lib/tools.jar jre/lib/rt.jar jre/lib/jsse.jar jre/lib/charsets.jar
jre/lib/ext/localedata.jar jre/lib/plugin.jar jre/javaws/javaws.jar"

src_unpack() {
	if [ ! -f ${DISTDIR}/${A} ]; then
		die "Please download ${A} from ${HOMEPAGE} (select the \"Linux self-extracting file\" package format of the SDK) and move it to ${DISTDIR}"
	fi
	tail +507 ${DISTDIR}/${A} > install.sfx
	chmod +x install.sfx
	./install.sfx || die
	rm install.sfx

	if [ -f ${S}/lib/unpack ]; then
		UNPACK_CMD=${S}/lib/unpack
		chmod +x $UNPACK_CMD
		for i in $PACKED_JARS; do
			PACK_FILE=${S}/`dirname $i`/`basename $i .jar`.pack
			if [ -f ${PACK_FILE} ]; then
				echo "	unpacking: $i"
				$UNPACK_CMD ${PACK_FILE} ${S}/$i
				rm -f ${PACK_FILE}
			fi
		done
	fi
}

src_install () {
	local dirs="bin include jre lib man"
	dodir /opt/${P}

	for i in $dirs ; do
		cp -a $i ${D}/opt/${P}/
	done

	dodoc COPYRIGHT README LICENSE THIRDPARTYLICENSEREADME.txt
	dohtml README.html
	dodir /opt/${P}/share/
	cp -a demo src.zip ${D}/opt/${P}/share/

	local plugin_dir="ns610"
	if has_version '=gcc-3.2*' ; then
		plugin_dir="ns610-gcc32"
	fi
	if [ "`use mozilla`" ] ; then
		install_mozilla_plugin /opt/${P}/jre/plugin/i386/$plugin_dir/libjavaplugin_oji.so
	fi
	inst_plugin /opt/${P}/jre/plugin/i386/$plugin_dir/libjavaplugin_oji.so

	# create dir for system preferences
	dodir /opt/${P}/.systemPrefs

	# install control panel for Gnome/KDE
	sed -e "s/INSTALL_DIR\/JRE_NAME_VERSION/\/opt\/${P}\/jre/" \
		-e "s/\(Name=Java\)/\1 Control Panel/" \
		${D}/opt/${P}/jre/plugin/desktop/sun_java.desktop > \
		${T}/sun_java.desktop

	if use gnome ; then
		#TODO check this on Gnome
		dodir /usr/share/gnome/apps/Internet
		insinto /usr/share/gnome/apps/Internet
		doins ${T}/sun_java.desktop
	fi
	if use kde ; then
		dodir $KDEDIR/share/applnk/Internet
		insinto $KDEDIR/share/applnk/Internet
		doins ${T}/sun_java.desktop
	fi

	set_java_env ${FILESDIR}/${VMHANDLE}

	# TODO prepman "fixes" symlink ja -> ja__JP.eucJP in 'man' directory,
	#      creating ja.gz -> ja_JP.eucJP.gz. This is broken as ja_JP.eucJP
	#      is a directory and will not be gzipped ;)
}

pkg_postinst () {
	# Create files used as storage for system preferences.
	touch /opt/${P}/.systemPrefs/.system.lock
	chmod 644 /opt/${P}/.systemPrefs/.system.lock
	touch /opt/${P}/.systemPrefs/.systemRootModFile
	chmod 644 /opt/${P}/.systemPrefs/.systemRootModFile

	# Set as default VM if none exists
	java_pkg_postinst

	einfo "If you want to install the plugin for Netscape 4.x, type"
	einfo
	einfo "   cd /usr/lib/nsbrowser/plugins/"
	einfo "   ln -sf /opt/${P}/jre/plugin/i386/ns4/libjavaplugin.so"
	einfo
}

