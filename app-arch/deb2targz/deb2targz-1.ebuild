# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/deb2targz/deb2targz-1.ebuild,v 1.12 2008/09/29 01:48:55 vapier Exp $

DESCRIPTION="Convert a .deb file to a .tar.gz archive"
HOMEPAGE="http://www.miketaylor.org.uk/tech/deb/"
SRC_URI="http://www.miketaylor.org.uk/tech/deb/${PN}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${PN} "${S}"
}

src_install() {
	dobin ${PN}
}
