# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkpgp/libkpgp-4.3.1.ebuild,v 1.2 2009/10/10 10:33:14 ssuominen Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE pgp abstraction library"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug"

PATCHES=( "${FILESDIR}/${PN}-4.1.72-fix.patch" )
