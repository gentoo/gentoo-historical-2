# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/seamonkey/seamonkey-2.2-r2.ebuild,v 1.2 2011/08/10 07:27:18 polynomial-c Exp $

EAPI="3"
WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils mozconfig-3 makeedit multilib fdo-mime autotools mozextension python

PATCH="${PN}-2.2-patches-01"
EMVER="1.2.1"

LANGS="ca cs de en en-GB en-US es-AR es-ES fi fr hu it ja lt nb-NO nl pl pt-PT ru sk sv-SE tr"
NOSHORTLANGS="en-GB en-US es-AR"

MY_PV="${PV/_pre*}"
MY_PV="${MY_PV/_alpha/a}"
MY_PV="${MY_PV/_beta/b}"
MY_PV="${MY_PV/_rc/rc}"
MY_P="${PN}-${MY_PV}"

# release versions usually have language packs. So be careful with changing this.
HAS_LANGS="true"
LANGPACK_PREFIX="${MY_P}."
LANGPACK_SUFFIX=".langpack"
if [[ ${PV} == *_pre* ]] ; then
	# pre-releases. No need for arch teams to change KEYWORDS here.

	REL_URI="ftp://ftp.mozilla.org/pub/mozilla.org/${PN}/nightly/${MY_PV}-candidates/build${PV##*_pre}"
	#LANG_URI="${REL_URI}/langpack"
	LANG_URI="${REL_URI}/linux-i686/xpi"
	LANGPACK_PREFIX=""
	LANGPACK_SUFFIX=""
	#KEYWORDS=""
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
	#HAS_LANGS="false"
else
	# This is where arch teams should change the KEYWORDS.

	REL_URI="http://releases.mozilla.org/pub/mozilla.org/${PN}/releases/${MY_PV}"
	LANG_URI="${REL_URI}/langpack"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
	[[ ${PV} == *alpha* ]] && HAS_LANGS="false"
fi

DESCRIPTION="Seamonkey Web Browser"
HOMEPAGE="http://www.seamonkey-project.org"

SLOT="0"
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
IUSE="+alsa +chatzilla +crypt +methodjit +roaming system-sqlite +webm"

SRC_URI="${REL_URI}/source/${MY_P}.source.tar.bz2 -> ${P}.source.tar.bz2
	http://dev.gentoo.org/~polynomial-c/mozilla/patchsets/${PATCH}.tar.xz
	crypt? ( http://www.mozilla-enigmail.org/download/source/enigmail-${EMVER}.tar.gz )"

if ${HAS_LANGS} ; then
	for X in ${LANGS} ; do
		if [ "${X}" != "en" ] ; then
			SRC_URI="${SRC_URI}
				linguas_${X/-/_}? ( ${LANG_URI}/${LANGPACK_PREFIX}${X}${LANGPACK_SUFFIX}.xpi -> ${P}-${X}.xpi )"
		fi
		IUSE="${IUSE} linguas_${X/-/_}"
		# english is handled internally
		if [ "${#X}" == 5 ] && ! has ${X} ${NOSHORTLANGS}; then
			#if [ "${X}" != "en-US" ]; then
				SRC_URI="${SRC_URI}
					linguas_${X%%-*}? ( ${LANG_URI}/${LANGPACK_PREFIX}${X}${LANGPACK_SUFFIX}.xpi -> ${P}-${X}.xpi )"
			#fi
			IUSE="${IUSE} linguas_${X%%-*}"
		fi
	done
fi

ASM_DEPEND=">=dev-lang/yasm-1.1"

# Mesa 7.10 needed for WebGL + bugfixes
RDEPEND=">=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.12.9
	>=dev-libs/nspr-4.8.7
	>=dev-libs/glib-2.26
	>=media-libs/mesa-7.10
	>=media-libs/libpng-1.4.1[apng]
	dev-libs/libffi
	system-sqlite? ( >=dev-db/sqlite-3.7.4[fts3,secure-delete,unlock-notify,debug=] )
	crypt? ( >=app-crypt/gnupg-1.4 )
	webm? ( media-libs/libvpx
		media-libs/alsa-lib )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	webm? ( amd64? ( ${ASM_DEPEND} )
		x86? ( ${ASM_DEPEND} ) )"

S="${WORKDIR}/comm-release"

linguas() {
	local LANG SLANG
	for LANG in ${LINGUAS}; do
		if has ${LANG} en en_US; then
			has en ${linguas} || linguas="${linguas:+"${linguas} "}en"
			continue
		elif has ${LANG} ${LANGS//-/_}; then
			has ${LANG//_/-} ${linguas} || linguas="${linguas:+"${linguas} "}${LANG//_/-}"
			continue
		elif [[ " ${LANGS} " == *" ${LANG}-"* ]]; then
			for X in ${LANGS}; do
				if [[ "${X}" == "${LANG}-"* ]] && \
					[[ " ${NOSHORTLANGS} " != *" ${X} "* ]]; then
					has ${X} ${linguas} || linguas="${linguas:+"${linguas} "}${X}"
					continue 2
				fi
			done
		fi
		ewarn "Sorry, but ${PN} does not support the ${LANG} LINGUA"
	done
}

src_unpack() {
	unpack ${A}

	if ${HAS_LANGS} ; then
		linguas
		for X in ${linguas}; do
			# FIXME: Add support for unpacking xpis to portage
			[[ ${X} != "en" ]] && xpi_unpack "${P}-${X}.xpi"
		done
		if [[ ${linguas} != "" && ${linguas} != "en" ]]; then
			einfo "Selected language packs (first will be default): ${linguas}"
		fi
	fi
}

pkg_setup() {
	if [[ ${PV} == *_pre* ]] ; then
		ewarn "You're using an unofficial release of ${PN}. Don't file any bug in"
		ewarn "Gentoo's Bugtracker against this package in case it breaks for you."
		ewarn "Those belong to upstream: https://bugzilla.mozilla.org"
	fi

	moz_pkgsetup

	if ! use methodjit ; then
		einfo
		ewarn "You are disabling the method-based JIT in JägerMonkey."
		ewarn "This will greatly slowdown JavaScript in ${PN}!"
	fi
}

src_prepare() {
	# Apply our patches
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}/patch"

	epatch "${FILESDIR}"/${PN}-2.1b3-restore-tabbar-scrolling-from-2.1b2.diff \
		"${FILESDIR}"/${PN}-2.2-curl7217-includes-fix.patch

	# mailnews patches go here
	pushd "${S}"/mailnews &>/dev/null || die
	epatch "${FILESDIR}"/${PN}-2.2-fix-dates-in-mail-printing.patch
	popd &>/dev/null || die

	# Allow user to apply any additional patches without modifing ebuild
	epatch_user

	if use crypt ; then
		mv "${WORKDIR}"/enigmail "${S}"/mailnews/extensions/enigmail
		cd "${S}"/mailnews/extensions/enigmail || die
		./makemake -r 2&>/dev/null
		sed -e 's:@srcdir@:${S}/mailnews/extensions/enigmail:' \
			-i Makefile.in || die
		cd "${S}"
	fi

	#Ensure we disable javaxpcom by default to prevent configure breakage
	sed -i -e s:MOZ_JAVAXPCOM\=1::g "${S}"/mozilla/xulrunner/confvars.sh \
		|| die "sed javaxpcom"

	# Disable gnomevfs extension
	sed -i -e "s:gnomevfs::" "${S}/"suite/confvars.sh \
		|| die "Failed to remove gnomevfs extension"

	eautoreconf
	cd "${S}"/mozilla || die
	eautoreconf
	cd "${S}"/mozilla/js/src || die
	eautoreconf
}

src_configure() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	MEXTENSIONS=""

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	if ! use chatzilla ; then
		MEXTENSIONS="${MEXTENSIONS},-irc"
	fi
	if ! use roaming ; then
		MEXTENSIONS="${MEXTENSIONS},-sroaming"
	fi

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --disable-gconf
	mozconfig_annotate '' --enable-jsd
	mozconfig_annotate '' --enable-canvas
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}

	mozconfig_use_enable system-sqlite
	mozconfig_use_enable methodjit

	if use crypt ; then
		mozconfig_annotate "mail crypt" --enable-chrome-format=jar
	fi

	mozconfig_annotate '' --with-system-png

	# Finalize and report settings
	mozconfig_final

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	elif [[ $(gcc-major-version) -gt 4 || $(gcc-minor-version) -gt 3 ]]; then
		if use amd64 || use x86; then
			append-flags -mno-avx
		fi
	fi

	####################################
	#
	#  Configure and build
	#
	####################################

	# Work around breakage in makeopts with --no-print-directory
	MAKEOPTS="${MAKEOPTS/--no-print-directory/}"

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" PYTHON="$(PYTHON)" econf
}

src_compile() {
	emake || die

	# Only build enigmail extension if conditions are met.
	if use crypt ; then
		emake -C "${S}"/mailnews/extensions/enigmail || die "make enigmail failed"
		emake -j1 -C "${S}"/mailnews/extensions/enigmail xpi || die "make enigmail xpi failed"
	fi
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	declare emid

	emake DESTDIR="${D}" install || die "emake install failed"
	cp -f "${FILESDIR}"/icon/${PN}.desktop "${T}" || die

	if use crypt ; then
		cd "${T}" || die
		unzip "${S}"/mozilla/dist/bin/enigmail*.xpi install.rdf || die
		emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' install.rdf)

		dodir ${MOZILLA_FIVE_HOME}/extensions/${emid} || die
		cd "${D}"${MOZILLA_FIVE_HOME}/extensions/${emid} || die
		unzip "${S}"/mozilla/dist/bin/enigmail*.xpi || die
	fi

	sed 's|^\(MimeType=.*\)$|\1text/x-vcard;text/directory;application/mbox;message/rfc822;x-scheme-handler/mailto;|' \
		-i "${T}"/${PN}.desktop || die
	sed 's|^\(Categories=.*\)$|\1Email;|' -i "${T}"/${PN}.desktop \
		|| die

	if ${HAS_LANGS} ; then
		linguas
		for X in ${linguas}; do
			[[ ${X} != "en" ]] && xpi_install "${WORKDIR}"/"${P}-${X}"
		done
	fi

	# Add StartupNotify=true bug 290401
	if use startup-notification ; then
		echo "StartupNotify=true" >> "${T}"/${PN}.desktop
	fi

	# Install icon and .desktop for menu entry
	newicon "${S}"/suite/branding/nightly/content/icon64.png ${PN}.png \
		|| die
	domenu "${T}"/${PN}.desktop || die

	# Add our default prefs
	sed "s|SEAMONKEY_PVR|${PVR}|" "${FILESDIR}"/all-gentoo.js \
		> "${D}"${MOZILLA_FIVE_HOME}/defaults/pref/all-gentoo.js \
			|| die

	# Plugins dir
	rm -rf "${D}"${MOZILLA_FIVE_HOME}/plugins || die "failed to remove existing plugins dir"
	dosym ../nsbrowser/plugins "${MOZILLA_FIVE_HOME}"/plugins || die

	doman "${S}"/suite/app/${PN}.1 || die
}

pkg_preinst() {
	declare MOZILLA_FIVE_HOME="${ROOT}/usr/$(get_libdir)/${PN}"

	if [ -d ${MOZILLA_FIVE_HOME}/plugins ] ; then
		rm ${MOZILLA_FIVE_HOME}/plugins -rf
	fi
}

pkg_postinst() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update

	if use chatzilla ; then
		elog "chatzilla is now an extension which can be en-/disabled and configured via"
		elog "the Add-on manager."
	fi
}
