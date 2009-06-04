# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev-meta/kdewebdev-meta-4.2.4.ebuild,v 1.1 2009/06/04 12:18:28 alexxy Exp $

EAPI="2"

DESCRIPTION="KDE WebDev - merge this to pull in all kdewebdev-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
# FIXME:
# Add this back when adding kmtrace
# elibc_glibc
IUSE="kdeprefix"

RDEPEND="
	>=kde-base/kfilereplace-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kimagemapeditor-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/klinkstatus-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kommander-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kxsldbg-${PV}:${SLOT}[kdeprefix=]
"
