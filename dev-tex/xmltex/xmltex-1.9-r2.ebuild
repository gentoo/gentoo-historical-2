# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/xmltex/xmltex-1.9-r2.ebuild,v 1.2 2008/09/02 12:11:55 aballier Exp $

inherit latex-package texlive-common

IUSE=""

DESCRIPTION="A non validating namespace aware XML parser implemented in TeX"
HOMEPAGE="http://www.dcarlisle.demon.co.uk/xmltex/manual.html"
# Taken from: ftp://www.ctan.org/tex-archive/macros/xmltex.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"

S=${WORKDIR}/${PN}/base

TEXMF=/usr/share/texmf-site

DEPEND="|| (
	>=app-text/texlive-core-2007
	>=app-text/tetex-2.96
	>=app-text/ptex-3.1.4.20041026
	)"
RDEPEND="${DEPEND}
	!=dev-texlive/texlive-htmlxml-2007*"

src_compile() {
	TEXMFHOME="${S}" fmtutil --cnffile "${FILESDIR}/format.${PN}.cnf" --fmtdir "${S}/texmf-var/web2c" --all\
			|| die "failed to build format ${PN}"
}

src_install() {
	insinto /var/lib/texmf
	doins -r texmf-var/* || die "failed to install ${PN} formats"

	insinto ${TEXMF}/tex/xmltex/base
	doins *.{xmt,cfg,xml,tex}
	insinto ${TEXMF}/tex/xmltex/config
	doins *.ini

	etexlinks "${FILESDIR}/format.${PN}.cnf"
	insinto /etc/texmf/fmtutil.d
	doins "${FILESDIR}/format.${PN}.cnf"

	dohtml *.html
	dodoc readme.txt
}
