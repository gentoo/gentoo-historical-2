# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/sysprof/sysprof-1.1.8.ebuild,v 1.1 2011/10/30 18:43:18 tetromino Exp $

EAPI="4"

inherit gnome2-utils eutils linux-info

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"
SRC_URI="http://sysprof.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.6:2
	x11-libs/pango
	>=gnome-base/libglade-2:2.0"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS NEWS README TODO" # ChangeLog is empty

pkg_pretend() {
	kernel_is -ge 2 6 31 && return
	die "Sysprof will not work with a kernel version less than 2.6.31"
}

src_install() {
	default

	# Install udev rules in the proper place
	mkdir -p "${D}/lib/udev/rules.d" || die
	mv "${D}/etc/udev/rules.d/"* "${D}/lib/udev/rules.d/" || die
	rm -rf "${D}/etc/udev/rules.d/"

	# Insert icons in the proper place
	for i in 16 24 32 48; do
		insinto "/usr/share/icons/hicolor/${i}x${i}/apps"
		newins "${S}/sysprof-icon-${i}.png" sysprof.png
		rm "${D}/usr/share/pixmaps/sysprof-icon-${i}.png" || die "rm $i failed!"
	done
	make_desktop_entry sysprof Sysprof sysprof
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog "On many systems, especially amd64, it is typical that with a modern"
	elog "toolchain -fomit-frame-pointer for gcc is the default, because"
	elog "debugging is still possible thanks to gcc4/gdb location list feature."
	elog "However sysprof is not able to construct call trees if frame pointers"
	elog "are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested"
	elog "for the libraries and applications involved in the profiling. That"
	elog "means a CPU register is used for the frame pointer instead of other"
	elog "purposes, which means a very minimal performance loss when there is"
	elog "register pressure."
}

pkg_postrm() {
	gnome2_icon_cache_update
}
