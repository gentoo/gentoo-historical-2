# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latex-calendar/latex-calendar-3.1.ebuild,v 1.3 2003/10/28 08:41:37 usata Exp $

inherit latex-package

MY_P="calendar"
S=${WORKDIR}/${MY_P}
DESCRIPTION="LaTeX package used to create Calendars.  Very flexible and robust."
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/calendar/"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 sparc ppc"

src_compile() {
	debug-print function $FUNCNAME $*
	cd ${S}
	echo "Extracting from allcal.ins"
	( yes | latex allcal.ins ) >/dev/null 2>&1
}

src_install() {
	cd ${S}
	texi2dvi -q -c --language=latex calguide.tex &> /dev/null
	latex-package_src_doinstall styles fonts bin dvi
	dodoc README MANIFEST CATALOG
	insinto /usr/share/doc/${P}/samples
	doins bigdemo.tgz *.cfg *.tex *.cld
}
