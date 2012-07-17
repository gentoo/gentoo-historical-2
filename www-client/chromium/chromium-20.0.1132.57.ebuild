# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/chromium/chromium-20.0.1132.57.ebuild,v 1.3 2012/07/17 16:21:44 jdhore Exp $

EAPI="4"
PYTHON_DEPEND="2:2.6"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en_GB es es_LA et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt_BR pt_PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh_CN zh_TW"

inherit chromium eutils flag-o-matic multilib \
	pax-utils portability python toolchain-funcs versionator virtualx

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://chromium.org/"
SRC_URI="http://commondatastorage.googleapis.com/chromium-browser-official/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bindist cups gnome gnome-keyring kerberos pulseaudio selinux"

RDEPEND="app-arch/bzip2
	cups? (
		dev-libs/libgcrypt
		>=net-print/cups-1.3.11
	)
	>=dev-lang/v8-3.10.2.1
	dev-libs/dbus-glib
	dev-libs/elfutils
	>=dev-libs/icu-49.1.1-r1
	>=dev-libs/libevent-1.4.13
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	>=dev-libs/nss-3.12.3
	gnome? ( >=gnome-base/gconf-2.24.0 )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.28.2 )
	>=media-libs/alsa-lib-1.0.19
	media-libs/flac
	>=media-libs/libjpeg-turbo-1.2.0-r1
	media-libs/libpng
	>=media-libs/libwebp-0.1.3
	media-libs/speex
	pulseaudio? ( media-sound/pulseaudio )
	sys-fs/udev
	sys-libs/zlib
	x11-libs/gtk+:2
	x11-libs/libXinerama
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	kerberos? ( virtual/krb5 )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	>=dev-lang/nacl-toolchain-newlib-0_p7311
	dev-lang/perl
	dev-lang/yasm
	dev-python/ply
	dev-python/simplejson
	>=dev-util/gperf-3.0.3
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	>=sys-devel/make-3.81-r2
	virtual/pkgconfig
	test? (
		dev-python/pyftpdlib
	)"
RDEPEND+="
	!=www-client/chromium-9999
	x11-misc/xdg-utils
	virtual/ttf-fonts"

if ! has chromium_pkg_die ${EBUILD_DEATH_HOOKS}; then
	EBUILD_DEATH_HOOKS+=" chromium_pkg_die";
fi

pkg_setup() {
	if [[ "${SLOT}" == "0" ]]; then
		CHROMIUM_SUFFIX=""
	else
		CHROMIUM_SUFFIX="-${SLOT}"
	fi
	CHROMIUM_HOME="/usr/$(get_libdir)/chromium-browser${CHROMIUM_SUFFIX}"

	# Make sure the build system will use the right tools, bug #340795.
	tc-export AR CC CXX RANLIB

	# Make sure the build system will use the right python, bug #344367.
	python_set_active_version 2
	python_pkg_setup

	chromium_suid_sandbox_check_kernel_config

	if use bindist; then
		elog "bindist enabled: H.264 video support will be disabled."
	else
		elog "bindist disabled: Resulting binaries may not be legal to re-distribute."
	fi
}

src_prepare() {
	ln -s /usr/$(get_libdir)/nacl-toolchain-newlib \
		native_client/toolchain/linux_x86_newlib || die

	# zlib-1.2.5.1-r1 renames the OF macro in zconf.h, bug 383371.
	sed -i '1i#define OF(x) x' \
		third_party/zlib/contrib/minizip/{ioapi,{,un}zip}.c \
		chrome/common/zip*.cc || die

	epatch "${FILESDIR}/${PN}-svnversion-r0.patch"

	# Backport upstream fix for Gentoo bug #415601.
	epatch "${FILESDIR}/${PN}-unistd-r0.patch"

	# Fix build without tcmalloc. To be upstreamed.
	epatch "${FILESDIR}/${PN}-tcmalloc-r0.patch"

	# Backport a crash fix, bug #420357.
	epatch "${FILESDIR}/${PN}-alignment-r0.patch"

	epatch_user

	# Remove most bundled libraries. Some are still needed.
	find third_party -type f \! -iname '*.gyp*' \
		\! -path 'third_party/WebKit/*' \
		\! -path 'third_party/angle/*' \
		\! -path 'third_party/cacheinvalidation/*' \
		\! -path 'third_party/cld/*' \
		\! -path 'third_party/expat/*' \
		\! -path 'third_party/ffmpeg/*' \
		\! -path 'third_party/flac/flac.h' \
		\! -path 'third_party/gpsd/*' \
		\! -path 'third_party/harfbuzz/*' \
		\! -path 'third_party/hunspell/*' \
		\! -path 'third_party/iccjpeg/*' \
		\! -path 'third_party/jsoncpp/*' \
		\! -path 'third_party/khronos/*' \
		\! -path 'third_party/launchpad_translations/*' \
		\! -path 'third_party/leveldatabase/*' \
		\! -path 'third_party/libjingle/*' \
		\! -path 'third_party/libphonenumber/*' \
		\! -path 'third_party/libsrtp/*' \
		\! -path 'third_party/libusb/*' \
		\! -path 'third_party/libvpx/*' \
		\! -path 'third_party/libxml/chromium/*' \
		\! -path 'third_party/libyuv/*' \
		\! -path 'third_party/lss/*' \
		\! -path 'third_party/mesa/*' \
		\! -path 'third_party/modp_b64/*' \
		\! -path 'third_party/mongoose/*' \
		\! -path 'third_party/npapi/*' \
		\! -path 'third_party/openmax/*' \
		\! -path 'third_party/ots/*' \
		\! -path 'third_party/protobuf/*' \
		\! -path 'third_party/scons-2.0.1/*' \
		\! -path 'third_party/sfntly/*' \
		\! -path 'third_party/skia/*' \
		\! -path 'third_party/smhasher/*' \
		\! -path 'third_party/speex/speex.h' \
		\! -path 'third_party/sqlite/*' \
		\! -path 'third_party/tlslite/*' \
		\! -path 'third_party/undoview/*' \
		\! -path 'third_party/v8-i18n/*' \
		\! -path 'third_party/webdriver/*' \
		\! -path 'third_party/webgl_conformance/*' \
		\! -path 'third_party/webrtc/*' \
		\! -path 'third_party/zlib/contrib/minizip/*' \
		-delete || die

	local v8_bundled="$(chromium_bundled_v8_version)"
	local v8_installed="$(chromium_installed_v8_version)"
	einfo "V8 version: bundled - ${v8_bundled}; installed - ${v8_installed}"

	# Remove bundled v8.
	find v8 -type f \! -iname '*.gyp*' -delete || die

	# The implementation files include v8 headers with full path,
	# like #include "v8/include/v8.h". Make sure the system headers
	# will be used.
	# TODO: find a solution that can be upstreamed.
	rmdir v8/include || die
	ln -s /usr/include v8/include || die

	# Make sure the build system will use the right python, bug #344367.
	# Only convert directories that need it, to save time.
	python_convert_shebangs -q -r 2 build tools
}

src_configure() {
	local myconf=""

	# Never tell the build system to "enable" SSE2, it has a few unexpected
	# additions, bug #336871.
	myconf+=" -Ddisable_sse2=1"

	# Disable tcmalloc, it causes problems with e.g. NVIDIA
	# drivers, bug #413637.
	myconf+=" -Dlinux_use_tcmalloc=0"

	# Make it possible to remove third_party/adobe.
	echo > "${T}/flapper_version.h" || die
	myconf+=" -Dflapper_version_h_file=${T}/flapper_version.h"

	# Use system-provided libraries.
	# TODO: use_system_ffmpeg
	# TODO: use_system_hunspell (upstream changes needed).
	# TODO: use_system_ssl (http://crbug.com/58087).
	# TODO: use_system_sqlite (http://crbug.com/22208).
	# TODO: use_system_vpx
	myconf+="
		-Duse_system_bzip2=1
		-Duse_system_flac=1
		-Duse_system_icu=1
		-Duse_system_libevent=1
		-Duse_system_libjpeg=1
		-Duse_system_libpng=1
		-Duse_system_libwebp=1
		-Duse_system_libxml=1
		-Duse_system_speex=1
		-Duse_system_v8=1
		-Duse_system_xdg_utils=1
		-Duse_system_yasm=1
		-Duse_system_zlib=1"

	# Optional dependencies.
	# TODO: linux_link_kerberos, bug #381289.
	myconf+="
		$(gyp_use cups use_cups)
		$(gyp_use gnome use_gconf)
		$(gyp_use gnome-keyring use_gnome_keyring)
		$(gyp_use gnome-keyring linux_link_gnome_keyring)
		$(gyp_use kerberos use_kerberos)
		$(gyp_use pulseaudio use_pulseaudio)
		$(gyp_use selinux selinux)"

	if ! use selinux; then
		# Enable SUID sandbox.
		myconf+="
			-Dlinux_sandbox_path=${CHROMIUM_HOME}/chrome_sandbox
			-Dlinux_sandbox_chrome_path=${CHROMIUM_HOME}/chrome"
	fi

	# Never use bundled gold binary. Disable gold linker flags for now.
	myconf+="
		-Dlinux_use_gold_binary=0
		-Dlinux_use_gold_flags=0"

	if ! use bindist; then
		# Enable H.624 support in bundled ffmpeg.
		myconf+=" -Dproprietary_codecs=1 -Dffmpeg_branding=Chrome"
	fi

	local myarch="$(tc-arch)"
	if [[ $myarch = amd64 ]] ; then
		myconf+=" -Dtarget_arch=x64"
	elif [[ $myarch = x86 ]] ; then
		myconf+=" -Dtarget_arch=ia32"
	else
		die "Failed to determine target arch, got '$myarch'."
	fi

	# Make sure that -Werror doesn't get added to CFLAGS by the build system.
	# Depending on GCC version the warnings are different and we don't want
	# the build to fail because of that.
	myconf+=" -Dwerror="

	# Avoid CFLAGS problems, bug #352457, bug #390147.
	if ! use custom-cflags; then
		replace-flags "-Os" "-O2"
		strip-flags
	fi

	egyp_chromium ${myconf} || die
}

src_compile() {
	local test_targets
	for x in base cacheinvalidation crypto \
		googleurl gpu media net printing; do
		test_targets+=" ${x}_unittests"
	done

	local make_targets="chrome chromedriver"
	if ! use selinux; then
		make_targets+=" chrome_sandbox"
	fi
	if use test; then
		make_targets+=$test_targets
	fi

	# See bug #410883 for more info about the .host mess.
	emake ${make_targets} BUILDTYPE=Release V=1 \
		CC.host="$(tc-getCC)" CFLAGS.host="${CFLAGS}" \
		CXX.host="$(tc-getCXX)" CXXFLAGS.host="${CXXFLAGS}" \
		LINK.host="$(tc-getCXX)" LDFLAGS.host="${LDFLAGS}" \
		AR.host="$(tc-getAR)" || die

	pax-mark m out/Release/chrome
	if use test; then
		for x in $test_targets; do
			pax-mark m out/Release/${x}
		done
	fi
}

src_test() {
	# For more info see bug #350349.
	local mylocale='en_US.utf8'
	if ! locale -a | grep -q "$mylocale"; then
		eerror "${PN} requires ${mylocale} locale for tests"
		eerror "Please read the following guides for more information:"
		eerror "  http://www.gentoo.org/doc/en/guide-localization.xml"
		eerror "  http://www.gentoo.org/doc/en/utf-8.xml"
		die "locale ${mylocale} is not supported"
	fi

	# For more info see bug #370957.
	if [[ $UID -eq 0 ]]; then
		die "Tests must be run as non-root. Please use FEATURES=userpriv."
	fi

	# ICUStringConversionsTest: bug #350347.
	# MessagePumpLibeventTest: bug #398501.
	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/base_unittests virtualmake \
		'--gtest_filter=-ICUStringConversionsTest.*:MessagePumpLibeventTest.*'

	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/cacheinvalidation_unittests virtualmake
	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/crypto_unittests virtualmake
	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/googleurl_unittests virtualmake
	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/gpu_unittests virtualmake
	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/media_unittests virtualmake

	# NetUtilTest: bug #361885.
	# DnsConfigServiceTest.GetSystemConfig: bug #394883.
	# CertDatabaseNSSTest.ImportServerCert_SelfSigned: bug #399269.
	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/net_unittests virtualmake \
		'--gtest_filter=-NetUtilTest.IDNToUnicode*:NetUtilTest.FormatUrl*:DnsConfigServiceTest.GetSystemConfig:CertDatabaseNSSTest.ImportServerCert_SelfSigned'

	LC_ALL="${mylocale}" VIRTUALX_COMMAND=out/Release/printing_unittests virtualmake
}

src_install() {
	exeinto "${CHROMIUM_HOME}"
	doexe out/Release/chrome || die

	if ! use selinux; then
		doexe out/Release/chrome_sandbox || die
		fperms 4755 "${CHROMIUM_HOME}/chrome_sandbox"
	fi

	doexe out/Release/chromedriver || die

	doexe out/Release/nacl_helper{,_bootstrap} || die
	insinto "${CHROMIUM_HOME}"
	doins out/Release/nacl_irt_*.nexe || die
	doins out/Release/libppGoogleNaClPluginChrome.so || die

	newexe "${FILESDIR}"/chromium-launcher-r2.sh chromium-launcher.sh || die
	if [[ "${CHROMIUM_SUFFIX}" != "" ]]; then
		sed "s:chromium-browser:chromium-browser${CHROMIUM_SUFFIX}:g" \
			-i "${ED}"/"${CHROMIUM_HOME}"/chromium-launcher.sh || die
		sed "s:chromium.desktop:chromium${CHROMIUM_SUFFIX}.desktop:g" \
			-i "${ED}"/"${CHROMIUM_HOME}"/chromium-launcher.sh || die
		sed "s:plugins:plugins --user-data-dir=\${HOME}/.config/chromium${CHROMIUM_SUFFIX}:" \
			-i "${ED}"/"${CHROMIUM_HOME}"/chromium-launcher.sh || die
	fi

	# It is important that we name the target "chromium-browser",
	# xdg-utils expect it; bug #355517.
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium-browser${CHROMIUM_SUFFIX} || die
	# keep the old symlink around for consistency
	dosym "${CHROMIUM_HOME}/chromium-launcher.sh" /usr/bin/chromium${CHROMIUM_SUFFIX} || die

	# Allow users to override command-line options, bug #357629.
	dodir /etc/chromium || die
	insinto /etc/chromium
	newins "${FILESDIR}/chromium.default" "default" || die

	pushd out/Release/locales > /dev/null || die
	chromium_remove_language_paks
	popd

	insinto "${CHROMIUM_HOME}"
	doins out/Release/*.pak || die

	doins -r out/Release/locales || die
	doins -r out/Release/resources || die

	newman out/Release/chrome.1 chromium${CHROMIUM_SUFFIX}.1 || die
	newman out/Release/chrome.1 chromium-browser${CHROMIUM_SUFFIX}.1 || die

	doexe out/Release/libffmpegsumo.so || die

	# Install icons and desktop entry.
	for SIZE in 16 22 24 32 48 64 128 256 ; do
		insinto /usr/share/icons/hicolor/${SIZE}x${SIZE}/apps
		newins chrome/app/theme/chromium/product_logo_${SIZE}.png \
			chromium-browser${CHROMIUM_SUFFIX}.png || die
	done
	local mime_types="text/html;text/xml;application/xhtml+xml;"
	mime_types+="x-scheme-handler/http;x-scheme-handler/https;" # bug #360797
	mime_types+="x-scheme-handler/ftp;" # bug #412185
	mime_types+="x-scheme-handler/mailto;x-scheme-handler/webcal;" # bug #416393
	make_desktop_entry \
		chromium-browser${CHROMIUM_SUFFIX} \
		"Chromium${CHROMIUM_SUFFIX}" \
		chromium-browser${CHROMIUM_SUFFIX} \
		"Network;WebBrowser" \
		"MimeType=${mime_types}\nStartupWMClass=chromium-browser"
	sed -e "/^Exec/s/$/ %U/" -i "${ED}"/usr/share/applications/*.desktop || die

	# Install GNOME default application entry (bug #303100).
	if use gnome; then
		dodir /usr/share/gnome-control-center/default-apps || die
		insinto /usr/share/gnome-control-center/default-apps
		newins "${FILESDIR}"/chromium-browser.xml chromium-browser${CHROMIUM_SUFFIX}.xml || die
		if [[ "${CHROMIUM_SUFFIX}" != "" ]]; then
			sed "s:chromium-browser:chromium-browser${CHROMIUM_SUFFIX}:g" -i \
				"${ED}"/usr/share/gnome-control-center/default-apps/chromium-browser${CHROMIUM_SUFFIX}.xml
		fi
	fi
}
