# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/auctex/auctex-11.52.ebuild,v 1.1 2004/08/24 09:42:13 usata Exp $

inherit elisp

DESCRIPTION="AUCTeX is an extensible package that supports writing and formatting TeX files"
HOMEPAGE="http://www.gnu.org/software/auctex"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64 ~sparc"
IUSE=""

DEPEND="virtual/emacs
	virtual/tetex"

src_compile() {
	econf --with-auto-dir=${D}/var/lib/auctex \
		--with-tex-input-dirs="/usr/share/texmf/tex/;/usr/share/texmf/bibtex/bst/" || die "econf failed"
	emake || die
}

src_install() {
	einstall || die
	dosed ${SITELISP}/tex-site.el || die
	elisp-site-file-install ${FILESDIR}/50auctex-gentoo.el
	dodoc ChangeLog CHANGES INSTALLATION PROBLEMS README
}
