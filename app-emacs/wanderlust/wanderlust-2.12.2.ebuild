# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/wanderlust/wanderlust-2.12.2.ebuild,v 1.7 2007/10/06 19:43:19 ulm Exp $

inherit elisp

MY_P="wl-${PV/_/}"

DESCRIPTION="Wanderlust -- Yet Another Message Interface on Emacsen"
HOMEPAGE="http://www.gohome.org/wl/"
SRC_URI="ftp://ftp.gohome.org/wl/stable/${MY_P}.tar.gz
	ftp://ftp.gohome.org/wl/beta/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha sparc ppc"
IUSE="ssl"

DEPEND=">=app-emacs/apel-10.6
	virtual/flim
	app-emacs/semi
	!app-emacs/wanderlust-cvs"

S="${WORKDIR}/${MY_P}"

src_compile() {
	use ssl && echo "(setq wl-install-utils t)" >> WL-CFG
	make || die
	make info || die
}

src_install() {
	make \
		LISPDIR="${D}"/usr/share/emacs/site-lisp \
		PIXMAPDIR="${D}"/usr/share/wl/icons \
		install || die

	elisp-site-file-install "${FILESDIR}/70wl-gentoo.el" || die

	dodir /usr/share/wl/samples

	insinto /usr/share/wl/samples/ja
	doins samples/ja/*
	insinto /usr/share/wl/samples/en
	doins samples/en/*

	doinfo doc/wl-ja.info doc/wl.info
	dodoc BUGS* ChangeLog INSTALL* README*
}
