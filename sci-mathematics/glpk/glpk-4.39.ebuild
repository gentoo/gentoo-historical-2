# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/glpk/glpk-4.39.ebuild,v 1.1 2009/08/14 23:46:55 bicatali Exp $

EAPI=2
inherit flag-o-matic

DESCRIPTION="GNU Linear Programming Kit"
LICENSE="GPL-3"
HOMEPAGE="http://www.gnu.org/software/glpk/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

SLOT="0"
IUSE="doc examples gmp odbc mysql"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="odbc? ( || ( dev-db/libiodbc dev-db/unixODBC ) )
	gmp? ( dev-libs/gmp )
	mysql? ( virtual/mysql )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	local myconf="--disable-dl"
	if use mysql || use odbc; then
		myconf="--enable-dl"
	fi

	[[ -z $(type -P odbc-config) ]] && \
		append-cppflags $(pkg-config --cflags libiodbc)

	econf \
		--with-zlib \
		$(use_with gmp) \
		$(use_enable odbc) \
		$(use_enable mysql) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README || \
		die "failed to install docs"

	insinto /usr/share/doc/${PF}
	if use examples; then
		emake distclean
		doins -r examples || die "failed to install examples"
	fi
	if use doc; then
		cd "${S}"/doc
		doins *.pdf notes/gomory.djvu || die "failed to instal djvu and pdf"
		dodoc *.txt || die "failed to install manual files"
	fi
}
