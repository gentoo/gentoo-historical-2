# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mozilla-thunderbird/mozilla-thunderbird-1.0.6-r2.ebuild,v 1.6 2005/07/23 13:29:48 gustavoz Exp $

unset ALLOWED_FLAGS  # stupid extra-functions.sh ... bug 49179
inherit flag-o-matic toolchain-funcs eutils mozconfig mozilla-launcher makeedit multilib

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="http://www.mozilla.org/projects/thunderbird/"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/thunderbird/releases/${PV}/source/thunderbird-${PV}-source.tar.bz2
	mirror://gentoo/mozilla-firefox-1.0-4ft2.patch.bz2
	mirror://gentoo/mozilla-jslibmath-alpha.patch
	mirror://gentoo/mozilla-firefox-1.0.6-nsplugins.patch
	http://dev.gentoo.org/~agriffis/dist/mozilla-firefox-1.0.6-nsplugins.patch"

KEYWORDS="alpha amd64 ia64 ppc sparc x86"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"
IUSE="mozcalendar ldap"

RDEPEND=">=www-client/mozilla-launcher-1.39"

S=${WORKDIR}/mozilla

# Needed by src_compile() and src_install().
# Would do in pkg_setup but that loses the export attribute, they
# become pure shell variables.
export BUILD_OFFICIAL=1
export MOZILLA_OFFICIAL=1
export MOZ_THUNDERBIRD=1

src_unpack() {
	declare x

	for x in ${A}; do
		[[ $x == *.tar.* ]] || continue
		unpack $x || die "unpack failed"
	done
	cd ${S} || die "cd failed"

	####################################
	#
	# architecture patches
	#
	####################################

	if [[ $(gcc-major-version) -eq 3 ]]; then
		# ABI Patch for alpha/xpcom for gcc-3.x
		if [[ ${ARCH} == alpha ]]; then
			epatch ${FILESDIR}/mozilla-alpha-xpcom-subs-fix.patch
		fi
	fi

	# patch to fix math operations on alpha, makes maps.google.com work!
	epatch ${DISTDIR}/mozilla-jslibmath-alpha.patch

	####################################
	#
	# general compilation and run-time fixes
	#
	####################################

	# GCC4 compile fix, bug #87800
	epatch ${FILESDIR}/${PN}-1.0.2-gcc4.patch

	# patch out ft caching code since the API changed between releases of
	# freetype; this enables freetype-2.1.8+ compat.
	# https://bugzilla.mozilla.org/show_bug.cgi?id=234035#c65
	epatch ${DISTDIR}/mozilla-firefox-1.0-4ft2.patch.bz2

	# look in /usr/lib/nsplugins for plugins, in addition to the usual places
	epatch ${DISTDIR}/mozilla-firefox-1.0.6-nsplugins.patch
}

src_compile() {
	declare MOZILLA_FIVE_HOME=/usr/$(get_libdir)/${PN}

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init

	# tb-specific settings
	mozconfig_use_enable ldap
	mozconfig_use_enable ldap ldap-experimental
	mozconfig_use_enable mozcalendar calendar
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}
	mozconfig_annotate '' --with-user-appdir=.thunderbird

	# Finalize and report settings
	mozconfig_final

	# hardened GCC uses -fstack-protector-all by default, which breaks us
	has_hardened && append-flags -fno-stack-protector-all
	replace-flags -fstack-protector-all -fstack-protector

	####################################
	#
	#  Configure and build
	#
	####################################

	LD="$(tc-getLD)" CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
	econf || die

	# This removes extraneous CFLAGS from the Makefiles to reduce RAM
	# requirements while compiling
	edit_makefiles

	emake || die
}

src_install() {
	declare MOZILLA_FIVE_HOME=/usr/$(get_libdir)/${PN}

	# Most of the installation happens here
	dodir ${MOZILLA_FIVE_HOME}
	cp -RL --no-preserve=links ${S}/dist/bin/* ${D}${MOZILLA_FIVE_HOME}

	# Create directory structure to support portage-installed extensions.
	# See update_chrome() in mozilla-launcher
	keepdir ${MOZILLA_FIVE_HOME}/chrome.d
	keepdir ${MOZILLA_FIVE_HOME}/extensions.d
	cp ${D}${MOZILLA_FIVE_HOME}/chrome/installed-chrome.txt \
		${D}${MOZILLA_FIVE_HOME}/chrome.d/0_base-chrome.txt

	# Create /usr/bin/thunderbird
	install_mozilla_launcher_stub thunderbird ${MOZILLA_FIVE_HOME}

	# Install icon and .desktop for menu entry
	insinto /usr/share/pixmaps
	doins ${FILESDIR}/icon/thunderbird-icon.png

	# Fix bug 54179: Install .desktop file into /usr/share/applications
	# instead of /usr/share/gnome/apps/Internet (18 Jun 2004 agriffis)
	insinto /usr/share/applications
	doins ${FILESDIR}/icon/mozillathunderbird.desktop
}

pkg_postinst() {
	declare MOZILLA_FIVE_HOME=/usr/$(get_libdir)/${PN}

	# Update the component registry
	MOZILLA_LIBDIR=${ROOT}${MOZILLA_FIVE_HOME} MOZILLA_LAUNCHER=thunderbird \
		/usr/libexec/mozilla-launcher -register

	# This should be called in the postinst and postrm of all the
	# mozilla, mozilla-bin, firefox, firefox-bin, thunderbird and
	# thunderbird-bin ebuilds.
	update_mozilla_launcher_symlinks

	ewarn "Enigmail Support has been dropped since it doesn't work on fresh install."
	ewarn "The Gentoo Mozilla team is working on making enigmail its own build,"
	ewarn "sorry for the inconvenience.  For now, you can download enigmail from"
	ewarn "http://enigmail.mozdev.org"
}

pkg_postrm() {
	declare MOZILLA_FIVE_HOME=/usr/$(get_libdir)/${PN}

	# Update the component registry
	MOZILLA_LIBDIR=${ROOT}${MOZILLA_FIVE_HOME} MOZILLA_LAUNCHER=thunderbird \
		/usr/libexec/mozilla-launcher -register

	update_mozilla_launcher_symlinks
}
