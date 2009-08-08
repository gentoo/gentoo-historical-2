# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/setools/setools-3.3.6.ebuild,v 1.1 2009/08/08 00:31:11 pebenito Exp $

inherit java-pkg-opt-2 autotools

DESCRIPTION="SELinux policy tools"
HOMEPAGE="http://www.tresys.com/selinux/selinux_policy_tools.shtml"
SRC_URI="http://oss.tresys.com/projects/setools/chrome/site/dists/${PN}-${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X debug java python"

DEPEND=">=sys-libs/libsepol-2.0.37
	sys-libs/libselinux
	sys-devel/bison
	sys-devel/flex
	>=dev-db/sqlite-3.2
	dev-libs/libxml2
	dev-util/pkgconfig
	java? (
		>=dev-lang/swig-1.3.28
		>=virtual/jdk-1.4
	)
	python? (
		>=dev-lang/python-2.4
		>=dev-lang/swig-1.3.28
	)
	X? (
		>=dev-lang/tk-8.4.9
		>=gnome-base/libglade-2.0
		>=x11-libs/gtk+-2.8
	)"

RDEPEND=">=sys-libs/libsepol-2.0.37
	sys-libs/libselinux
	>=dev-db/sqlite-3.2
	dev-libs/libxml2
	java? ( >=virtual/jre-1.4 )
	python? ( >=dev-lang/python-2.4 )
	X? (
		>=dev-lang/tk-8.4.9
		>=dev-tcltk/bwidget-1.8
		>=gnome-base/libglade-2.0
		>=x11-libs/gtk+-2.8
	)"

src_unpack() {
	unpack ${A}

	# fix libqpol include Makefile
	sed -i -r -e '/polcap_query\.h/s/$/ \\/' "${S}/libqpol/include/qpol/Makefile.am"
	eautomake
}

src_compile() {
	econf \
		--with-java-prefix=${JAVA_HOME} \
		--disable-selinux-check \
		--disable-bwidget-check \
		$(use_enable python swig-python) \
		$(use_enable java swig-java) \
		$(use_enable X swig-tcl) \
		$(use_enable X gui) \
		$(use_enable debug)

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed."
}
