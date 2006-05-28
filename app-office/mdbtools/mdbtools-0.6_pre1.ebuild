# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/mdbtools/mdbtools-0.6_pre1.ebuild,v 1.2 2006/05/28 22:21:14 halcy0n Exp $

inherit eutils

MY_P=${P/_/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A set of libraries and utilities for reading Microsoft Access database (MDB) files"
HOMEPAGE="http://sourceforge.net/projects/mdbtools/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

IUSE="gnome odbc"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/glib-2
	sys-libs/ncurses
	sys-libs/readline
	>=sys-devel/flex-2.5.0
	>=sys-devel/bison-1.35
	gnome? ( >=gnome-base/libglade-2
		>=gnome-base/libgnomeui-2 )
	odbc? ( >=dev-db/unixODBC-2.0 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/${P}-gcc34.patch
	epatch "${FILESDIR}"/${P}-gcc41.patch
}

src_compile() {
	local myconf
	use odbc && myconf="${myconf} --with-unixodbc=/usr"

	econf --enable-sql \
		${myconf} || die "configure failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc COPYING* NEWS README* TODO AUTHORS HACKING ChangeLog

	# add a compat symlink (gmdb2 is not compiled if gnome USE flag is disabled)
	use gnome && dosym gmdb2 /usr/bin/gmdb
}
