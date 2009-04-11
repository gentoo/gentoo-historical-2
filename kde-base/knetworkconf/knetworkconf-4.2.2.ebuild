# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knetworkconf/knetworkconf-4.2.2.ebuild,v 1.1 2009/04/11 23:33:09 alexxy Exp $

EAPI="2"

KMNAME="kdeadmin"
inherit kde4-meta

DESCRIPTION="KDE control Center Module to confiure Network settings"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug"

PATCHES=( "${FILESDIR}/backends-scriptsdir.patch" )
