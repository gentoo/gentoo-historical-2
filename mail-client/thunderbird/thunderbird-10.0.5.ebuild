# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/thunderbird/thunderbird-10.0.5.ebuild,v 1.6 2012/07/19 22:33:25 anarchy Exp $

EAPI="3"
WANT_AUTOCONF="2.1"
MOZ_ESR="1"

# This list can be updated using scripts/get_langs.sh from the mozilla overlay
MOZ_LANGS=(ar ast be bg bn-BD br ca cs da de el en en-GB en-US es-AR es-ES et eu fi
fr fy-NL ga-IE gd gl he hu id is it ja ko lt nb-NO nl nn-NO pa-IN pl pt-BR pt-PT
rm ro ru si sk sl sq sr sv-SE ta-LK tr uk vi zh-CN zh-TW)

# Convert the ebuild version to the upstream mozilla version, used by mozlinguas
MOZ_PV="${PV/_beta/b}"
# ESR releases have slightly version numbers
if [[ ${MOZ_ESR} == 1 ]]; then
	MOZ_PV="${MOZ_PV}esr"
fi
MOZ_P="${PN}-${MOZ_PV}"

# Enigmail version
EMVER="1.3.5"
# Upstream ftp release URI that's used by mozlinguas.eclass
# We don't use the http mirror because it deletes old tarballs.
MOZ_FTP_URI="ftp://ftp.mozilla.org/pub/${PN}/releases/"

inherit flag-o-matic toolchain-funcs mozconfig-3 makeedit multilib autotools pax-utils python check-reqs nsplugins mozlinguas

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="http://www.mozilla.com/en-US/thunderbird/"

KEYWORDS="~alpha amd64 ~arm ~ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
IUSE="bindist gconf +crashreporter +crypt +ipc +lightning +minimal mozdom +webm"

PATCH="thunderbird-10.0-patches-0.1"
PATCHFF="firefox-10.0-patches-0.7"

SRC_URI="${SRC_URI}
	${MOZ_FTP_URI}${MOZ_PV}/source/${MOZ_P}.source.tar.bz2
	crypt? ( http://www.mozilla-enigmail.org/download/source/enigmail-${EMVER}.tar.gz )
	http://dev.gentoo.org/~anarchy/mozilla/patchsets/${PATCH}.tar.xz
	http://dev.gentoo.org/~anarchy/mozilla/patchsets/${PATCHFF}.tar.xz"

ASM_DEPEND=">=dev-lang/yasm-1.1"

RDEPEND=">=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.13.1
	>=dev-libs/nspr-4.8.8
	>=dev-libs/glib-2.26
	crashreporter? ( net-misc/curl )
	gconf? ( >=gnome-base/gconf-1.2.1:2 )
	>=media-libs/libpng-1.5.9[apng]
	>=x11-libs/cairo-1.10
	>=x11-libs/pango-1.14.0
	>=x11-libs/gtk+-2.14
	webm? ( >=media-libs/libvpx-1.0.0
		media-libs/alsa-lib )
	virtual/libffi
	!x11-plugins/enigmail
	system-sqlite? ( >=dev-db/sqlite-3.7.7.1[fts3,secure-delete,unlock-notify,debug=] )
	crypt?  ( || (
		( >=app-crypt/gnupg-2.0
			|| (
				app-crypt/pinentry[gtk]
				app-crypt/pinentry[qt4]
			)
		)
		=app-crypt/gnupg-1.4*
	) )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	webm? ( x86? ( ${ASM_DEPEND} )
		amd64? ( ${ASM_DEPEND} ) )"

if [[ ${MOZ_ESR} == 1 ]]; then
	S="${WORKDIR}/comm-esr${PV%%.*}"
else
	S="${WORKDIR}/comm-release"
fi

pkg_setup() {
	moz_pkgsetup

	export MOZILLA_DIR="${S}/mozilla"

	if ! use bindist ; then
		elog "You are enabling official branding. You may not redistribute this build"
		elog "to any users on your network or the internet. Doing so puts yourself into"
		elog "a legal problem with Mozilla Foundation"
		elog "You can disable it by emerging ${PN} _with_ the bindist USE-flag"
		elog
	fi

	# Ensure we have enough disk space to compile
	CHECKREQS_DISK_BUILD="4G"
	check-reqs_pkg_setup
}

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack
}

src_prepare() {
	# Apply our Thunderbird patchset
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}/thunderbird"

	# Apply our patchset from firefox to thunderbird as well
	pushd "${S}"/mozilla &>/dev/null || die
	EPATCH_EXCLUDE="6012_fix_shlibsign.patch 6013_fix_abort_declaration.patch" \
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}/firefox"
	popd &>/dev/null || die

	if use crypt ; then
		mv "${WORKDIR}"/enigmail "${S}"/mailnews/extensions/enigmail
		cd "${S}"
	fi

	#Fix compilation with curl-7.21.7 bug 376027
	sed -e '/#include <curl\/types.h>/d'  \
		-i "${S}"/mozilla/toolkit/crashreporter/google-breakpad/src/common/linux/http_upload.cc \
		-i "${S}"/mozilla/toolkit/crashreporter/google-breakpad/src/common/linux/libcurl_wrapper.cc \
		-i "${S}"/mozilla/config/system-headers \
		-i "${S}"/mozilla/js/src/config/system-headers || die "Sed failed"

	# Shell scripts sometimes contain DOS line endings; bug 391889
	grep -rlZ --include="*.sh" $'\r$' . |
	while read -r -d $'\0' file ; do
		einfo edos2unix "${file}"
		edos2unix "${file}"
	done

	# Allow user to apply any additional patches without modifing ebuild
	epatch_user

	eautoreconf
	cd "${S}"/mozilla
	eautoconf
}

src_configure() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	MEXTENSIONS="default"

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --with-default-mozilla-five-home="${EPREFIX}${MOZILLA_FIVE_HOME}"
	mozconfig_annotate '' --with-user-appdir=.thunderbird
	mozconfig_annotate '' --with-system-png
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate '' --target="${CTARGET:-${CHOST}}"

	# Use enable features
	mozconfig_use_enable lightning calendar
	mozconfig_use_enable gconf
	mozconfig_use_with webm system-libvpx "${EPREFIX}"/usr

	# Bug #72667
	if use mozdom; then
		MEXTENSIONS="${MEXTENSIONS},inspector"
	fi

	# Use an objdir to keep things organized.
	echo "mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/tbird" >> "${S}"/.mozconfig

	# Finalize and report settings
	mozconfig_final

	####################################
	#
	#  Configure and build
	#
	####################################

	# Disable no-print-directory
	MAKEOPTS=${MAKEOPTS/--no-print-directory/}

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	elif [[ $(gcc-major-version) -gt 4 || $(gcc-minor-version) -gt 3 ]]; then
		if use amd64 || use x86; then
			append-flags -mno-avx
		fi
	fi
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	MOZ_MAKE_FLAGS="${MAKEOPTS}" \
	emake -f client.mk || die

	# Only build enigmail extension if crypt enabled.
	if use crypt ; then
		cd "${S}"/mailnews/extensions/enigmail || die
		./makemake -r 2&> /dev/null
		cd "${S}"/tbird/mailnews/extensions/enigmail
		emake || die "make enigmail failed"
		emake xpi || die "make enigmail xpi failed"
	fi
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	declare emid
	local obj_dir="tbird"
	cd "${S}/${obj_dir}"

	# Copy our preference before omnijar is created.
	cp "${FILESDIR}"/thunderbird-gentoo-default-prefs-1.js-1 \
		"${S}/${obj_dir}/mozilla/dist/bin/defaults/pref/all-gentoo.js" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${S}"/${obj_dir}/mozilla/dist/bin/xpcshell

	emake DESTDIR="${D}" install || die "emake install failed"

	# Install language packs
	mozlinguas_src_install

	if ! use bindist; then
		newicon "${S}"/other-licenses/branding/thunderbird/content/icon48.png thunderbird-icon.png
		domenu "${FILESDIR}"/icon/${PN}.desktop
	else
		newicon "${S}"/mail/branding/aurora/content/icon48.png thunderbird-icon-unbranded.png
		newmenu "${FILESDIR}"/icon/${PN}-unbranded.desktop \
			${PN}.desktop

		sed -i -e "s:Mozilla\ Thunderbird:Lanikai:g" \
			"${ED}"/usr/share/applications/${PN}.desktop
	fi

	if use crypt ; then
		cd "${T}" || die
		unzip "${S}"/${obj_dir}/mozilla/dist/bin/enigmail*.xpi install.rdf || die
		emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' install.rdf)

		dodir ${MOZILLA_FIVE_HOME}/extensions/${emid} || die
		cd "${D}"${MOZILLA_FIVE_HOME}/extensions/${emid} || die
		unzip "${S}"/${obj_dir}/mozilla/dist/bin/enigmail*.xpi || die
	fi

	if use lightning ; then
		emid="{a62ef8ec-5fdc-40c2-873c-223b8a6925cc}"
		dodir ${MOZILLA_FIVE_HOME}/extensions/${emid}
		cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid}
		unzip "${S}"/${obj_dir}/mozilla/dist/xpi-stage/gdata-provider.xpi

		emid="calendar-timezones@mozilla.org"
		dodir ${MOZILLA_FIVE_HOME}/extensions/${emid}
		cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid}
		unzip "${S}"/${obj_dir}/mozilla/dist/xpi-stage/calendar-timezones.xpi

		emid="{e2fda1a4-762b-4020-b5ad-a41df1933103}"
		dodir ${MOZILLA_FIVE_HOME}/extensions/${emid}
		cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid}
		unzip "${S}"/${obj_dir}/mozilla/dist/xpi-stage/lightning.xpi

		# Fix mimetype so it shows up as a calendar application in GNOME 3
		# This requires that the .desktop file was already installed earlier
		sed -e "s:^\(MimeType=\):\1text/calendar;:" \
			-e "s:^\(Categories=\):\1Calendar;:" \
			-i "${ED}"/usr/share/applications/${PN}.desktop
	fi

	pax-mark m "${ED}"/${MOZILLA_FIVE_HOME}/thunderbird-bin

	share_plugins_dir

	if use minimal; then
		rm -rf "${ED}"/usr/include "${ED}${MOZILLA_FIVE_HOME}"/{idl,include,lib,sdk} || \
			die "Failed to remove sdk and headers"
	fi
}

pkg_postinst() {
	elog
	elog "If you are experience problems with plugins please issue the"
	elog "following command : rm \${HOME}/.thunderbird/*/extensions.sqlite ,"
	elog "then restart thunderbird"
}
