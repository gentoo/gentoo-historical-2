# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-slackware/fortune-mod-slackware-1.12.ebuild,v 1.2 2006/07/17 05:02:30 vapier Exp $

# this ebuild now uses the offensive flag since AOLS
# is not exactly 'G' rated :)

MY_PN=slack-fortunes-all
DESCRIPTION="This fortune mod is a collection of quotes seen on AOLS (Slackware)"
HOMEPAGE="http://fauxascii.com/linux/mod_quotes.html"
SRC_URI="http://fauxascii.com/linux/data/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE="offensive"

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}

pkg_setup() {
	if ! use offensive ; then
		einfo "These fortunes have offensive content. Enable offensive USE Flag"
		einfo "ex: USE=\"offensive\" emerge ${PN}"
		exit 1
	fi
}

src_unpack() {
	unpack ${A}
	# get rid of md5 checks and one silly extra file
	rm -f *.md5 *~
}

src_install() {
	insinto /usr/share/fortune
	doins * || die "doins failed"
}
