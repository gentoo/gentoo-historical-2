# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gerris/gerris-0.8.0.ebuild,v 1.1 2005/11/27 12:28:59 markusle Exp $


DESCRIPTION="The Gerris Flow Solver"
LICENSE="GPL-2"
HOMEPAGE="http://gfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/gfs/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND=">=dev-libs/glib-2.4.0
		>=sci-libs/gts-0.7.4
		sys-apps/gawk
		sys-devel/libtool
		dev-lang/python"

src_compile() {
	# disable explicit building of tutorial
	sed -e "s:tutorial::" -i doc/Makefile.am || \
		die "failed to disable building of tutorial"
	sed -e "s:tutorial::" -i doc/Makefile.in || \
		die "failed to disable building of tutorial"

	# disable mpi for now, since it causes TEXTRELS
	# in the shared libs
	local myconf="--disable-mpi"

	econf ${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	# extended documentation
	if use doc; then
		dohtml doc/html/*

		insinto /usr/share/doc/${P}/examples
		doins -r doc/examples/*

		insinto /usr/share/doc/${P}/tutorial
		doins doc/tutorial/tutorial.pdf

		insinto /usr/share/doc/${P}/faq
		doins doc/faq/faq.pdf
	fi
}
