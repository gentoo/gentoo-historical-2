# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/setools/setools-2.3.ebuild,v 1.1 2006/02/03 13:52:01 pebenito Exp $

inherit eutils

DESCRIPTION="SELinux policy tools"
HOMEPAGE="http://www.tresys.com/selinux/selinux_policy_tools.shtml"
SRC_URI="http://www.tresys.com/files/setools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="X debug selinux"

S="${WORKDIR}/${PN}"

DEPEND="sys-devel/bison
	sys-devel/flex
	dev-libs/libxml2
	dev-util/pkgconfig
	selinux? ( sys-libs/libselinux )
	X? (
		dev-lang/tk
		>=gnome-base/libglade-2.0
	)"

RDEPEND="dev-libs/libxml2
	selinux? ( sys-libs/libselinux )
	X? (
		dev-lang/tk
		>=dev-tcltk/bwidget-1.4.1
		>=gnome-base/libglade-2.0
	)"

src_unpack() {
	unpack ${A}
	cd ${S}

	# enable debug if requested
	useq debug && sed -i -e '/^DEBUG/s/0/1/' ${S}/Makefile

	# dont do findcon, replcon, searchcon, or indexcon if USE=-selinux
	if ! useq selinux; then
		sed -i -e '/^USE_LIBSELINUX/s/1/0/' ${S}/Makefile
		sed -i -e '/^SE_CMDS/s/replcon//' \
			-e '/^SE_CMDS/s/findcon//' \
			-e '/^SE_CMDS/s/searchcon//' \
			-e '/^SE_CMDS/s/indexcon//' ${S}/secmds/Makefile
	fi
}

src_compile() {
	cd ${S}

	if useq X; then
		make CC_DEFINES="${CFLAGS}" all || die
	else
		make CC_DEFINES="${CFLAGS}" all-nogui || die
	fi
}

src_install() {
	cd ${S}

	# some of the Makefiles are broken, and will fail
	# if ${D}/usr/bin is nonexistant
	dodir /usr/bin

	if use X; then
		make DESTDIR=${D} install || die "install failed."
	else
		make DESTDIR=${D} install-nogui || die "install failed."
	fi
}
