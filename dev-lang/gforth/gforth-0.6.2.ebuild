# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gforth/gforth-0.6.2.ebuild,v 1.14 2009/09/23 16:50:41 patrick Exp $

inherit elisp-common eutils toolchain-funcs

DESCRIPTION="GNU Forth is a fast and portable implementation of the ANSI Forth language"
HOMEPAGE="http://www.gnu.org/software/gforth"
SRC_URI="http://www.complang.tuwien.ac.at/forth/gforth//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="emacs"

DEPEND="emacs? ( virtual/emacs )"

SITEFILE=50gforth-gentoo.el

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/gforth.el-gentoo.patch || die
}

src_compile() {
	econf CC="$(tc-getCC) -fno-reorder-blocks -fno-inline" --enable-force-reg || die "econf failed"
	make || die
	use emacs && emacs --batch -f batch-byte-compile --no-site-file --no-init-file *.el
}

src_install() {
	make \
		libdir=${D}/usr/lib \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		datadir=${D}/usr/share \
		bindir=${D}/usr/bin \
		install || die

	dodoc AUTHORS BUGS ChangeLog NEWS* README* ToDo doc/glossaries.doc doc/*.ps

	if use emacs; then
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install ${FILESDIR}/${SITEFILE}
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
