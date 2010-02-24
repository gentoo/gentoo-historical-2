# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libv4l/libv4l-0.6.1.ebuild,v 1.2 2010/02/24 19:30:19 armin76 Exp $

inherit multilib toolchain-funcs

DESCRIPTION="V4L userspace libraries"
HOMEPAGE="http://people.atrpms.net/~hdegoede/
	http://hansdegoede.livejournal.com/3636.html"
SRC_URI="http://people.atrpms.net/~hdegoede/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

src_compile() {
	tc-export CC
	emake PREFIX="/usr" LIBDIR="/usr/$(get_libdir)" CFLAGS="${CFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake PREFIX="/usr" LIBDIR="/usr/$(get_libdir)" \
		DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README* TODO
}

pkg_postinst() {
	elog
	elog "libv4l includes wrapper libraries for compatibility and pixel format"
	elog "conversion, which are especially useful for users of the gspca usb"
	elog "webcam driver in kernel 2.6.27 and higher."
	elog
	elog "To add v4l2 compatibility to a v4l application 'myapp', launch it via"
	elog "LD_PRELOAD=/usr/$(get_libdir)/libv4l/v4l1compat.so myapp"
	elog "To add automatic pixel format conversion to a v4l2 application, use"
	elog "LD_PRELOAD=/usr/$(get_libdir)/libv4l/v4l2convert.so myapp"
	elog
}
