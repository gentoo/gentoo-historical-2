# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mysql-workbench/mysql-workbench-5.2.16.ebuild,v 1.1 2010/02/17 19:34:23 graaff Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2 eutils flag-o-matic autotools

MY_P="${PN}-oss-${PV}"

DESCRIPTION="MySQL Workbench"
HOMEPAGE="http://dev.mysql.com/workbench/"
SRC_URI="mirror://mysql/Downloads/MySQLGUITools/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls readline static-libs"

RDEPEND=">=x11-libs/gtk+-2.6
	dev-libs/glib:2
	gnome-base/libglade:2.0
	dev-libs/libsigc++:2
	dev-libs/boost
	>=dev-libs/libxml2-2.6.2
	>=dev-cpp/glibmm-2.14
	>=dev-cpp/gtkmm-2.4
	dev-libs/libzip
	>=virtual/mysql-5.0
	dev-libs/libpcre
	virtual/opengl
	>=dev-lang/lua-5.1[deprecated]
	gnome-base/libgnome
	x11-libs/pango
	|| ( sys-libs/e2fsprogs-libs
		dev-libs/ossp-uuid )
	>=x11-libs/cairo-1.5.12[svg]
	dev-python/pexpect
	dev-python/paramiko
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	>=dev-cpp/ctemplate-0.95
	dev-util/pkgconfig"

S="${WORKDIR}"/"${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/mysql-workbench-5.2.15-configure.in.pythonlib.patch"
	epatch "${FILESDIR}/mysql-workbench-5.2.15-as-needed.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls i18n) \
		$(use_enable readline readline) \
		$(use_enable debug) \
		$(use_enable static-libs static) \
		--with-system-ctemplate
}
