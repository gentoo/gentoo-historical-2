# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libiptcdata/libiptcdata-1.0.4.ebuild,v 1.1 2009/07/06 22:28:19 eva Exp $

inherit eutils

DESCRIPTION="library for manipulating the International Press Telecommunications
Council (IPTC) metadata"
HOMEPAGE="http://libiptcdata.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="doc examples nls python"

RDEPEND="python? ( dev-lang/python )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.13.1 )
	doc? ( >=dev-util/gtk-doc-1 )"

src_compile () {
	econf $(use_enable nls) \
		$(use_enable python) \
		$(use_enable doc gtk-doc)
	emake || die "emake failed."
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed."

	if use examples; then
		insinto /usr/share/doc/${PF}/python
		doins python/README || die "doins failed"
		doins -r python/examples || die "doins 2 failed"
	fi

	find "${D}" -name '*.la' -delete
}

pkg_postinst() {
	elog "This version of ${PN} has stopped installing .la files. This may"
	elog "cause compilation failures in other packages. To fix this problem,"
	elog "install dev-util/lafilefixer and run:"
	elog "  lafilefixer --justfixit"
}
