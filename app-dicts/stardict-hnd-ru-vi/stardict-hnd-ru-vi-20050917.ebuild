# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-hnd-ru-vi/stardict-hnd-ru-vi-20050917.ebuild,v 1.3 2007/02/01 14:45:43 blubb Exp $

FROM_LANG="Russian"
TO_LANG="Vietnamese"

inherit stardict

HOMEPAGE="http://forum.vnoss.org/viewtopic.php?id=1818"
SRC_URI="http://james.dyndns.ws/pub/Dictionary/StarDict-James/NgaViet38K.zip"

KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}/NgaViet"

DEPEND="${DEPEND}
	app-arch/unzip"

RDEPEND=">=app-dicts/stardict-2.4.2"
