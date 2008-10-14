# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/cracklib-words/cracklib-words-20080507.ebuild,v 1.4 2008/10/14 20:03:10 ranger Exp $

DESCRIPTION="large set of crack/cracklib dictionaries"
HOMEPAGE="http://sourceforge.net/projects/cracklib"
SRC_URI="mirror://sourceforge/cracklib/${P}.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/dict
	newins ${P} ${PN} || die
}

pkg_postinst() {
	if [[ ${ROOT} == "/" ]] ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict /usr/share/dict/* > /dev/null
		eend $?
	fi
}
