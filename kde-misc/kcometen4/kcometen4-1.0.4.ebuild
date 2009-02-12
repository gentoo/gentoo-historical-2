# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kcometen4/kcometen4-1.0.4.ebuild,v 1.1 2009/02/12 19:43:29 hwoarang Exp $

EAPI="2"

OPENGL_REQUIRED="always"

inherit kde4-base

HOMEPAGE="http://www.kde-apps.org/content/show.php?content=87586&forumpage=1&PHPSESSID=e5af"
DESCRIPTION="OpenGL KDE4 screensaver"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/87586-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	>=kde-base/kscreensaver-4.1.4[opengl]
	media-libs/libart_lgpl
	virtual/opengl"
RDEPEND="${DEPEND}"
