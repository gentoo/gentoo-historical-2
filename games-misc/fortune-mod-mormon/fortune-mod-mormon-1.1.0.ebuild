# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-mormon/fortune-mod-mormon-1.1.0.ebuild,v 1.7 2010/10/08 03:53:21 leio Exp $

DESCRIPTION="Fortune modules from the LDS scriptures (KJV Bible, Book of Mormon, D&C, PGP)"
HOMEPAGE="http://scriptures.nephi.org/"
SRC_URI="mirror://sourceforge/mormon/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="games-misc/fortune-mod
	games-misc/fortune-mod-scriptures"

src_install() {
	dodoc ChangeLog README
	insinto /usr/share/fortune
	doins mods/dc mods/dc.dat mods/mormon mods/mormon.dat mods/pgp || die
	doins mods/scriptures.dat mods/scriptures mods/aof.dat mods/aof || die
}
