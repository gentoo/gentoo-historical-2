# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/unixODBC/unixODBC-2.3.0.ebuild,v 1.5 2010/05/25 15:46:01 hwoarang Exp $

EAPI=3
inherit libtool

DESCRIPTION="A complete ODBC driver manager"
HOMEPAGE="http://www.unixodbc.org/"
SRC_URI="mirror://sourceforge/unixodbc/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="+minimal odbcmanual static-libs"

# needed by libltdl
RDEPEND=">=sys-devel/libtool-2.2.6b
	>=sys-libs/readline-6.0_p4
	>=sys-libs/ncurses-5.6-r2"
# need to set explicitely, flex will be out of system set in future
DEPEND="${RDEPEND}
	sys-devel/flex"

src_prepare() {
	# needed by gfbsd
	elibtoolize
}

src_configure() {
	# fixme: drivers are full of missing string.h includes
	econf \
		--sysconfdir="${EPREFIX}/etc/${PN}" \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable !minimal drivers) \
		$(use_enable !minimal driver-conf)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README || die

	if use prefix; then
		dodoc README* || die
	fi

	# avoid abusing too generic USE doc
	if use odbcmanual; then
		dohtml -a css,gif,html,sql,vsd -r doc/* || die
	fi
}

pkg_postinst() {
	if ! use minimal; then
		einfo
		einfo "Qt4 frontend moved to:"
		einfo "http://sourceforge.net/projects/unixodbc-gui-qt/"
		einfo
		einfo "Please don't open bugs about it before they do a file release."
		einfo
	fi

	# feel free to punt this warning after some time
	ewarn "If you are upgrading from unixODBC 2.2.12 or 2.2.14 to 2.3.0,"
	ewarn "it's good idea to re-emerge all unixODBC reverse dependencies now."
	ewarn "See,"
	ewarn "http://tinderbox.x86.dev.gentoo.org/misc/rindex/dev-db/unixODBC"
	ewarn "http://tinderbox.x86.dev.gentoo.org/misc/dindex/dev-db/unixODBC"
}
