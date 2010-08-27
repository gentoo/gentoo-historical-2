# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/quassel/quassel-9999.ebuild,v 1.45 2010/08/27 09:44:57 scarabeus Exp $

EAPI="2"

inherit cmake-utils eutils git

EGIT_REPO_URI="git://git.quassel-irc.org/quassel.git"
EGIT_BRANCH="master"

DESCRIPTION="Qt4/KDE4 IRC client suppporting a remote daemon for 24/7 connectivity."
HOMEPAGE="http://quassel-irc.org/"

LICENSE="GPL-3"
KEYWORDS=""
SLOT="0"
IUSE="ayatana crypt dbus debug kde monolithic phonon postgres +server +ssl webkit X"

QT_MINIMAL="4.6.0"
KDE_MINIMAL="4.4"

SERVER_RDEPEND="
	crypt? ( app-crypt/qca:2 )
	!postgres? ( >=x11-libs/qt-sql-${QT_MINIMAL}:4[sqlite] dev-db/sqlite[threadsafe] )
	postgres? ( >=x11-libs/qt-sql-${QT_MINIMAL}:4[postgres] )
	x11-libs/qt-script:4
"

GUI_RDEPEND="
	>=x11-libs/qt-gui-${QT_MINIMAL}:4
	ayatana? ( dev-libs/libindicate-qt )
	dbus? (
		>=x11-libs/qt-dbus-${QT_MINIMAL}:4
		dev-libs/libdbusmenu-qt
	)
	kde? (
		>=kde-base/kdelibs-${KDE_MINIMAL}
		>=kde-base/oxygen-icons-${KDE_MINIMAL}
		ayatana? ( kde-misc/plasma-widget-message-indicator )
	)
	phonon? ( || ( media-sound/phonon >=x11-libs/qt-phonon-${QT_MINIMAL} ) )
	webkit? ( >=x11-libs/qt-webkit-${QT_MINIMAL}:4 )
"

RDEPEND="
	monolithic? (
		${SERVER_RDEPEND}
		${GUI_RDEPEND}
	)
	!monolithic? (
		server? ( ${SERVER_RDEPEND} )
		X? ( ${GUI_RDEPEND} )
	)
	ssl? ( x11-libs/qt-core:4[ssl] )
	!monolithic? (
		!server? (
			!X? (
				${SERVER_RDEPEND}
				${GUI_RDEPEND}
			)
		)
	)
	"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog README"

pkg_setup() {
	if ! use monolithic && ! use server && ! use X ; then
		ewarn "You have to build at least one of the monolithic client (USE=monolithic),"
		ewarn "the quasselclient (USE=X) or the quasselcore (USE=server)."
		echo
		ewarn "Enabling monolithic by default."
		FORCED_MONO="yes"
	fi

	if use server; then
		QUASSEL_DIR=/var/lib/${PN}
		QUASSEL_USER=${PN}
		# create quassel:quassel user
		enewgroup "${QUASSEL_USER}"
		enewuser "${QUASSEL_USER}" -1 -1 "${QUASSEL_DIR}" "${QUASSEL_USER}"
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with ayatana LIBINDICATE)
		$(cmake-utils_use_want X QTCLIENT)
		$(cmake-utils_use_want server CORE)
		$(cmake-utils_use_want monolithic MONO)
		$(cmake-utils_use_with webkit)
		$(cmake-utils_use_with phonon)
		$(cmake-utils_use_with kde)
		$(cmake-utils_use_with dbus)
		$(cmake-utils_use_with ssl OPENSSL)
		$(cmake-utils_use_with !kde OXYGEN)
		$(cmake-utils_use_with crypt)
		"-DEMBED_DATA=OFF"
	)

	[[ ${FORCED_MONO} == "yes" ]] && mycmakeargs+=( '-DWANT_MONO=ON' )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use server ; then
		# prepare folders in /var/
		keepdir "${QUASSEL_DIR}"
		fowners "${QUASSEL_USER}":"${QUASSEL_USER}" "${QUASSEL_DIR}"

		# init scripts
		newinitd "${FILESDIR}"/quasselcore.init quasselcore || die "newinitd failed"
		newconfd "${FILESDIR}"/quasselcore.conf quasselcore || die "newconfd failed"

		# logrotate
		insinto /etc/logrotate.d
		newins "${FILESDIR}/quassel.logrotate" quassel || die "newins failed"
	fi
}

pkg_postinst() {
	if use server && use ssl; then
		# inform about genreating ssl certificate
		elog "If you want to use ssl connection to your core, please generate ssl key, with following command:"
		elog "# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${QUASSEL_DIR}/quasselCert.pem -out ${QUASSEL_DIR}/quasselCert.pem"
		echo
		elog "Also remember that with the above command the key is valid only for 1 year."
	fi

	if ( use monolithic || [[ "${FORCED_MONO}" == "yes" ]] ) && use ssl ; then
		echo
		elog "Information on how to enable SSL support for client/core connections"
		elog "is available at http://bugs.quassel-irc.org/wiki/quassel-irc."
	fi

	# temporary info mesage
	if use server; then
		ewarn "Please note that all configuration moved from"
		ewarn "/home/\${QUASSEL_USER}/.config/quassel-irc.org/"
		ewarn "to: ${QUASSEL_DIR}."
		echo
		ewarn "For migration, stop the core, move quasselcore files (pretty much everything apart from quasselclient.conf and settings.qss) into new location and then start server again."
	fi
}
