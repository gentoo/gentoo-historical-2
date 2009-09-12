# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/youtube-dl/youtube-dl-2009.09.08.ebuild,v 1.1 2009/09/12 08:30:44 patrick Exp $

EAPI="2"

DESCRIPTION="A small command-line program to download videos from YouTube."
HOMEPAGE="http://bitbucket.org/rg3/youtube-dl/"
SRC_URI="http://bitbucket.org/rg3/${PN}/get/${PV}.bz2 -> ${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

src_install() {
	newbin "${PN}/${PN}" ${PN}
}
