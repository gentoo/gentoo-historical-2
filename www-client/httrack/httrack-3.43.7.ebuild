# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/httrack/httrack-3.43.7.ebuild,v 1.2 2010/01/01 21:26:19 fauli Exp $

inherit versionator

MY_P="${PN}-$(replace_version_separator 2 '-' )"
DESCRIPTION="HTTrack Website Copier, Open Source Offline Browser"
HOMEPAGE="http://www.httrack.com/"
SRC_URI="http://www.httrack.com/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

src_compile() {
	econf || die
	# won't compile in parallel
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS README greetings.txt history.txt
	dohtml httrack-doc.html
}
