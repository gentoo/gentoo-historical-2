# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-fr/myspell-fr-4.5.ebuild,v 1.1 2012/06/13 12:47:39 scarabeus Exp $

EAPI=4

MYSPELL_DICT=(
	"fr-moderne.aff"
	"fr-moderne.dic"
	"fr-classique.aff"
	"fr-classique.dic"
	"fr-classique+reforme1990.aff"
	"fr-classique+reforme1990.dic"
	"fr-reforme1990.aff"
	"fr-reforme1990.dic"
)

MYSPELL_HYPH=(
	"hyph_fr.dic"
)

MYSPELL_THES=(
	"thes_fr.dat"
	"thes_fr.idx"
)

inherit myspell-r2

DESCRIPTION="French dictionaries for myspell/hunspell"
HOMEPAGE="http://extensions.libreoffice.org/extension-center/dictionnaires-francais"
SRC_URI="
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-moderne-v${PV}.oxt
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-classique-v${PV}.oxt
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-classique-reforme1990-v${PV}.oxt
	http://extensions.libreoffice.org/extension-center/dictionnaires-francais/releases/${PV}/ooo-dictionnaire-fr-reforme1990-v${PV}.oxt
"

LICENSE="GPL-2 LGPL-2.1 MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-linux ~x86-macos"
IUSE=""
