# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glyr/glyr-0_pre20120109.ebuild,v 1.1 2012/01/09 15:29:33 ssuominen Exp $

EAPI=4
inherit cmake-utils

DESCRIPTION="A music related metadata searchengine, both with commandline interface and C API"
HOMEPAGE="http://github.com/sahib/glyr"
SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite:3
	>=dev-libs/glib-2.10
	net-misc/curl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="AUTHORS CHANGELOG README* TODO"
