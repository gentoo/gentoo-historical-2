# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/gnus/gnus-5.10.8.ebuild,v 1.14 2007/12/01 16:04:21 ulm Exp $

inherit elisp

DESCRIPTION="The Gnus newsreader and mail-reader"
HOMEPAGE="http://www.gnus.org/"
SRC_URI="http://quimby.gnus.org/gnus/dist/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND="!app-emacs/gnus-cvs
	!app-emacs/ngnus"

SITEFILE=70${PN}-gentoo.el

src_compile() {
	local myconf
	myconf="${myconf} --without-w3 --without-url"
	econf \
		--with-emacs \
		--with-lispdir=${SITELISP}/${PN} \
		--with-etcdir=${SITEETC} \
		${myconf} || die "econf failed"
	emake || die
}

src_install() {
	einstall \
		lispdir="${D}${SITELISP}/${PN}" \
		etcdir="${D}${SITEETC}" \
		|| die "einstall failed"

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc ChangeLog GNUS-NEWS README todo

	# fix info documentation
	find "${D}/usr/share/info" -type f -exec mv {} {}.info \;
}
