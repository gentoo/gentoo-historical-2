# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde4-functions.eclass,v 1.1 2008/01/16 22:47:45 ingmar Exp $

# @ECLASS: kde4-functions.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: Common ebuild functions for monolithic and split KDE 4 packages
# @DESCRIPTION:
# This eclass contains all functions shared by the different eclasses,
# for KDE 4 monolithic and split ebuilds.
#
# NOTE: This eclass uses the SLOT dependencies from EAPI="1" or compatible,
# hence you must define EAPI="1" in the ebuild, before inheriting any eclasses.

# @ECLASS-VARIABLE: KDEBASE
# @DESCRIPTION:
# This gets set to a non-zero value when a package is considered a kde or
# koffice ebuild.

if [[ "${CATEGORY}" == "kde-base" ]]; then
	debug-print "${ECLASS}: KDEBASE ebuild recognized"
	KDEBASE="kde-base"
fi

# is this a koffice ebuild?
if [[ "${KMNAME}" == "koffice" || "${PN}" == "koffice" ]]; then
	debug-print "${ECLASS}: KOFFICE ebuild recognized"
	KDEBASE="koffice"
fi

# @ECLASS-VARIABLE: KDE_DERIVATION_MAP
# @DESCRIPTION:
# Map of the monolithic->split ebuild derivation.
# Used to build dependencies describing the relationships between them:
# Monolithic ebuilds block their split counterparts in the same slot, and vice versa.
#
# Also see get-parent-package(), get-child-packages(), is-parent-package()
KDE_DERIVATION_MAP='
kde-base/kdeaccessibility kde-base/kdeaccessibility-colorschemes
kde-base/kdeaccessibility kde-base/kdeaccessibility-iconthemes
kde-base/kdeaccessibility kde-base/kmag
kde-base/kdeaccessibility kde-base/kmousetool
kde-base/kdeaccessibility kde-base/kmouth
kde-base/kdeaccessibility kde-base/kttsd
kde-base/kdeadmin kde-base/kcron
kde-base/kdeadmin kde-base/kdat
kde-base/kdeadmin kde-base/knetworkconf
kde-base/kdeadmin kde-base/ksysv
kde-base/kdeadmin kde-base/kuser
kde-base/kdeadmin kde-base/lilo-config
kde-base/kdeadmin kde-base/secpolicy
kde-base/kdeartwork kde-base/kdeartwork-colorschemes
kde-base/kdeartwork kde-base/kdeartwork-emoticons
kde-base/kdeartwork kde-base/kdeartwork-icewm-themes
kde-base/kdeartwork kde-base/kdeartwork-iconthemes
kde-base/kdeartwork kde-base/kdeartwork-kscreensaver
kde-base/kdeartwork kde-base/kdeartwork-kworldclock
kde-base/kdeartwork kde-base/kdeartwork-sounds
kde-base/kdeartwork kde-base/kdeartwork-styles
kde-base/kdeartwork kde-base/kdeartwork-wallpapers
kde-base/kdebase kde-base/dolphin
kde-base/kdebase kde-base/kappfinder
kde-base/kdebase kde-base/kdepasswd
kde-base/kdebase kde-base/kdialog
kde-base/kdebase kde-base/keditbookmarks
kde-base/kdebase kde-base/kfind
kde-base/kdebase kde-base/konqueror
kde-base/kdebase kde-base/konsole
kde-base/kdebase kde-base/kwrite
kde-base/kdebase kde-base/libkonq
kde-base/kdebase kde-base/nsplugins
kde-base/kdebase kde-base/drkonqi
kde-base/kdebase kde-base/kcmshell
kde-base/kdebase kde-base/kcontrol
kde-base/kdebase kde-base/kdebase-data
kde-base/kdebase kde-base/kdebase-kioslaves
kde-base/kdebase kde-base/kdebugdialog
kde-base/kdebase kde-base/kde-menu
kde-base/kdebase kde-base/kdesu
kde-base/kdebase kde-base/kfile
kde-base/kdebase kde-base/khelpcenter
kde-base/kdebase kde-base/kioclient
kde-base/kdebase kde-base/kmimetypefinder
kde-base/kdebase kde-base/knetattach
kde-base/kdebase kde-base/knewstuff
kde-base/kdebase kde-base/knotify
kde-base/kdebase kde-base/kpasswdserver
kde-base/kdebase kde-base/kquitapp
kde-base/kdebase kde-base/kreadconfig
kde-base/kdebase kde-base/kstart
kde-base/kdebase kde-base/kstyles
kde-base/kdebase kde-base/ktimezoned
kde-base/kdebase kde-base/ktraderclient
kde-base/kdebase kde-base/kuiserver
kde-base/kdebase kde-base/kurifilter-plugins
kde-base/kdebase kde-base/nepomuk
kde-base/kdebase kde-base/phonon
kde-base/kdebase kde-base/soliduiserver
kde-base/kdebase kde-base/kcheckpass
kde-base/kdebase kde-base/kcminit
kde-base/kdebase kde-base/kdebase-startkde
kde-base/kdebase kde-base/kstartupconfig
kde-base/kdebase kde-base/kde-menu-icons
kde-base/kdebase kde-base/kde-wallpapers
kde-base/kdebase kde-base/kdm
kde-base/kdebase kde-base/khotkeys
kde-base/kdebase kde-base/klipper
kde-base/kdebase kde-base/kmenuedit
kde-base/kdebase kde-base/krunner
kde-base/kdebase kde-base/kscreensaver
kde-base/kdebase kde-base/ksmserver
kde-base/kdebase kde-base/ksplash
kde-base/kdebase kde-base/ksysguard
kde-base/kdebase kde-base/ksystraycmd
kde-base/kdebase kde-base/ktip
kde-base/kdebase kde-base/kwin
kde-base/kdebase kde-base/libkworkspace
kde-base/kdebase kde-base/libplasma
kde-base/kdebase kde-base/libtaskmanager
kde-base/kdebase kde-base/plasma
kde-base/kdebase kde-base/solid
kde-base/kdebase kde-base/systemsettings
kde-base/kdebindings kde-base/kalyptus
kde-base/kdebindings kde-base/kdejava
kde-base/kdebindings kde-base/kimono
kde-base/kdebindings kde-base/kjsembed
kde-base/kdebindings kde-base/korundum
kde-base/kdebindings kde-base/krosspython
kde-base/kdebindings kde-base/krossruby
kde-base/kdebindings kde-base/pykde4
kde-base/kdebindings kde-base/qyoto
kde-base/kdebindings kde-base/qtjava
kde-base/kdebindings kde-base/qtruby
kde-base/kdebindings kde-base/qtsharp
kde-base/kdebindings kde-base/smoke
kde-base/kdebindings kde-base/xparts
kde-base/kdeedu kde-base/blinken
kde-base/kdeedu kde-base/kalgebra
kde-base/kdeedu kde-base/kalzium
kde-base/kdeedu kde-base/kanagram
kde-base/kdeedu kde-base/kbruch
kde-base/kdeedu kde-base/kgeography
kde-base/kdeedu kde-base/khangman
kde-base/kdeedu kde-base/kig
kde-base/kdeedu kde-base/kiten
kde-base/kdeedu kde-base/klettres
kde-base/kdeedu kde-base/kmplot
kde-base/kdeedu kde-base/kpercentage
kde-base/kdeedu kde-base/kstars
kde-base/kdeedu kde-base/ktouch
kde-base/kdeedu kde-base/kturtle
kde-base/kdeedu kde-base/kwordquiz
kde-base/kdeedu kde-base/libkdeedu
kde-base/kdeedu kde-base/marble
kde-base/kdeedu kde-base/parley
kde-base/kdegames kde-base/bovo
kde-base/kdegames kde-base/katomic
kde-base/kdegames kde-base/kbattleship
kde-base/kdegames kde-base/kblackbox
kde-base/kdegames kde-base/kbounce
kde-base/kdegames kde-base/kfourinline
kde-base/kdegames kde-base/kgoldrunner
kde-base/kdegames kde-base/kiriki
kde-base/kdegames kde-base/kjumpingcube
kde-base/kdegames kde-base/klines
kde-base/kdegames kde-base/kmahjongg
kde-base/kdegames kde-base/kmines
kde-base/kdegames kde-base/knetwalk
kde-base/kdegames kde-base/kolf
kde-base/kdegames kde-base/konquest
kde-base/kdegames kde-base/kpat
kde-base/kdegames kde-base/kreversi
kde-base/kdegames kde-base/ksame
kde-base/kdegames kde-base/kshisen
kde-base/kdegames kde-base/kspaceduel
kde-base/kdegames kde-base/ksquares
kde-base/kdegames kde-base/ksudoku
kde-base/kdegames kde-base/ktuberling
kde-base/kdegames kde-base/libkdegames
kde-base/kdegames kde-base/libkmahjongg
kde-base/kdegames kde-base/lskat
kde-base/kdegraphics kde-base/gwenview
kde-base/kdegraphics kde-base/kamera
kde-base/kdegraphics kde-base/kcolorchooser
kde-base/kdegraphics kde-base/kgamma
kde-base/kdegraphics kde-base/kghostview
kde-base/kdegraphics kde-base/kolourpaint
kde-base/kdegraphics kde-base/kruler
kde-base/kdegraphics kde-base/ksnapshot
kde-base/kdegraphics kde-base/libkscan
kde-base/kdegraphics kde-base/okular
kde-base/kdegraphics kde-base/svgpart
kde-base/kdemultimedia kde-base/juk
kde-base/kdemultimedia kde-base/kdemultimedia-kioslaves
kde-base/kdemultimedia kde-base/kmix
kde-base/kdemultimedia kde-base/kscd
kde-base/kdemultimedia kde-base/libkcddb
kde-base/kdemultimedia kde-base/libkcompactdisc
kde-base/kdenetwork kde-base/kdenetwork-filesharing
kde-base/kdenetwork kde-base/kdnssd
kde-base/kdenetwork kde-base/kget
kde-base/kdenetwork kde-base/knewsticker
kde-base/kdenetwork kde-base/kopete
kde-base/kdenetwork kde-base/kppp
kde-base/kdenetwork kde-base/krdc
kde-base/kdenetwork kde-base/krfb
kde-base/kdepim kde-base/akonadi
kde-base/kdepim kde-base/akregator
kde-base/kdepim kde-base/certmanager
kde-base/kdepim kde-base/kabc2mutt
kde-base/kdepim kde-base/kabcclient
kde-base/kdepim kde-base/kaddressbook
kde-base/kdepim kde-base/kalarm
kde-base/kdepim kde-base/kdemaildir
kde-base/kdepim kde-base/kdepim-kioslaves
kde-base/kdepim kde-base/kdepim-kresources
kde-base/kdepim kde-base/kdepim-wizards
kde-base/kdepim kde-base/kfeed
kde-base/kdepim kde-base/kitchensync
kde-base/kdepim kde-base/kleopatra
kde-base/kdepim kde-base/kmail
kde-base/kdepim kde-base/kmailcvt
kde-base/kdepim kde-base/kmobiletools
kde-base/kdepim kde-base/knode
kde-base/kdepim kde-base/knotes
kde-base/kdepim kde-base/kode
kde-base/kdepim kde-base/konsolekalendar
kde-base/kdepim kde-base/kontact
kde-base/kdepim kde-base/kontact-specialdates
kde-base/kdepim kde-base/korganizer
kde-base/kdepim kde-base/korn
kde-base/kdepim kde-base/kpilot
kde-base/kdepim kde-base/ktimetracker
kde-base/kdepim kde-base/ktnef
kde-base/kdepim kde-base/libkdepim
kde-base/kdepim kde-base/libkholidays
kde-base/kdepim kde-base/libkleo
kde-base/kdepim kde-base/libkpgp
kde-base/kdepim kde-base/libksieve
kde-base/kdepim kde-base/mailtransport
kde-base/kdepim kde-base/mimelib
kde-base/kdepim kde-base/networkstatus
kde-base/kdesdk kde-base/cervisia
kde-base/kdesdk kde-base/kdeaccounts-plugin
kde-base/kdesdk kde-base/kapptemplate
kde-base/kdesdk kde-base/kate
kde-base/kdesdk kde-base/kbabel
kde-base/kdesdk kde-base/kbugbuster
kde-base/kdesdk kde-base/kcachegrind
kde-base/kdesdk kde-base/kdesdk-kioslaves
kde-base/kdesdk kde-base/kdesdk-misc
kde-base/kdesdk kde-base/kdesdk-scripts
kde-base/kdesdk kde-base/kmtrace
kde-base/kdesdk kde-base/kompare
kde-base/kdesdk kde-base/kspy
kde-base/kdesdk kde-base/kstartperf
kde-base/kdesdk kde-base/strigi-analyzer
kde-base/kdesdk kde-base/kuiviewer
kde-base/kdesdk kde-base/poxml
kde-base/kdesdk kde-base/umbrello
kde-base/kdetoys kde-base/amor
kde-base/kdetoys kde-base/kteatime
kde-base/kdetoys kde-base/ktux
kde-base/kdetoys kde-base/kweather
kde-base/kdetoys kde-base/kworldclock
kde-base/kdeutils kde-base/ark
kde-base/kdeutils kde-base/kcalc
kde-base/kdeutils kde-base/kcharselect
kde-base/kdeutils kde-base/kdessh
kde-base/kdeutils kde-base/kdf
kde-base/kdeutils kde-base/kedit
kde-base/kdeutils kde-base/kfloppy
kde-base/kdeutils kde-base/kgpg
kde-base/kdeutils kde-base/khexedit
kde-base/kdeutils kde-base/kjots
kde-base/kdeutils kde-base/kmilo
kde-base/kdeutils kde-base/kregexpeditor
kde-base/kdeutils kde-base/kdessh
kde-base/kdeutils kde-base/ktimer
kde-base/kdeutils kde-base/kwallet
kde-base/kdeutils kde-base/superkaramba
kde-base/kdeutils kde-base/sweeper
kde-base/kdewebdev kde-base/kfilereplace
kde-base/kdewebdev kde-base/kimagemapeditor
kde-base/kdewebdev kde-base/klinkstatus
kde-base/kdewebdev kde-base/kxsldbg
kde-base/kdewebdev kde-base/quanta
app-office/koffice app-office/karbon
app-office/koffice app-office/kchart
app-office/koffice app-office/kexi
app-office/koffice app-office/kformula
app-office/koffice app-office/kivio
app-office/koffice app-office/koffice-data
app-office/koffice app-office/koffice-libs
app-office/koffice app-office/koshell
app-office/koffice app-office/kplato
app-office/koffice app-office/kpresenter
app-office/koffice app-office/krita
app-office/koffice app-office/kspread
app-office/koffice app-office/kugar
app-office/koffice app-office/kword
'

# @FUNCTION: get-parent-package
# @USAGE: <split ebuild>
# @DESCRIPTION:
# Echoes the name of the monolithic package that a given split ebuild was derived from.
get-parent-package() {
	local parent child
	while read parent child; do
		if [[ "${child}" == "$1" ]]; then
			echo ${parent}
			return 0
		fi
	done <<< "$KDE_DERIVATION_MAP"
	die "Package $target not found in KDE_DERIVATION_MAP, please report bug"
}

# @FUNCTION: get-child-packages
# @USAGE: <monolithic ebuild>
# @DESCRIPTION:
# Echoes the names of all (split) ebuilds derived from a given monolithic ebuild.
get-child-packages() {
	local parent child
	while read parent child; do
		[[ "${parent}" == "$1" ]] && echo -n "${child} "
	done <<< "$KDE_DERIVATION_MAP"
}

# @FUNCTION: is-parent-package
# @USAGE: <$CATEGORY/$PN>
# @DESCRIPTION:
# Returns zero exit-status if the given package is a parent (monolithic) ebuild.
# Returns non-zero exit-status if it's not.
is-parent-package() {
	local parent child
	while read parent child; do
		[[ "${parent}" == "$1" ]] && return 0
	done <<< "$KDE_DERIVATION_MAP"
	return 1
}

# @FUNCTION: buildsycoca
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache.
# All KDE ebuilds should run this in pkg_postinst and pkg_postrm.
#
# Note that kde4-base.eclass already does this.
buildsycoca() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -x ${KDEDIR}/bin/kbuildsycoca4 ]] && [[ -z "${ROOT}" || "${ROOT}" == "/" ]]; then
		# First of all, make sure that the /usr/share/services directory exists
		# and it has the right permissions
		mkdir -p /usr/share/services
		chown root:0 /usr/share/services
		chmod 0755 /usr/share/services

		# kbuildsycoca4 needs a running dbus session to work correctly.
		# We have to start a new dbus session, because the DBUS_SESSION_BUS_ADDRESS in the environment
		# could from from the user's environment (through su [without '-']), causing kbuildsycoca4 to hang.

		einfo "Starting dbus session for kbuildsycoca4"
		local _i
		for _i in $(dbus-launch); do
			# We export both the ADDRESS _and_ the PID. We need the latter only to kill our session.
			debug-print "Exporting: ${_i}"
			export "${_i}";
		done
		debug-print "kbuildsycoca4 is using ${DBUS_SESSION_BUS_ADDRESS}"

		ebegin "Running kbuildsycoca4 to build global database"
		# This is needed because we support multiple kde versions installed together.
		XDG_DATA_DIRS="/usr/share:${KDEDIRS}/share:/usr/local/share"
		${KDEDIR}/bin/kbuildsycoca4 --global --noincremental &> /dev/null
		eend $?

		einfo "Killing dbus session for kbuildsycoca4"
		debug-print "ADDRES ${DBUS_SESSION_BUS_ADDRESS}"
		debug-print "PID: ${DBUS_SESSION_BUS_PID}"
		kill ${DBUS_SESSION_BUS_PID}
		eend $?
		unset DBUS_SESSION_BUS_ADDRES DBUS_SESSION_BUS_PID
	fi
}

# @FUNCTION: comment_all_add_subdirectory
# @USAGE: [list of directory names]
# @DESCRIPTION:
# recursively comment all add_subdirectory instructions in listed directories
# except the ones in cmake/.
comment_all_add_subdirectory() {
	find "$@" -name CMakeLists.txt -print0 | grep -vFzZ "./cmake" | \
		xargs -0 sed -i -e '/add_subdirectory/s/^/#DONOTCOMPILE /' || \
		die "${LINENO}: Initial sed died"
}

# @ECLASS-VARIABLE: QT4_BUILT_WITH_USE_CHECK
# @DESCRIPTION:
# A list of USE flags that x11-libs/qt:4 needs to be built with.
#
# This list is automatically appended to KDE4_BUILT_WITH_USE_CHECK,
# so don't call qt4_pkg_setup manually.

# @ECLASS-VARIABLE: KDE4_BUILT_WITH_USE_CHECK
# @DESCRIPTION:
# The contents of $KDE4_BUILT_WITH_USE_CHECK gets fed to built_with_use
# (eutils.eclass), line per line.
#
# Example:
# @CODE
# pkg_setup() {
# 	KDE4_BUILT_WITH_USE_CHECK="--missing true sys-apps/dbus X"
# 	use alsa && KDE4_BUILT_WITH_USE_CHECK="${KDE4_BUILT_WITH_USE_CHECK}
# 		--missing true media-libs/alsa-lib midi"
# 	kde4-base_pkg_setup
# }
# @CODE

# run built_with_use on each flag and print appropriate error messages if any
# flags are missing
_kde4-functions_built_with_use() {
	local missing opt pkg flag flags

	if [[ ${1} = "--missing" ]]; then
		missing="${1} ${2}" && shift 2
	fi
	if [[ ${1:0:1} = "-" ]]; then
		opt=${1} && shift
	fi

	pkg=${1} && shift

	for flag in "${@}"; do
		flags="${flags} ${flag}"
		if ! built_with_use ${missing} ${opt} ${pkg} ${flag}; then
			flags="${flags}*"
		else
			[[ ${opt} = "-o" ]] && return 0
		fi
	done
	if [[ "${flags# }" = "${@}" ]]; then
		return 0
	fi
	if [[ ${opt} = "-o" ]]; then
		eerror "This package requires '${pkg}' to be built with any of the following USE flags: '$*'."
	else
		eerror "This package requires '${pkg}' to be built with the following USE flags: '${flags# }'."
	fi
	return 1
}

# @FUNCTION: kde4-functions_check_use
# @DESCRIPTION:
# Check if the Qt4 libraries are built with the USE flags listed in
# $QT4_BUILT_WITH_USE_CHECK.
#
# Check if a list of packages are built with certain USE flags, as listed in
# $KDE4_BUILT_WITH_USE_CHECK.
#
# If any of the required USE flags are missing, an eerror will be printed for
# each package with missing USE flags.
kde4-functions_check_use() {
	# I like to keep flags sorted
	QT4_BUILT_WITH_USE_CHECK=$(echo "${QT4_BUILT_WITH_USE_CHECK}" | \
		tr '[:space:]' '\n' | sort | xargs)

	KDE4_BUILT_WITH_USE_CHECK="x11-libs/qt:4 ${QT4_BUILT_WITH_USE_CHECK}
				${KDE4_BUILT_WITH_USE_CHECK}"

	local line missing
	while read line; do
		[[ -z ${line} ]] && continue
		if ! _kde4-functions_built_with_use ${line}; then
			missing=true
		fi
	done <<< "${KDE4_BUILT_WITH_USE_CHECK}"
	if [[ -n ${missing} ]]; then
		echo
		eerror "Flags marked with an * are missing."
		die "Missing USE flags found"
	fi
}
