# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kuickshow/kuickshow-3.5.10.ebuild,v 1.3 2009/06/03 14:21:53 ranger Exp $

KMNAME=kdegraphics
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE: A fast and versatile image viewer"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-libs/libXext
	media-libs/imlib"
