# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-pdf-viewer/claws-mail-pdf-viewer-0.9.3.ebuild,v 1.4 2013/01/03 01:14:29 fauli Exp $

inherit eutils

MY_P="${P#claws-mail-}"
MY_P="${MY_P/-/_}"

DESCRIPTION="A plugin for Claws to display PDF files directly"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86"
IUSE=""
CDEPEND=">=mail-client/claws-mail-3.9.0"
RDEPEND="app-text/ghostscript-gpl"
DEPEND="${CDEPEND}
		app-text/poppler
		virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
