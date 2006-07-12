# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libjit/libjit-0.0.6.ebuild,v 1.1 2006/07/12 12:38:59 tcort Exp $

inherit eutils

DESCRIPTION="libjit implements Just-In-Time compilation functionality and is designed to be independent of any particular virtual machine bytecode format or language"
HOMEPAGE="http://www.southern-storm.com.au/libjit.html"
SRC_URI="http://www.southern-storm.com.au/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc examples interpreter long-double new-reg-alloc"

DEPEND="doc? ( app-text/texi2html )"

src_compile() {
	econf $(use_enable interpreter) \
		$(use_enable long-double) \
		$(use_enable new-reg-alloc) \
		|| die "configure failed"

	emake || die "emake failed"

	if use doc ; then
		if [ ! -f "${S}"/doc/libjit.texi ] ; then
			die "libjit.texi was not generated"
		fi

		texi2html -split_chapter "${S}"/doc/libjit.texi \
			|| die "texi2html failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README

	if use examples ; then
		docinto examples
		dodoc tutorial/{README,*.c}
	fi

	if use doc ; then
		docinto html
		dohtml libjit/*.html
	fi
}
