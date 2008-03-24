# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/glpk/glpk-4.27.ebuild,v 1.1 2008/03/24 23:05:48 bicatali Exp $

DESCRIPTION="GNU Linear Programming Kit"
LICENSE="GPL-2"
HOMEPAGE="http://www.gnu.org/software/glpk/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0"
IUSE="doc"
KEYWORDS="~x86 ~amd64 ~ppc"

DEPEND=">=sys-devel/gcc-3.2
		virtual/libc
		doc? ( virtual/ghostscript )"
RDEPEND="virtual/libc"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# INSTALL include some usage docs
	dodoc AUTHORS ChangeLog INSTALL NEWS README || \
		die "failed to install docs"

	# 385Kb
	insinto /usr/share/doc/${PF}/examples
	doins examples/*.{c,mod,lp,mps,dat} || \
		die "failed to install examples"

	# manual/ is 2.5Mb in size
	if use doc; then
		cd "${S}"/doc
		dvipdf refman.dvi
		dvipdf lang.dvi
		insinto /usr/share/doc/${PF}/manual
		doins *.pdf || die "failed to install manual files"
		docinto manual
		dodoc *.txt || die "failed to install manual txt"
	fi
}
