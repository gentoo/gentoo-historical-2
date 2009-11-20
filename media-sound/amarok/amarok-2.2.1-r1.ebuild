# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-2.2.1-r1.ebuild,v 1.1 2009/11/20 03:02:48 jmbsvicetto Exp $

EAPI="2"

# Translations are only in the tarballs, not the git repo
if [[ ${PV} != *9999* ]]; then
	KDE_LINGUAS="bg ca cs da de en_GB es et eu fi fr it ja km nb nds nl
	pa pl pt pt_BR ru sl sr sr@latin sv th tr uk wa zh_TW"
else
	EGIT_REPO_URI="git://gitorious.org/${PN}/${PN}.git"
	GIT_ECLASS="git"
fi
OPENGL_REQUIRED="optional"
inherit kde4-base ${GIT_ECLASS}

DESCRIPTION="Advanced audio player based on KDE framework."
HOMEPAGE="http://amarok.kde.org/"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
else
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"
fi

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="cdda daap debug ipod lastfm mp3tunes mtp +semantic-desktop"

# ipod requires gdk enabled and also gtk compiled in libgpod
DEPEND="
	app-crypt/qca:2
	>=app-misc/strigi-0.5.7
	|| (
		>=dev-db/mysql-5.0.76-r1[embedded,-minimal]
		>=dev-db/mysql-community-5.0.77-r1[embedded,-minimal]
	)
	>=media-libs/taglib-1.6[asf,mp4]
	>=media-libs/taglib-extras-1.0.1
	>=kde-base/kdelibs-${KDE_MINIMAL}[opengl?,semantic-desktop?]
	sys-libs/zlib
	>=x11-libs/qtscriptgenerator-0.1.0
	cdda? (
		>=kde-base/libkcddb-${KDE_MINIMAL}
		>=kde-base/libkcompactdisc-${KDE_MINIMAL}
	)
	ipod? ( >=media-libs/libgpod-0.7.0[gtk] )
	lastfm? ( >=media-libs/liblastfm-0.3.0 )
	mp3tunes? (
		dev-libs/glib:2
		dev-libs/libxml2
		dev-libs/openssl
		net-libs/loudmouth
		net-misc/curl
		x11-libs/qt-core[glib]
	)
	mtp? ( >=media-libs/libmtp-0.3.0 )
"
RDEPEND="${DEPEND}
	>=kde-base/phonon-kde-${KDE_MINIMAL}
	>=media-sound/amarok-utils-${PV}
	semantic-desktop? ( >=kde-base/nepomuk-${KDE_MINIMAL} )
"

PATCHES=( "${FILESDIR}/amarok-qtscriptcheck.patch" )

# Only really required for live ebuild, to skip git_src_prepare
src_prepare() {
	kde4-base_src_prepare
}

src_configure() {
	# Workaround for problems related to libmysqld.so and collection plugin not
	# being found on some architectures when --as-needed is not used.
	# append-ldflags -Wl,--as-needed

	mycmakeargs="${mycmakeargs}
		-DWITH_PLAYER=ON
		-DWITH_UTILITIES=OFF
		-DWITH_Libgcrypt=OFF
		$(cmake-utils_use_with ipod)
		$(cmake-utils_use_with ipod Gdk)
		$(cmake-utils_use_with lastfm LibLastFm)
		$(cmake-utils_use_with mtp)
		$(cmake-utils_use_with mp3tunes MP3Tunes)"
#		$(cmake-utils_use_with semantic-desktop Nepomuk)
#		$(cmake-utils_use_with semantic-desktop Soprano)"

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if use daap; then
		echo
		elog "You have installed amarok with daap support."
		elog "You may be interested in installing www-servers/mongrel as well."
		echo
	fi

	elog "This version of amarok will segfault on start if built with >=binutils-2.20 - bug #290662"
	elog "While this issue is being checked, for a temporary workaround run the following:"
	elog "emerge -1 =binutils-2.19.1-r1 && emerge -1 amarok && emerge -1 binutils"
}
