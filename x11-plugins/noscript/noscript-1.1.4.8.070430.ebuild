# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/noscript/noscript-1.1.4.8.070430.ebuild,v 1.1 2007/05/04 17:09:39 armin76 Exp $

inherit mozextension multilib

DESCRIPTION="Firefox plugin to disable javascript"
HOMEPAGE="http://noscript.net/"
SRC_URI="http://software.informaction.com/data/releases/${P}.xpi"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=www-client/mozilla-firefox-1.5.0.7"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_unpack() {
	xpi_unpack "${P}".xpi
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/mozilla-firefox"

	xpi_install "${S}"/"${P}"
}
