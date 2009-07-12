# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/cervisia/cervisia-3.5.10.ebuild,v 1.6 2009/07/12 09:52:08 armin76 Exp $

KMNAME=kdesdk
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="Cervisia - A KDE CVS frontend"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"

RDEPEND="${RDEPEND}
	dev-util/cvs"
HOMEPAGE="http://cervisia.kde.org"
