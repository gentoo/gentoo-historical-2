# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkscan/libkscan-3.5.10.ebuild,v 1.2 2009/05/31 19:25:49 nixnut Exp $

KMNAME=kdegraphics
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE scanner library"
KEYWORDS="~alpha ~amd64 ~hppa ppc ~ppc64 ~sparc ~x86"
LICENSE="LGPL-2"
IUSE=""

DEPEND="media-gfx/sane-backends"
RDEPEND="${DEPEND}"
