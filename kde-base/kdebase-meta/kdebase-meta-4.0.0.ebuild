# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-meta/kdebase-meta-4.0.0.ebuild,v 1.1 2008/01/17 23:45:45 philantrop Exp $

EAPI="1"

inherit kde4-functions

DESCRIPTION="kdebase - merge this to pull in all kdebase-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="kde-4"

IUSE=""

RDEPEND="
	>=kde-base/dolphin-${PV}:${SLOT}
	>=kde-base/drkonqi-${PV}:${SLOT}
	>=kde-base/kappfinder-${PV}:${SLOT}
	>=kde-base/kcmshell-${PV}:${SLOT}
	>=kde-base/kcontrol-${PV}:${SLOT}
	>=kde-base/kde-menu-${PV}:${SLOT}
	>=kde-base/kdebugdialog-${PV}:${SLOT}
	>=kde-base/kdebase-startkde-${PV}:${SLOT}
	>=kde-base/kdm-${PV}:${SLOT}
	>=kde-base/keditbookmarks-${PV}:${SLOT}
	>=kde-base/kfile-${PV}:${SLOT}
	>=kde-base/kioclient-${PV}:${SLOT}
	>=kde-base/klipper-${PV}:${SLOT}
	>=kde-base/kmenuedit-${PV}:${SLOT}
	>=kde-base/kmimetypefinder-${PV}:${SLOT}
	>=kde-base/knetattach-${PV}:${SLOT}
	>=kde-base/knewstuff-${PV}:${SLOT}
	>=kde-base/kpasswdserver-${PV}:${SLOT}
	>=kde-base/kquitapp-${PV}:${SLOT}
	>=kde-base/kscreensaver-${PV}:${SLOT}
	>=kde-base/kstart-${PV}:${SLOT}
	>=kde-base/ksystraycmd-${PV}:${SLOT}
	>=kde-base/ktimezoned-${PV}:${SLOT}
	>=kde-base/ktip-${PV}:${SLOT}
	>=kde-base/ktraderclient-${PV}:${SLOT}
	>=kde-base/kuiserver-${PV}:${SLOT}
	>=kde-base/konsole-${PV}:${SLOT}
	>=kde-base/kurifilter-plugins-${PV}:${SLOT}
	>=kde-base/kwrite-${PV}:${SLOT}
	>=kde-base/nsplugins-${PV}:${SLOT}
	>=kde-base/soliduiserver-${PV}:${SLOT}
"
