# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jre-bin/sun-jre-bin-1.5.0.10.ebuild,v 1.2 2007/01/16 17:56:32 opfer Exp $

inherit pax-utils eutils java-vm-2

MY_PVL=${PV%.*}_${PV##*.}
MY_PVA=${PV//./_}
#S="${WORKDIR}/jdk${MY_PVL}"

X86_AT="jdk-${MY_PVA}-dlj-linux-i586.bin"
AMD64_AT="jdk-${MY_PVA}-dlj-linux-amd64.bin"
if use x86; then
	At=${X86_AT}
elif use amd64; then
	At=${AMD64_AT}
fi
DESCRIPTION="Sun's J2SE Development Kit, version ${PV}"
HOMEPAGE="http://java.sun.com/j2se/1.5.0/"
SRC_URI="x86? ( http://download.java.net/dlj/binaries/${X86_AT} )
		amd64? ( http://download.java.net/dlj/binaries/${AMD64_AT} )"
SLOT="1.5"
LICENSE="dlj-1.1"
KEYWORDS="-* ~amd64 x86"
RESTRICT="nostrip"
IUSE="X alsa nsplugin"

RDEPEND="
	sys-libs/glibc
	alsa? ( media-libs/alsa-lib )
	X? ( || ( ( x11-libs/libX11
				x11-libs/libXext
				x11-libs/libXi
				x11-libs/libXp
				x11-libs/libXt
				x11-libs/libXtst
			  )
				virtual/x11
			)
		)"

DEPEND=""

JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

PACKED_JARS="lib/rt.jar lib/jsse.jar lib/charsets.jar lib/ext/localedata.jar lib/plugin.jar lib/javaws.jar lib/deploy.jar"

QA_TEXTRELS_x86="opt/${P}/lib/i386/motif21/libmawt.so
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
}

src_install() {
	local dirs="bin lib man"

	# Set PaX markings on all JDK/JRE executables to allow code-generation on
	# the heap by the JIT compiler.
	pax-mark m $(list-paxables ${S}/bin/*)

	# only X86 has the plugin and javaws
	use x86 && dirs="${dirs} javaws plugin"
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

		if use x86 ; then
			install_mozilla_plugin /opt/${P}/plugin/i386/$plugin_dir/libjavaplugin_oji.so
		else
			eerror "No plugin available for amd64 arch"
		fi
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

	# bug #56444
	insinto /opt/${P}/lib/
	newins "${FILESDIR}"/fontconfig.Gentoo.properties fontconfig.properties

	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	if ! use X; then
		local xwarn="virtual/x11 and/or"
	fi

	echo
	ewarn "Some parts of Sun's JDK require ${xwarn} virtual/lpr to be installed."
	ewarn "Be careful which Java libraries you attempt to use."

	echo
	elog "Beginning with 1.5.0.10 the hotspot vm can use epoll"
	elog "The epoll-based implementation of SelectorProvider is not selected by"
	elog "default."
	elog "Use java -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.EPollSelectorProvider"
}
