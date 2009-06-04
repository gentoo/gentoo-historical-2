# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-meta/kdebase-meta-4.2.4.ebuild,v 1.1 2009/06/04 11:48:22 alexxy Exp $

EAPI="2"

DESCRIPTION="Merge this to pull in all kdebase-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kdeprefix semantic-desktop"

RDEPEND="
	!kde-base/kdebase-runtime-meta
	!kde-base/kdebase-workspace-meta
	>=kde-base/dolphin-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/drkonqi-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kappfinder-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kcheckpass-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kcminit-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kcmshell-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kcontrol-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kde-menu-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kde-menu-icons-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kde-wallpapers-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdebase-cursors-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdebase-data-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdebase-desktoptheme-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdebase-kioslaves-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdebase-startkde-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdebugdialog-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdedglobalaccel-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdepasswd-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdesu-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdialog-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdm-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/keditbookmarks-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kephal-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kfile-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kfind-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/khelpcenter-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/khotkeys-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kiconfinder-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kinfocenter-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kioclient-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/klipper-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kmenuedit-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kmimetypefinder-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/knetattach-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/knewstuff-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/konqueror-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/konsole-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kpasswdserver-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kquitapp-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kscreensaver-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ksmserver-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ksplash-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kstart-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kstartupconfig-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kstyles-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ksysguard-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ksystraycmd-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ktimezoned-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/ktraderclient-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kuiserver-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kurifilter-plugins-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kwalletd-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kwin-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kwrite-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kwrited-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libkonq-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libkworkspace-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libplasmaclock-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libtaskmanager-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/nsplugins-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/phonon-kde-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/plasma-apps-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/plasma-workspace-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/powerdevil-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/renamedlg-plugins-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/solid-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/solid-hardware-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/soliduiserver-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/systemsettings-${PV}:${SLOT}[kdeprefix=]
	semantic-desktop? ( >=kde-base/nepomuk-${PV}:${SLOT}[kdeprefix=] )
"
