# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.6.0.34.ebuild,v 1.2 2012/08/31 22:01:10 ago Exp $

EAPI="4"

inherit java-vm-2 eutils prefix versionator

# This URIs need to be updated when bumping!
JDK_URI="http://www.oracle.com/technetwork/java/javase/downloads/jdk6-downloads-1637591.html"

MY_PV="$(get_version_component_range 2)u$(get_version_component_range 4)"
S_PV="$(replace_version_separator 3 '_')"

X86_AT="jdk-${MY_PV}-linux-i586.bin"
AMD64_AT="jdk-${MY_PV}-linux-x64.bin"
#IA64_AT="jdk-${MY_PV}-linux-ia64.bin"
SOL_X86_AT="jdk-${MY_PV}-solaris-i586.sh"
SOL_AMD64_AT="jdk-${MY_PV}-solaris-x64.sh"
SOL_SPARC_AT="jdk-${MY_PV}-solaris-sparc.sh"
SOL_SPARCv9_AT="jdk-${MY_PV}-solaris-sparcv9.sh"

X86_DEMOS="jdk-${MY_PV}-linux-i586-demos.tar.gz"
AMD64_DEMOS="jdk-${MY_PV}-linux-x64-demos.tar.gz"
#IA64_DEMOS="jdk-${MY_PV}-linux-ia64-demos.tar.gz"
SOL_X86_DEMOS="jdk-${MY_PV}-solaris-i586-demos.tar.Z"
SOL_AMD64_DEMOS="jdk-${MY_PV}-solaris-x64-demos.tar.Z"
SOL_SPARC_DEMOS="jdk-${MY_PV}-solaris-sparc-demos.tar.Z"
SOL_SPARCv9_DEMOS="jdk-${MY_PV}-solaris-sparcv9-demos.tar.Z"

DESCRIPTION="Oracle's Java SE Development Kit"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
SRC_URI="
	x86? ( ${X86_AT}
		examples? ( ${X86_DEMOS} ) )
	amd64? ( ${AMD64_AT} )
	x86-solaris? ( ${SOL_X86_AT}
		examples? ( ${SOL_X86_DEMOS} ) )
	x64-solaris? ( ${SOL_X86_AT} ${SOL_AMD64_AT}
		examples? ( ${SOL_X86_DEMOS} ${SOL_AMD64_DEMOS} ) )
	sparc-solaris? ( ${SOL_SPARC_AT}
		examples? ( ${SOL_SPARC_DEMOS} ) )
	sparc64-solaris? ( ${SOL_SPARC_AT} ${SOL_SPARCv9_AT}
		examples? ( ${SOL_SPARC_DEMOS} ${SOL_SPARCv9_DEMOS} ) )"
#		examples? ( ${AMD64_DEMOS} ) )
#	ia64? ( ${IA64_AT}
#		examples? ( ${IA64_DEMOS} ) )

LICENSE="Oracle-BCLA-JavaSE"
SLOT="1.6"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="X alsa derby doc examples jce kernel_SunOS nsplugin pax_kernel +source"

RESTRICT="fetch strip"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXt
		x11-libs/libXtst
	)
	alsa? ( media-libs/alsa-lib )
	doc? ( dev-java/java-sdk-docs:1.6.0 )
	jce? ( dev-java/sun-jce-bin:1.6 )
	kernel_SunOS? ( app-arch/unzip )
	!prefix? ( sys-libs/glibc )"
# scanelf won't create a PaX header, so depend on paxctl to avoid fallback
# marking. #427642
DEPEND="
	pax_kernel? ( sys-apps/paxctl )"

S="${WORKDIR}/jdk${S_PV}"

_set_at() {
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
}

_set_demos() {
	if use x86; then
		DEMOS=${X86_DEMOS}
	elif use amd64; then
		DEMOS=${AMD64_DEMOS}
	elif use ia64; then
		DEMOS=${IA64_DEMOS}
	elif use x86-solaris; then
		DEMOS=${SOL_X86_DEMOS}
	elif use x64-solaris; then
		DEMOS="${SOL_X86_DEMOS} and ${SOL_AMD64_DEMOS}"
	elif use sparc-solaris; then
		DEMOS=${SOL_SPARC_AT}
	elif use sparc64-solaris; then
		DEMOS="${SOL_SPARC_AT_DEMOS} and ${SOL_SPARCv9_DEMOS}"
	fi
}

pkg_nofetch() {
	_set_at
	_set_demos

	einfo "Due to Oracle no longer providing the distro-friendly DLJ bundles, the package"
	einfo "has become fetch restricted again. Alternatives are switching to"
	einfo "dev-java/icedtea-bin:6 or the source-based dev-java/icedtea:6"
	einfo ""
	einfo "Please download ${AT} from:"
	einfo "${JDK_URI}"
	einfo "and move it to ${DISTDIR}"

	if use examples; then
		einfo ""
		einfo "Also download ${DEMOS} from:"
		einfo "${JDK_URI}"
		einfo "and move it to ${DISTDIR}"
	fi
}

_sol_src_unpack() {
	for i in ${AT}; do
		[[ ${i} == "and" ]] && continue
		rm -f "${S}"/jre/{LICENSE,README} "${S}"/LICENSE
		# don't die on unzip, it always "fails"
		unzip "${DISTDIR}"/${i}
	done
	for f in $(find "${S}" -name "*.pack") ; do
		"${S}"/bin/unpack200 ${f} ${f%.pack}.jar
		rm ${f}
	done
	if use examples ; then
		for i in ${DEMOS}; do
			[[ ${i} == "and" ]] && continue
			use examples && unpack ${i}
		done
		mv "${WORKDIR}"/SUNWj6dmo/reloc/jdk/instances/jdk1.6.0/{demo,sample} \
			"${S}"/ || die
	fi
}

src_unpack() {
	[[ ${PV} != 1.6.0.34 ]] && die "Check if amd64 examples distfile is available again before bumping. Chang SRC_URI and 'use examples' in src_{unpack,install}."
	_set_at
	_set_demos
	if use kernel_SunOS; then
		_sol_src_unpack
	else
		sh "${DISTDIR}"/${AT} -noregister || die "Failed to unpack"
		use examples && ! use amd64 && unpack ${DEMOS}
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
	# limit heap size for large memory on x86 #405239
	# this is a workaround and shouldn't be needed.
	bin/java -server -Xmx64m -Xshare:dump || die
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest}"

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

	dodir "${dest}"
	cp -pPR bin include jre lib man "${ddest}" || die

	if use derby; then
		cp -pPR db "${ddest}" || die
	fi

	if use examples; then
		if use amd64; then
			ewarn "examples are not available in this version for amd64 due to upstream error (zero-byte distfile)"
		else
			cp -pPR demo sample "${ddest}" || die
		fi
	fi

	# Remove empty dirs we might have copied
	find "${D}" -type d -empty -exec rmdir -v {} + || die

	dodoc COPYRIGHT
	dohtml README.html

	if use jce; then
		dodir "${dest}"/jre/lib/security/strong-jce
		mv "${ddest}"/jre/lib/security/US_export_policy.jar \
			"${ddest}"/jre/lib/security/strong-jce || die
		mv "${ddest}"/jre/lib/security/local_policy.jar \
			"${ddest}"/jre/lib/security/strong-jce || die
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/US_export_policy.jar \
			"${dest}"/jre/lib/security/US_export_policy.jar
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/local_policy.jar \
			"${dest}"/jre/lib/security/local_policy.jar
	fi

	if use nsplugin; then
		install_mozilla_plugin "${dest}"/jre/lib/${arch}/libnpjp2.so
	fi

	if use source; then
		cp src.zip "${ddest}" || die
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

	# http://docs.oracle.com/javase/6/docs/technotes/guides/intl/fontconfig.html
	rm "${ddest}"/jre/lib/fontconfig.* || die
	cp "${FILESDIR}"/fontconfig.Gentoo.properties-r1 "${T}"/fontconfig.properties || die
	eprefixify "${T}"/fontconfig.properties
	insinto "${dest}"/jre/lib/
	doins "${T}"/fontconfig.properties

	set_java_env "${FILESDIR}/${VMHANDLE}.env-r1"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random
}

QA_TEXTRELS_x86="
	opt/${P}/jre/lib/i386/client/libjvm.so
	opt/${P}/jre/lib/i386/motif21/libmawt.so
	opt/${P}/jre/lib/i386/server/libjvm.so"
QA_FLAGS_IGNORED="
	/opt/${P}/bin/appletviewer
	/opt/${P}/bin/apt
	/opt/${P}/bin/extcheck
	/opt/${P}/bin/idlj
	/opt/${P}/bin/jar
	/opt/${P}/bin/jarsigner
	/opt/${P}/bin/java
	/opt/${P}/bin/javac
	/opt/${P}/bin/javadoc
	/opt/${P}/bin/javah
	/opt/${P}/bin/javap
	/opt/${P}/bin/javaws
	/opt/${P}/bin/jconsole
	/opt/${P}/bin/jdb
	/opt/${P}/bin/jhat
	/opt/${P}/bin/jinfo
	/opt/${P}/bin/jmap
	/opt/${P}/bin/jps
	/opt/${P}/bin/jrunscript
	/opt/${P}/bin/jsadebugd
	/opt/${P}/bin/jstack
	/opt/${P}/bin/jstat
	/opt/${P}/bin/jstatd
	/opt/${P}/bin/keytool
	/opt/${P}/bin/native2ascii
	/opt/${P}/bin/orbd
	/opt/${P}/bin/pack200
	/opt/${P}/bin/policytool
	/opt/${P}/bin/rmic
	/opt/${P}/bin/rmid
	/opt/${P}/bin/rmiregistry
	/opt/${P}/bin/schemagen
	/opt/${P}/bin/serialver
	/opt/${P}/bin/servertool
	/opt/${P}/bin/tnameserv
	/opt/${P}/bin/unpack200
	/opt/${P}/bin/wsgen
	/opt/${P}/bin/wsimport
	/opt/${P}/bin/xjc
	/opt/${P}/demo/jvmti/gctest/lib/libgctest.so
	/opt/${P}/demo/jvmti/heapTracker/lib/libheapTracker.so
	/opt/${P}/demo/jvmti/heapViewer/lib/libheapViewer.so
	/opt/${P}/demo/jvmti/minst/lib/libminst.so
	/opt/${P}/demo/jvmti/mtrace/lib/libmtrace.so
	/opt/${P}/demo/jvmti/versionCheck/lib/libversionCheck.so
	/opt/${P}/demo/jvmti/waiters/lib/libwaiters.so
	/opt/${P}/jre/bin/java
	/opt/${P}/jre/bin/java_vm
	/opt/${P}/jre/bin/javaws
	/opt/${P}/jre/bin/keytool
	/opt/${P}/jre/bin/orbd
	/opt/${P}/jre/bin/pack200
	/opt/${P}/jre/bin/policytool
	/opt/${P}/jre/bin/rmid
	/opt/${P}/jre/bin/rmiregistry
	/opt/${P}/jre/bin/servertool
	/opt/${P}/jre/bin/tnameserv
	/opt/${P}/jre/bin/unpack200
	/opt/${P}/jre/lib/jexec
	/opt/${P}/lib/jexec
	/opt/${P}/lib/visualvm/profiler/lib/deployed/jdk15/linux-amd64/libprofilerinterface.so
	/opt/${P}/lib/visualvm/profiler/lib/deployed/jdk16/linux-amd64/libprofilerinterface.so"
for java_system_arch in amd64 i386; do
	QA_FLAGS_IGNORED+="
		/opt/${P}/jre/lib/${java_system_arch}/headless/libmawt.so
		/opt/${P}/jre/lib/${java_system_arch}/jli/libjli.so
		/opt/${P}/jre/lib/${java_system_arch}/libattach.so
		/opt/${P}/jre/lib/${java_system_arch}/libawt.so
		/opt/${P}/jre/lib/${java_system_arch}/libcmm.so
		/opt/${P}/jre/lib/${java_system_arch}/libdcpr.so
		/opt/${P}/jre/lib/${java_system_arch}/libdeploy.so
		/opt/${P}/jre/lib/${java_system_arch}/libdt_socket.so
		/opt/${P}/jre/lib/${java_system_arch}/libfontmanager.so
		/opt/${P}/jre/lib/${java_system_arch}/libhprof.so
		/opt/${P}/jre/lib/${java_system_arch}/libinstrument.so
		/opt/${P}/jre/lib/${java_system_arch}/libioser12.so
		/opt/${P}/jre/lib/${java_system_arch}/libj2gss.so
		/opt/${P}/jre/lib/${java_system_arch}/libj2pcsc.so
		/opt/${P}/jre/lib/${java_system_arch}/libj2pkcs11.so
		/opt/${P}/jre/lib/${java_system_arch}/libjaas_unix.so
		/opt/${P}/jre/lib/${java_system_arch}/libjava_crw_demo.so
		/opt/${P}/jre/lib/${java_system_arch}/libjavaplugin_jni.so
		/opt/${P}/jre/lib/${java_system_arch}/libjava.so
		/opt/${P}/jre/lib/${java_system_arch}/libjawt.so
		/opt/${P}/jre/lib/${java_system_arch}/libJdbcOdbc.so
		/opt/${P}/jre/lib/${java_system_arch}/libjdwp.so
		/opt/${P}/jre/lib/${java_system_arch}/libjpeg.so
		/opt/${P}/jre/lib/${java_system_arch}/libjsig.so
		/opt/${P}/jre/lib/${java_system_arch}/libjsoundalsa.so
		/opt/${P}/jre/lib/${java_system_arch}/libjsound.so
		/opt/${P}/jre/lib/${java_system_arch}/libmanagement.so
		/opt/${P}/jre/lib/${java_system_arch}/libmlib_image.so
		/opt/${P}/jre/lib/${java_system_arch}/libnative_chmod_g.so
		/opt/${P}/jre/lib/${java_system_arch}/libnative_chmod.so
		/opt/${P}/jre/lib/${java_system_arch}/libnet.so
		/opt/${P}/jre/lib/${java_system_arch}/libnio.so
		/opt/${P}/jre/lib/${java_system_arch}/libnpjp2.so
		/opt/${P}/jre/lib/${java_system_arch}/libnpt.so
		/opt/${P}/jre/lib/${java_system_arch}/librmi.so
		/opt/${P}/jre/lib/${java_system_arch}/libsaproc.so
		/opt/${P}/jre/lib/${java_system_arch}/libsplashscreen.so
		/opt/${P}/jre/lib/${java_system_arch}/libunpack.so
		/opt/${P}/jre/lib/${java_system_arch}/libverify.so
		/opt/${P}/jre/lib/${java_system_arch}/libzip.so
		/opt/${P}/jre/lib/${java_system_arch}/motif21/libmawt.so
		/opt/${P}/jre/lib/${java_system_arch}/native_threads/libhpi.so
		/opt/${P}/jre/lib/${java_system_arch}/server/libjvm.so
		/opt/${P}/jre/lib/${java_system_arch}/xawt/libmawt.so"
done
