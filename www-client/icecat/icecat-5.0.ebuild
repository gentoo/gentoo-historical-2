# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/icecat/icecat-5.0.ebuild,v 1.2 2011/06/29 20:25:58 mr_bones_ Exp $

EAPI="3"
VIRTUALX_REQUIRED="pgo"
WANT_AUTOCONF="2.1"

inherit flag-o-matic toolchain-funcs eutils gnome2-utils mozconfig-3 makeedit multilib pax-utils fdo-mime autotools mozextension versionator python virtualx

MAJ_XUL_PV="5.0"
MAJ_FF_PV="$(get_version_component_range 1-2)" # 3.5, 3.6, 4.0, etc.
XUL_PV="${MAJ_XUL_PV}${PV/${MAJ_FF_PV}/}" # 1.9.3_alpha6, 1.9.2.3, etc.
FF_PV="${PV/_alpha/a}" # Handle alpha for SRC_URI
FF_PV="${FF_PV/_beta/b}" # Handle beta for SRC_URI
FF_PV="${FF_PV/_rc/rc}" # Handle rc for SRC_URI
PATCH="firefox-5.0-patches-0.5"

DESCRIPTION="GNU project's edition of Mozilla Firefox"
HOMEPAGE="http://www.gnu.org/software/gnuzilla/"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
IUSE="gconf hardened +ipc pgo system-sqlite +webm"

# More URIs appended below...
SRC_URI="mirror://gnu/gnuzilla/${FF_PV}/${PN}-${FF_PV}.tar.bz2
	http://dev.gentoo.org/~anarchy/mozilla/patchsets/${PATCH}.tar.bz2"
LANGPACK_URI="http://gnuzilla.gnu.org/download/langpacks/${FF_PV}"

ASM_DEPEND=">=dev-lang/yasm-1.1"

RDEPEND="
	>=sys-devel/binutils-2.16.1
	>=dev-libs/nss-3.12.9
	>=dev-libs/nspr-4.8.7
	gconf? ( >=gnome-base/gconf-1.2.1:2 )
	>=dev-libs/glib-2.26
	media-libs/libpng[apng]
	dev-libs/libffi
	system-sqlite? ( >=dev-db/sqlite-3.7.4[fts3,secure-delete,unlock-notify,debug=] )
	webm? ( media-libs/libvpx
		media-libs/alsa-lib )"
# We don't use PYTHON_DEPEND/PYTHON_USE_WITH for some silly reason
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	pgo? (
		=dev-lang/python-2*[sqlite]
		>=sys-devel/gcc-4.5 )
	webm? ( x86? ( ${ASM_DEPEND} )
		amd64? ( ${ASM_DEPEND} ) )"

# No language packs for alphas
if ! [[ ${PV} =~ alpha|beta ]]; then
	# This list can be updated with scripts/get_langs.sh from mozilla overlay
	LANGS="af ak ar ast be bg bn-BD bn-IN br bs ca cs cy da de
	el en eo es-ES et eu fa fi fr fy-NL ga-IE gd gl gu-IN
	he hi-IN hr hu hy-AM id is it ja kk kn ko ku lg lt lv mai mk
	ml mr nb-NO nl nn-NO nso or pa-IN pl pt-PT rm ro ru si sk sl
	son sq sr sv-SE ta ta-LK te th tr uk vi zu"
	NOSHORTLANGS="en-GB en-ZA es-AR es-CL es-MX pt-BR zh-CN zh-TW"

	for X in ${LANGS} ; do
		if [ "${X}" != "en" ] && [ "${X}" != "en-US" ]; then
			SRC_URI="${SRC_URI}
				linguas_${X/-/_}? ( ${LANGPACK_URI}/${X}.xpi -> ${P}-${X}.xpi )"
		fi
		IUSE="${IUSE} linguas_${X/-/_}"
		# english is handled internally
		if [ "${#X}" == 5 ] && ! has ${X} ${NOSHORTLANGS}; then
			if [ "${X}" != "en-US" ]; then
				SRC_URI="${SRC_URI}
					linguas_${X%%-*}? ( ${LANGPACK_URI}/${X}.xpi -> ${P}-${X}.xpi )"
			fi
			IUSE="${IUSE} linguas_${X%%-*}"
		fi
	done
fi

QA_PRESTRIPPED="usr/$(get_libdir)/${PN}/${PN}"

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
		ewarn "Sorry, but ${P} does not support the ${LANG} LINGUA"
	done
}

pkg_setup() {
	moz_pkgsetup

	# Avoid PGO profiling problems due to enviroment leakage
	# These should *always* be cleaned up anyway
	unset DBUS_SESSION_BUS_ADDRESS \
		DISPLAY \
		ORBIT_SOCKETDIR \
		SESSION_MANAGER \
		XDG_SESSION_COOKIE \
		XAUTHORITY

	if ! use hardened && use pgo; then
		einfo
		ewarn "You will do a double build for profile guided optimization. This will result in your"
		ewarn "build taking at least twice as long as before."
	fi
}

src_unpack() {
	unpack ${A}

	linguas
	for X in ${linguas}; do
		# FIXME: Add support for unpacking xpis to portage
		[[ ${X} != "en" ]] && xpi_unpack "${P}-${X}.xpi"
	done
}

src_prepare() {
	# Fix preferences location
	sed -i 's|defaults/pref/|defaults/preferences/|' browser/installer/packages-static || die "sed failed"

	# Apply our patches
	#
	EPATCH_EXCLUDE="2000-firefox_gentoo_install_dirs.patch
			5001_use_system_libffi.patch" \
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}"

	epatch "${FILESDIR}"/2000-icecat-5_gentoo_install_dirs.patch

	# Allow user to apply any additional patches without modifing ebuild
	epatch_user

	# Fix rebranding
	sed -i 's|\$(DIST)/bin/firefox|\$(DIST)/bin/icecat|' browser/app/Makefile.in

	# Enable gnomebreakpad
	if use debug ; then
		sed -i -e "s:GNOME_DISABLE_CRASH_DIALOG=1:GNOME_DISABLE_CRASH_DIALOG=0:g" \
			"${S}"/build/unix/run-mozilla.sh || die "sed failed!"
	fi

	# Disable gnomevfs extension
	sed -i -e "s:gnomevfs::" "${S}/"browser/confvars.sh \
		-e "s:gnomevfs::" "${S}/"xulrunner/confvars.sh \
		|| die "Failed to remove gnomevfs extension"

	# Ensure that are plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/$(get_libdir)/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path!"

	# Fix sandbox violations during make clean, bug 372817
	sed -e "s:\(/no-such-file\):${T}\1:g" \
		-i "${S}"/config/rules.mk \
		-i "${S}"/js/src/config/rules.mk \
		-i "${S}"/nsprpub/configure{.in,} \
		|| die

	eautoreconf

	cd js/src
	eautoreconf
}

src_configure() {
	# We will build our own .mozconfig
	rm "${S}"/.mozconfig

	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
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

	# Specific settings for icecat
	echo "export MOZ_PHOENIX=1" >> "${S}"/.mozconfig
	echo "mk_add_options MOZ_PHOENIX=1" "${S}"/.mozconfig
	mozconfig_annotate '' --with-branding=browser/branding/unofficial
	mozconfig_annotate '' --disable-official-branding
	mozconfig_annotate '' --with-user-appdir=.icecat

	mozconfig_annotate '' --prefix=/usr
	mozconfig_annotate '' --libdir=/usr/$(get_libdir)
	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --disable-mailnews
	mozconfig_annotate '' --enable-canvas
	mozconfig_annotate '' --enable-safe-browsing
	mozconfig_annotate '' --with-system-png
	use hardened && mozconfig_annotate 'hardened' --disable-methodjit

	# Other browser-specific settings
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}

	mozconfig_use_enable system-sqlite
	mozconfig_use_enable gconf

	# Allow for a proper pgo build
	if ! use hardened && use pgo; then
		echo "mk_add_options PROFILE_GEN_SCRIPT='\$(PYTHON) \$(OBJDIR)/_profile/pgo/profileserver.py'" >> "${S}"/.mozconfig
	fi

	# Finalize and report settings
	mozconfig_final

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	if use amd64 || use x86; then
		append-flags -mno-avx
	fi
}

src_compile() {
	if ! use hardened && use pgo; then
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
		MOZ_MAKE_FLAGS="${MAKEOPTS}" \
		Xemake -f client.mk profiledbuild || die "Xemake failed"
	else
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
		MOZ_MAKE_FLAGS="${MAKEOPTS}" \
		emake -f client.mk || die "emake failed"
	fi

}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# MOZ_BUILD_ROOT, and hence OBJ_DIR change depending on arch, compiler, pgo, etc.
	local obj_dir="$(echo */config.log)"
	obj_dir="${obj_dir%/*}"
	cd "${S}/${obj_dir}"

	# Add our default prefs for firefox + xulrunner
	cp "${FILESDIR}"/gentoo-default-prefs.js \
		"${S}/${obj_dir}/dist/bin/defaults/pref/all-gentoo.js" || die

	MOZ_MAKE_FLAGS="${MAKEOPTS}" \
	emake DESTDIR="${D}" install || die "emake install failed"

	linguas
	for X in ${linguas}; do
		[[ ${X} != "en" ]] && xpi_install "${WORKDIR}/${P}-${X}"
	done

	local size sizes icon_path icon name
	sizes="16 32 48"
	icon_path="${S}/browser/branding/unofficial"

	# Install icons and .desktop for menu entry
	for size in ${sizes}; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "${icon_path}/default${size}.png" "${PN}.png" || die
	done
	# The 128x128 icon has a different name
	insinto "/usr/share/icons/hicolor/128x128/apps"
	newins "${icon_path}/mozicon128.png" "${PN}.png" || die
	# Install a 48x48 icon into /usr/share/pixmaps for legacy DEs
	newicon "${icon_path}/content/icon48.png" "${PN}.png" || die
	newmenu "${FILESDIR}/icon/${PN}.desktop" "${PN}.desktop" || die
	sed -e "/^Icon/s:${PN}-icon:${PN}:" -i \
		"${ED}/usr/share/applications/${PN}.desktop" || die

	# Add StartupNotify=true bug 237317
	if use startup-notification ; then
		echo "StartupNotify=true" >> "${ED}/usr/share/applications/${PN}.desktop"
	fi

	if use hardened; then
		pax-mark m "${ED}"/${MOZILLA_FIVE_HOME}/${PN}
		pax-mark m "${ED}"/${MOZILLA_FIVE_HOME}/plugin-container
	fi

	# Plugins dir
	dosym ../nsbrowser/plugins "${MOZILLA_FIVE_HOME}"/plugins \
		|| die "failed to symlink"

}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
