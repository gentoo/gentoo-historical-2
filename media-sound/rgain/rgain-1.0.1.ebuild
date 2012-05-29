# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rgain/rgain-1.0.1.ebuild,v 1.1 2012/05/29 12:04:27 sochotnicky Exp $

EAPI=4

inherit distutils

DESCRIPTION="Set of programmes and Python modules to deal with Replay Gain information"
HOMEPAGE="http://bitbucket.org/fk/rgain"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/mutagen
		dev-python/gst-python"
RDEPEND="${DEPEND}"
