# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksmserver/ksmserver-4.2.1.ebuild,v 1.1 2009/03/04 22:17:13 alexxy Exp $

EAPI="2"

KMNAME="kdebase-workspace"
inherit kde4-meta

DESCRIPTION="The reliable KDE session manager that talks the standard X11R6"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/kcminit-${PV}:${SLOT}
	>=kde-base/libkworkspace-${PV}:${SLOT}
	>=kde-base/solid-${PV}:${SLOT}"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="kcminit/main.h
	libs/kworkspace/
	solid/"

KMLOADLIBS="libkworkspace"
