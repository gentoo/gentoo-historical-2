# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/sysprof/sysprof-1.0.12-r1.ebuild,v 1.1 2009/05/27 11:02:05 remi Exp $

inherit eutils linux-mod

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://www.daimi.au.dk/~sandmann/sysprof/"
SRC_URI="http://www.daimi.au.dk/~sandmann/sysprof/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6
	x11-libs/pango
	>=gnome-base/libglade-2"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

pkg_setup() {
	MODULE_NAMES="sysprof-module(misc:${S}/module)"
	CONFIG_CHECK="PROFILING"
	PROFILING_ERROR="You need to enable Profiling support in your kernel. \
For this you need to enable 'Profiling support' under 'Instrumentation Support'. \
It is marked CONFIG_PROFILING in the config file"
	BUILD_TARGETS="all"
	linux-mod_pkg_setup
}

src_compile() {
	econf --disable-kernel-module || die
	emake || die
	linux-mod_src_compile
}

src_install() {
	make install DESTDIR="${D}" || die
	linux-mod_src_install
	dodoc AUTHORS ChangeLog NEWS README TODO
	make_desktop_entry sysprof Sysprof sysprof-icon
}

pkg_postinst() {
	linux-mod_pkg_postinst
	einfo "On many systems, especially amd64, it is typical that with a modern"
	einfo "toolchain -fomit-frame-pointer for gcc is the default, because"
	einfo "debugging is still possible thanks to gcc4/gdb location list feature."
	einfo "However sysprof is not able to construct call trees if frame pointers"
	einfo "are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested"
	einfo "for the libraries and applications involved in the profiling. That"
	einfo "means a CPU register is used for the frame pointer instead of other"
	einfo "purposes, which means a very minimal performance loss when there is"
	einfo "register pressure."
}
