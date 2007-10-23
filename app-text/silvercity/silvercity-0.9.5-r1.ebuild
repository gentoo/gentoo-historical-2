# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/silvercity/silvercity-0.9.5-r1.ebuild,v 1.6 2007/10/23 15:52:36 jokey Exp $

inherit distutils

DESCRIPTION="A lexical analyser for many langauges."
HOMEPAGE="http://silvercity.sourceforge.net/"

MY_P=${P/silvercity/SilverCity}
SRC_URI="mirror://sourceforge/silvercity/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc-macos sparc x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3"

src_install() {
	distutils_src_install

	# fix permissions - sec bug 93558
	chmod -R a-w ${D}

	# fix CR/LF issue
	find ${D}/usr/bin -iname "*.py" -exec sed -e '1s/\r$//' -i \{\} \;

	# fix path
	dosed -i '1s|#!/usr/home/sweetapp/bin/python|#!/usr/bin/env python|' \
		/usr/bin/cgi-styler-form.py || die "dosed failed"
}
