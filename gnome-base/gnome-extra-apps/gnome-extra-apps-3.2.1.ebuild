# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-extra-apps/gnome-extra-apps-3.2.1.ebuild,v 1.1 2011/11/07 07:49:02 tetromino Exp $

EAPI="4"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="http://www.gnome.org/"
LICENSE="as-is"
SLOT="3.0"
IUSE="+shotwell +tracker"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# New package
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-arch/file-roller-${PV}
	>=games-board/aisleriot-${PV}
	>=gnome-extra/bug-buddy-2.32.0:2
	>=gnome-extra/gcalctool-6.2.0
	>=gnome-extra/gconf-editor-3.0.0
	>=gnome-extra/gnome-games-${PV}
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweak-tool-${PV}
	>=gnome-extra/gnome-utils-${PV}
	>=gnome-extra/gucharmap-${PV}:2.90
	>=gnome-extra/sushi-0.2.1
	>=mail-client/evolution-${PV}
	>=media-sound/sound-juicer-2.99
	>=media-video/cheese-${PV}
	>=net-analyzer/gnome-nettool-3.0.0
	>=net-misc/vinagre-${PV}
	>=net-misc/vino-${PV}
	>=www-client/epiphany-${PV}

	shotwell? ( >=media-gfx/shotwell-0.11 )
	tracker? (
		>=app-misc/tracker-0.12
		>=gnome-extra/gnome-documents-0.2.1 )
"
# Note: bug-buddy is broken with GNOME 3
DEPEND=""
S=${WORKDIR}
