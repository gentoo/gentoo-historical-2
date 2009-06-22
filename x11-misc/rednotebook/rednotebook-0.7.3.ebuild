# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/rednotebook/rednotebook-0.7.3.ebuild,v 1.1 2009/06/22 08:44:34 hwoarang Exp $

NEED_PYTHON="2.5"
inherit distutils

DESCRIPTION="A graphical journal with calendar, templates, tags, keyword searching, and export functionality"
HOMEPAGE="http://digitaldump.wordpress.com/projects/rednotebook/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pyyaml
	>=dev-python/pygtk-2.13"
