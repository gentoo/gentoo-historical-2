# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-java/emul-linux-x86-java-1.5.0.08.ebuild,v 1.1 2006/09/15 03:32:52 nichoj Exp $

inherit java-vm-2 eutils

MY_PVL=${PV%.*}_${PV##*.}
MY_PVA=${PV//./_}

At="jdk-${MY_PVA}-dlj-linux-i586.bin"
DESCRIPTION="32bit version Sun's J2SE Development Kit"
HOMEPAGE="http://java.sun.com/j2se/1.5.0/"
SRC_URI="http://download.java.net/dlj/binaries/${At}"

SLOT="1.5"
LICENSE="dlj-1.1"
KEYWORDS="~amd64 -*"
RESTRICT="nostrip"
IUSE="X alsa nsplugin"

JAVA_VM_NO_GENERATION1=true

RDEPEND="alsa? ( media-libs/alsa-lib )
	X? ( || ( ( x11-libs/libICE
				x11-libs/libSM
		 		x11-libs/libX11
				x11-libs/libXau
				x11-libs/libXdmcp
				x11-libs/libXext
				x11-libs/libXi
				x11-libs/libXp
				x11-libs/libXt
				x11-libs/libXtst
			  )
				virtual/x11
			)
		)"

JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

PACKED_JARS="lib/rt.jar lib/jsse.jar lib/charsets.jar lib/ext/localedata.jar lib/plugin.jar lib/javaws.jar lib/deploy.jar"

# this is needed for proper operating under a PaX kernel without activated grsecurity acl
CHPAX_CONSERVATIVE_FLAGS="pemsv"

QA_TEXTRELS_amd64="opt/${P}/lib/i386/motif21/libmawt.so
	opt/${P}/lib/i386/libdeploy.so"

src_unpack() {
	if [ ! -r ${DISTDIR}/${At} ]; then
		die "cannot read ${At}. Please check the permission and try again."
	fi

	mkdir bundled-jdk
	cd bundled-jdk
	sh ${DISTDIR}/${At} --accept-license --unpack || die "Failed to unpack"

	cd ..
	bash ${FILESDIR}/construct.sh  bundled-jdk sun-jdk-${PV} ${P} || die "construct.sh failed"

	${S}/bin/java -client -Xshare:dump
}

src_install() {
	local dirs="bin lib man javaws plugin"
	dodir /opt/${P}

	for i in $dirs ; do
		cp -pPR $i ${D}/opt/${P}/ || die "failed to copy"
	done
	dodoc CHANGES README THIRDPARTYLICENSEREADME.txt
	dohtml Welcome.html
	dodir /opt/${P}/share/

	if use nsplugin; then
		local plugin_dir="ns7-gcc29"
		if has_version '>=sys-devel/gcc-3' ; then
			plugin_dir="ns7"
		fi

		install_mozilla_plugin /opt/${P}/plugin/i386/$plugin_dir/libjavaplugin_oji.so
	fi

	# TODO Don't think we still needs these -nichoj
	# create dir for system preferences
	#dodir /opt/${P}/jre/.systemPrefs
	# Create files used as storage for system preferences.
	#touch ${D}/opt/${P}/jre/.systemPrefs/.system.lock
	#chmod 644 ${D}/opt/${P}/jre/.systemPrefs/.system.lock
	#touch ${D}/opt/${P}/jre/.systemPrefs/.systemRootModFile
	#chmod 644 ${D}/opt/${P}/jre/.systemPrefs/.systemRootModFile

	# FIXME figure out how to handle the control pannel conflict with
	# sun-jdk-bin

	# install control panel for Gnome/KDE
#	sed -e "s/INSTALL_DIR\/JRE_NAME_VERSION/\/opt\/${P}\/jre/" \
#		-e "s/\(Name=Java\)/\1 Control Panel ${SLOT}/" \
#		${D}/opt/${P}/plugin/desktop/sun_java.desktop > \
#		${T}/sun_java-${SLOT}.desktop

#	domenu ${T}/sun_java-${SLOT}.desktop

	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	# if chpax is on the target system, set the appropriate PaX flags
	# this will not hurt the binary, it modifies only unused ELF bits
	# but may confuse things like AV scanners and automatic tripwire
	if has_version sys-apps/chpax
	then
		echo
		einfo "setting up conservative PaX flags for java"

		for paxkills in "java"
		do
			chpax -${CHPAX_CONSERVATIVE_FLAGS} /opt/${P}/bin/$paxkills
		done

		# /opt/$VM/jre/bin/java_vm
		chpax -${CHPAX_CONSERVATIVE_FLAGS} /opt/${P}/bin/java_vm

		einfo "you should have seen lots of chpax output above now"
		ewarn "make sure the grsec ACL contains those entries also"
		ewarn "because enabling it will override the chpax setting"
		ewarn "on the physical files - help for PaX and grsecurity"
		ewarn "can be given by #gentoo-hardened + hardened@gentoo.org"
	fi

	if ! use X; then
		local xwarn="virtual/x11 and/or"
	fi

	echo
	ewarn "Some parts of Sun's JDK require ${xwarn} virtual/lpr to be installed."
	ewarn "Be careful which Java libraries you attempt to use."
}
