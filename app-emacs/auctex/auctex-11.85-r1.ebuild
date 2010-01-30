# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/auctex/auctex-11.85-r1.ebuild,v 1.2 2010/01/30 21:58:51 ulm Exp $

EAPI=3

inherit elisp eutils latex-package

DESCRIPTION="Extended support for writing, formatting and using (La)TeX, Texinfo and BibTeX files"
HOMEPAGE="http://www.gnu.org/software/auctex/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="preview-latex"

DEPEND="virtual/latex-base
	preview-latex? ( !dev-tex/preview-latex
		app-text/dvipng
		app-text/ghostscript-gpl )"
RDEPEND="${DEPEND}"

TEXMF="/usr/share/texmf-site"

src_configure() {
	# Remove broken Info file (will be recreated by the build system)
	rm doc/auctex.info

	EMACS_NAME=emacs EMACS_FLAVOUR=emacs econf --disable-build-dir-test \
		--with-auto-dir="${EPREFIX}/var/lib/auctex" \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-packagelispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-packagedatadir="${EPREFIX}${SITEETC}/${PN}" \
		--with-texmf-dir="${EPREFIX}${TEXMF}" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable preview-latex preview) || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
	cd doc; emake tex-ref.pdf || die "creation of tex-ref.pdf failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el" || die
	if use preview-latex; then
		elisp-site-file-install "${FILESDIR}/60${PN}-gentoo.el" || die
	fi
	keepdir /var/lib/auctex
	dodoc ChangeLog CHANGES README RELEASE TODO FAQ INSTALL*
}

pkg_postinst() {
	# rebuild TeX-inputfiles-database
	use preview-latex && latex-package_pkg_postinst
	elisp-site-regen
}

pkg_postrm(){
	use preview-latex && latex-package_pkg_postrm
	elisp-site-regen
}
