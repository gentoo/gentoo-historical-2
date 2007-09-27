# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.5.0.13.ebuild,v 1.1 2007/09/27 16:57:21 betelgeuse Exp $

inherit versionator java-vm-2 eutils pax-utils

MY_PV=${PV//./_}

X86_AT="jdk-${MY_PV}-dlj-linux-i586.bin"
AMD64_AT="jdk-${MY_PV}-dlj-linux-amd64.bin"

DESCRIPTION="Sun's J2SE Development Kit, version 1.5"
HOMEPAGE="http://java.sun.com/j2se/1.5.0/"
SRC_URI="x86? ( http://download.java.net/dlj/binaries/${X86_AT} )
		amd64? ( http://download.java.net/dlj/binaries/${AMD64_AT} )"
SLOT="1.5"
LICENSE="dlj-1.1"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip"
IUSE="X alsa doc examples jce nsplugin"

QA_TEXTRELS_x86="opt/${P}/jre/lib/i386/motif21/libmawt.so opt/${P}/jre/lib/i386/libdeploy.so"

DEPEND="
	doc? ( =dev-java/java-sdk-docs-1.5.0* )
	jce? ( =dev-java/sun-jce-bin-1.5.0* )"

RDEPEND="
	sys-libs/glibc
	alsa? ( media-libs/alsa-lib )
	doc? ( =dev-java/java-sdk-docs-1.5.0* )
	X? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXp
			x11-libs/libXt
			x11-libs/libXtst
		)"

S="${WORKDIR}/jdk$(replace_version_separator 3 _)"

JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

src_unpack() {
	if [ ! -r "${DISTDIR}/${A}" ]; then
		die "cannot read ${A}. Please check the permission and try again."
	fi

	sh "${DISTDIR}/${A}" --accept-license --unpack || die "Failed to unpack"
}

src_install() {
	local dirs="bin include jre lib man"

	# Set PaX markings on all JDK/JRE executables to allow code-generation on
	# the heap by the JIT compiler.
	pax-mark m $(list-paxables ${S}{,/jre}/bin/*)

	dodir /opt/${P}

	cp -pPR ${dirs} "${D}/opt/${P}/" || die "failed to copy"
	dodoc COPYRIGHT README.html || die
	dohtml README.html || die

	cp -pP src.zip "${D}/opt/${P}/" || die

	if use examples; then
		cp -pPR demo "${D}/opt/${P}/" || die
		cp -pPR sample "${D}/opt/${P}/" || die
	fi

	if use jce; then
		cd "${D}"/opt/${P}/jre/lib/security || die
		dodir /opt/${P}/jre/lib/security/strong-jce
		mv "${D}"/opt/${P}/jre/lib/security/US_export_policy.jar \
			"${D}"/opt/${P}/jre/lib/security/strong-jce || die
		mv "${D}"/opt/${P}/jre/lib/security/local_policy.jar \
			"${D}"/opt/${P}/jre/lib/security/strong-jce || die
		local jcedir="/opt/sun-jce-bin-1.5.0/jre/lib/security/unlimited-jce/"
		dosym ${jcedir}/US_export_policy.jar \
			/opt/${P}/jre/lib/security/ || die
		dosym ${jcedir}/local_policy.jar \
			/opt/${P}/jre/lib/security/ || die
	fi

	if use nsplugin; then
		local plugin_dir="ns7-gcc29"
		if has_version '>=sys-devel/gcc-3' ; then
			plugin_dir="ns7"
		fi

		if use x86 ; then
			install_mozilla_plugin /opt/${P}/jre/plugin/i386/$plugin_dir/libjavaplugin_oji.so
		else
			eerror "No plugin available for amd64 arch"
		fi
	fi

	# create dir for system preferences
	dodir /opt/${P}/jre/.systemPrefs
	# Create files used as storage for system preferences.
	touch "${D}"/opt/${P}/jre/.systemPrefs/.system.lock
	chmod 644 "${D}"/opt/${P}/jre/.systemPrefs/.system.lock
	touch "${D}"/opt/${P}/jre/.systemPrefs/.systemRootModFile
	chmod 644 "${D}"/opt/${P}/jre/.systemPrefs/.systemRootModFile

	# install control panel for Gnome/KDE
	if [[ -f ${D}/opt/${P}/jre/plugin/desktop/sun_java.desktop ]]; then
		sed -e "s/INSTALL_DIR\/JRE_NAME_VERSION/\/opt\/${P}\/jre/" \
			-e "s/\(Name=Java\)/\1 Control Panel ${SLOT}/" \
			${D}/opt/${P}/jre/plugin/desktop/sun_java.desktop > \
			${T}/sun_java-${SLOT}.desktop \
			|| die "Failed to sed .desktop file"

		domenu ${T}/sun_java-${SLOT}.desktop
	fi

	# bug #56444
	insinto /opt/${P}/jre/lib/
	newins "${FILESDIR}"/fontconfig.Gentoo.properties fontconfig.properties

	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	if ! use X; then
		local xwarn="X11 libraries and/or"
	fi

	echo
	ewarn "Some parts of Sun's JDK require ${xwarn} virtual/lpr to be installed."
	ewarn "Be careful which Java libraries you attempt to use."

	echo
	elog " Be careful: ${P}'s Java compiler uses"
	elog " '-source 1.5' as default. Some keywords such as 'enum'"
	elog " are not valid identifiers any more in that mode,"
	elog " which can cause incompatibility with certain sources."

	echo
	elog "Beginning with 1.5.0.10 the hotspot vm can use epoll"
	elog "The epoll-based implementation of SelectorProvider is not selected by"
	elog "default."
	elog "Use java -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.EPollSelectorProvider"
	elog ""
	elog "Starting with 1.5.0.12 the src.zip and demos are installed to the standard"
	elog "locations."
	elog "See https://bugs.gentoo.org/show_bug.cgi?id=2241 and"
	elog "http://java.sun.com/j2se/1.5.0/docs/tooldocs/linux/jdkfiles.html"
	elog "for more details."
}
