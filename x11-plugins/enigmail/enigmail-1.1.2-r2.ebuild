# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/enigmail/enigmail-1.1.2-r2.ebuild,v 1.9 2011/03/14 17:09:51 nirbheek Exp $

WANT_AUTOCONF="2.1"
EAPI="3"

inherit flag-o-matic toolchain-funcs eutils mozconfig-3 makeedit multilib mozextension autotools
MY_P="${P/_beta/b}"
EMVER="${PV}"
TBVER="3.1.1"
PATCH="thunderbird-3.1-patches-0.8"

DESCRIPTION="GnuPG encryption plugin for thunderbird."
HOMEPAGE="http://enigmail.mozdev.org"
REL_URI="ftp://ftp.mozilla.org/pub/mozilla.org/thunderbird/nightly/"
SRC_URI="http://releases.mozilla.org/pub/mozilla.org/thunderbird/releases/${TBVER}/source/thunderbird-${TBVER}.source.tar.bz2
	http://www.mozilla-enigmail.org/download/source/${PN}-${EMVER}.tar.gz
	http://dev.gentoo.org/~anarchy/mozilla/patchsets/${PATCH}.tar.bz2"

KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="MPL-1.1 GPL-2"
IUSE="gnome system-sqlite"

DEPEND=">=mail-client/thunderbird-3.1.1-r1[system-sqlite=]"
RDEPEND="${DEPEND}
	gnome? ( >=gnome-base/gnome-vfs-2.16.3
		>=gnome-base/libgnomeui-2.16.1
		>=gnome-base/gconf-2.16.0
		>=gnome-base/libgnome-2.16.0 )
	system-sqlite? ( >=dev-db/sqlite-3.6.22-r2[fts3,secure-delete] )
	|| (
		(
			>=app-crypt/gnupg-2.0
			|| (
				app-crypt/pinentry[gtk]
				app-crypt/pinentry-qt
				app-crypt/pinentry[qt4]
			)
		)
		=app-crypt/gnupg-1.4*
	)"

S="${WORKDIR}"/comm-1.9.2

pkg_setup() {
	# EAPI=2 ensures they are set properly.
	export BUILD_OFFICIAL=1
	export MOZILLA_OFFICIAL=1
	export MOZ_CO_PROJECT=mail
}

src_unpack() {
	unpack thunderbird-${TBVER}.source.tar.bz2 ${PATCH}.tar.bz2 || die "unpack failed"
}

src_prepare(){
	# Apply our patches
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}"

	cd mozilla
	eautoreconf
	cd js/src
	eautoreconf

	# Unpack the enigmail plugin
	cd "${S}"/mailnews/extensions || die
	unpack enigmail-${EMVER}.tar.gz
	cd "${S}"/mailnews/extensions/enigmail || die "cd failed"
	makemake2

	cd "${S}"

	# Fix installation of enigmail.js
	epatch "${FILESDIR}"/70_enigmail-fix.patch
	epatch "${FILESDIR}"/75_enigmai-js-fixup.patch

	eautoreconf
}

src_configure() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/thunderbird"

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	touch mail/config/mozconfig
	mozconfig_init
	mozconfig_config

	# tb-specific settings
	mozconfig_annotate '' \
		--enable-crypto \
		--with-system-nspr \
		--with-system-nss \
		--disable-wave \
		--disable-ogg \
		--with-default-mozilla-five-home="${EPREFIX}"${MOZILLA_FIVE_HOME} \
		--with-user-appdir=.thunderbird \
		--enable-application=mail \
		--disable-necko-wifi \
		--disable-libnotify

	mozconfig_use_enable gnome gnomevfs
	mozconfig_use_enable gnome gnomeui
	mozconfig_use_enable system-sqlite

	# Finalize and report settings
	mozconfig_final

	# Disable no-print-directory
	MAKEOPTS=${MAKEOPTS/--no-print-directory/}

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	####################################
	#
	#  Configure and build Thunderbird
	#
	####################################
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	econf || die

	# This removes extraneous CFLAGS from the Makefiles to reduce RAM
	# requirements while compiling
	edit_makefiles
}

src_compile() {
	# Only build the parts necessary to support building enigmail
	emake -j1 export || die "make export failed"
	emake -C mozilla/modules/libreg || die "make modules/libreg failed"
	emake -C mozilla/xpcom/string || die "make xpcom/string failed"
	emake -C mozilla/xpcom || die "make xpcom failed"
	emake -C mozilla/xpcom/obsolete || die "make xpcom/obsolete failed"

	# Build the enigmail plugin
	einfo "Building Enigmail plugin..."
	emake -C "${S}"/mailnews/extensions/enigmail || die "make enigmail failed"

	# Package the enigmail plugin; this may be the easiest way to collect the
	# necessary files
	emake -j1 -C "${S}"/mailnews/extensions/enigmail xpi || die "make xpi failed"
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/thunderbird"
	declare emid

	cd "${T}"
	unzip "${S}"/mozilla/dist/bin/*.xpi install.rdf
	emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' install.rdf)

	dodir ${MOZILLA_FIVE_HOME}/extensions/${emid}
	cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid}
	unzip "${S}"/mozilla/dist/bin/*.xpi
}
