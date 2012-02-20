# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/libiodbc/libiodbc-3.52.7-r1.ebuild,v 1.2 2012/02/20 15:57:31 scarabeus Exp $

EAPI=4

inherit eutils

DESCRIPTION="ODBC Interface for Linux."
HOMEPAGE="http://www.iodbc.org/"
SRC_URI="http://www.iodbc.org/downloads/iODBC/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
LICENSE="|| ( LGPL-2 BSD )"
SLOT="0"
IUSE="gtk static-libs"

DEPEND=">=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2
	gtk? ( x11-libs/gtk+:2 )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog NEWS README"

MAKEOPTS="-j1"

src_prepare() {
	sed -i.orig \
		-e '/^cd "$PREFIX"/,/^esac/d' \
		iodbc/install_libodbc.sh || die "sed failed"
	epatch \
		"${FILESDIR}"/libiodbc-3.52.7-debian_bug501100.patch \
		"${FILESDIR}"/libiodbc-3.52.7-debian_bug508480.patch \
		"${FILESDIR}"/libiodbc-3.52.7-gtk.patch \
		"${FILESDIR}"/libiodbc-3.52.7-multilib.patch \
		"${FILESDIR}"/libiodbc-3.52.7-unicode_includes.patch
	chmod -x include/*.h
}

src_configure() {
	econf \
		--with-layout=gentoo \
		--with-iodbc-inidir=yes \
		$(use_enable gtk gui) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -exec rm -f {} +
}
