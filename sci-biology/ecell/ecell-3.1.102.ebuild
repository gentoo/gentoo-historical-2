# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/ecell/ecell-3.1.102.ebuild,v 1.2 2004/12/28 20:27:57 ribosome Exp $

inherit eutils

DESCRIPTION="Software suite for modelling biological cells"
HOMEPAGE="http://ecell.sourceforge.net/"
SRC_URI="mirror://sourceforge/ecell/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc gtk"

DEPEND="dev-libs/boost
	dev-lang/python
	dev-python/numeric
	sci-libs/gsl
	dev-python/empy
	gtk? ( gnome-base/libglade )
	doc? ( media-gfx/graphviz app-doc/doxygen )"

src_compile() {
	econf `use_enable gtk`
	emake
	if use doc; then
		emake doc
	fi
}

src_install() {
	einstall || die
	if use doc; then
		dohtml doc/refman/html
	fi
}
