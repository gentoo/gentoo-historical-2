# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/auctex/auctex-11.13.ebuild,v 1.1 2003/02/09 11:00:24 mkennedy Exp $

inherit elisp 

IUSE=""

DESCRIPTION="AUC TeX is an extensible package that supports writing and formatting TeX files"
HOMEPAGE="http://mirrors.sunsite.dk/auctex/www/auctex/"
SRC_URI="http://savannah.nongnu.org/download/auctex/stable.pkg/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="virtual/emacs
	app-text/tetex"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd ${S} && sed -e 's,/usr/local/lib/texmf/tex/,/usr/share/texmf/tex/,g' tex.el >tex.el.new \
		&& mv tex.el.new tex.el || die
}

src_compile() {
	make || die
}

src_install() {
	dodir ${SITELISP}/auctex
	make lispdir=${D}/${SITELISP} install install-contrib || die
	# this is insane...
	pushd ${D}/${SITELISP}
	sed -e "s,${D}/,,g" tex-site.el >tex-site.el.new && \
		mv tex-site.el.new tex-site.el || die
	popd
	pushd doc
	dodir /usr/share/info
	make infodir=${D}/usr/share/info install || die
	popd
 	elisp-site-file-install ${FILESDIR}/50auctex-gentoo.el
 	dodoc ChangeLog CHANGES COPYING INSTALLATION PROBLEMS README 
}

pkg_postinst() {
	elisp-site-regen
}

pkg_postrm() {
	elisp-site-regen
}
