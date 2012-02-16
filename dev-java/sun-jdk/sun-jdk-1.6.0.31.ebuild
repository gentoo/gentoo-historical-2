# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.6.0.31.ebuild,v 1.1 2012/02/16 10:43:38 sera Exp $

EAPI="4"

inherit java-vm-2 eutils prefix versionator

# This URIs need to be updated when bumping!
JDK_URI="http://www.oracle.com/technetwork/java/javase/downloads/jdk-6u31-download-1501634.html"

MY_PV="$(get_version_component_range 2)u$(get_version_component_range 4)"
S_PV="$(replace_version_separator 3 '_')"

X86_AT="jdk-${MY_PV}-linux-i586.bin"
AMD64_AT="jdk-${MY_PV}-linux-x64.bin"
IA64_AT="jdk-${MY_PV}-linux-ia64.bin"
SOL_X86_AT="jdk-${MY_PV}-solaris-i586.sh"
SOL_AMD64_AT="jdk-${MY_PV}-solaris-x64.sh"
SOL_SPARC_AT="jdk-${MY_PV}-solaris-sparc.sh"
SOL_SPARCv9_AT="jdk-${MY_PV}-solaris-sparcv9.sh"

DESCRIPTION="Oracle's Java SE Development Kit"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
SRC_URI="x86? ( ${X86_AT} )
	amd64? ( ${AMD64_AT} )
	x86-solaris? ( ${SOL_X86_AT} )
	x64-solaris? ( ${SOL_X86_AT} ${SOL_AMD64_AT} )
	sparc-solaris? ( ${SOL_SPARC_AT} )
	sparc64-solaris? ( ${SOL_SPARC_AT} ${SOL_SPARCv9_AT} )"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="1.6"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="X alsa derby doc examples jce kernel_SunOS nsplugin +source"

RESTRICT="fetch strip"
QA_TEXTRELS_x86="
	opt/${P}/jre/lib/i386/client/libjvm.so
	opt/${P}/jre/lib/i386/motif21/libmawt.so
	opt/${P}/jre/lib/i386/server/libjvm.so"

RDEPEND="
	X? (
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libX11
	)
	alsa? ( media-libs/alsa-lib )
	doc? ( dev-java/java-sdk-docs:1.6.0 )
	jce? ( dev-java/sun-jce-bin:1.6 )
	kernel_SunOS? ( app-arch/unzip )
	!prefix? ( sys-libs/glibc )"

S="${WORKDIR}/jdk${S_PV}"

pkg_nofetch() {
	if use x86; then
		AT=${X86_AT}
	elif use amd64; then
		AT=${AMD64_AT}
	elif use ia64; then
		AT=${IA64_AT}
	elif use x86-solaris; then
		AT=${SOL_X86_AT}
	elif use x64-solaris; then
		AT="${SOL_X86_AT} and ${SOL_AMD64_AT}"
	elif use sparc-solaris; then
		AT=${SOL_SPARC_AT}
	elif use sparc64-solaris; then
		AT="${SOL_SPARC_AT} and ${SOL_SPARCv9_AT}"
	fi

	einfo "Due to Oracle no longer providing the distro-friendly DLJ bundles, the package has become fetch restricted again."
	einfo "Alternatives are switching to dev-java/icedtea-bin:6 or the source-based dev-java/icedtea:6"
	einfo ""
	einfo "Please download ${AT} from:"
	einfo "${JDK_URI}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		for i in ${A}; do
			rm -f "${S}"/jre/{LICENSE,README} "${S}"/LICENSE
			# don't die on unzip, it always "fails"
			unzip "${DISTDIR}"/${i}
		done
		for f in $(find "${S}" -name "*.pack") ; do
			"${S}"/bin/unpack200 ${f} ${f%.pack}.jar
			rm ${f}
		done
	else
		sh "${DISTDIR}"/${A} -noregister || die "Failed to unpack"
	fi
}

src_compile() {
	# This needs to be done before CDS - #215225
	java-vm_set-pax-markings "${S}"

	# see bug #207282
	einfo "Creating the Class Data Sharing archives"
	if use x86; then
		bin/java -client -Xshare:dump || die
	fi
	bin/java -server -Xshare:dump || die
}

src_install() {
	# We should not need the ancient plugin for Firefox 2 anymore, plus it has
	# writable executable segments
	if use x86; then
		rm -vf {,jre/}lib/i386/libjavaplugin_oji.so \
			{,jre/}lib/i386/libjavaplugin_nscp*.so
		rm -vrf jre/plugin/i386
	fi
	# Without nsplugin flag, also remove the new plugin
	local arch=${ARCH};
	use x86 && arch=i386;
	if ! use nsplugin; then
		rm -vf {,jre/}lib/${arch}/libnpjp2.so \
			{,jre/}lib/${arch}/libjavaplugin_jni.so
	fi

	dodir /opt/${P}
	cp -pPR bin include jre lib man "${ED}"/opt/${P} || die

	if use derby; then
		cp -pPR db "${ED}"/opt/${P} || die
	fi

	if use examples; then
		cp -pPR demo sample "${ED}"/opt/${P} || die
	fi

	# Remove empty dirs we might have copied
	rmdir -v $(find "${D}" -type d -empty) || die

	dodoc COPYRIGHT
	dohtml README.html

	if use jce; then
		dodir /opt/${P}/jre/lib/security/strong-jce
		mv "${ED}"/opt/${P}/jre/lib/security/US_export_policy.jar \
			"${ED}"/opt/${P}/jre/lib/security/strong-jce || die
		mv "${ED}"/opt/${P}/jre/lib/security/local_policy.jar \
			"${ED}"/opt/${P}/jre/lib/security/strong-jce || die
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/US_export_policy.jar \
			/opt/${P}/jre/lib/security/US_export_policy.jar
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/local_policy.jar \
			/opt/${P}/jre/lib/security/local_policy.jar
	fi

	if use nsplugin; then
		install_mozilla_plugin /opt/${P}/jre/lib/${arch}/libnpjp2.so
	fi

	if use source; then
		cp src.zip "${ED}"/opt/${P} || die
	fi

	# Install desktop file for the Java Control Panel.
	# Using ${PN}-${SLOT} to prevent file collision with jre and or other slots.
	# make_desktop_entry can't be used as ${P} would end up in filename.
	newicon jre/lib/desktop/icons/hicolor/48x48/apps/sun-jcontrol.png \
		sun-jcontrol-${PN}-${SLOT}.png || die
	sed -e "s#Name=.*#Name=Java Control Panel for Oracle JDK ${SLOT} (sun-jdk)#" \
		-e "s#Exec=.*#Exec=/opt/${P}/jre/bin/jcontrol#" \
		-e "s#Icon=.*#Icon=sun-jcontrol-${PN}-${SLOT}.png#" \
		jre/lib/desktop/applications/sun_java.desktop > \
		"${T}"/jcontrol-${PN}-${SLOT}.desktop || die
	domenu "${T}"/jcontrol-${PN}-${SLOT}.desktop

	# bug #56444
	cp "${FILESDIR}"/fontconfig.Gentoo.properties-r1 "${T}"/fontconfig.properties || die
	eprefixify "${T}"/fontconfig.properties
	insinto /opt/${P}/jre/lib/
	doins "${T}"/fontconfig.properties

	set_java_env "${FILESDIR}/${VMHANDLE}.env-r1"
	java-vm_revdep-mask
}
