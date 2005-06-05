# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/vilearn/vilearn-1.0.ebuild,v 1.8 2005/06/05 11:30:47 hansmi Exp $

IUSE=""

DESCRIPTION="vilearn is an interactive vi tutorial comprised of 5 tutorials for the vi-impaired."
HOMEPAGE="http://vilearn.org/"
SRC_URI="http://vilearn.org/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ppc x86"
SLOT="0"

RDEPEND="|| (
		app-editors/vim
		app-editors/vi
	)"

src_compile() {

	sed -i "s:/usr/local:/usr:" Makefile
	emake || die "emake failed. :("

}

src_install() {

	dobin vilearn
	doman vilearn.1
	dodoc README outline

	insinto /usr/lib/vilearn
	doins [0-9]*

}
