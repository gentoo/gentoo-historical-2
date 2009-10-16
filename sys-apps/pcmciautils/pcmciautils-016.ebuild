# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcmciautils/pcmciautils-016.ebuild,v 1.1 2009/10/16 19:19:38 bangert Exp $

inherit eutils flag-o-matic toolchain-funcs linux-info

DESCRIPTION="PCMCIA userspace utilities for Linux kernel 2.6.13 and beyond"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html"
SRC_URI="mirror://kernel/linux/utils/kernel/pcmcia/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sh ~x86"
IUSE="debug static staticsocket"

RDEPEND=">=sys-fs/sysfsutils-1.3.0
	>=sys-apps/module-init-tools-3.2_pre4"
DEPEND="${RDEPEND}
	dev-util/yacc
	sys-devel/flex"

CONFIG_CHECK="~PCMCIA"
ERROR_PCMCIA="${P} requires 16-bit PCMCIA support (CONFIG_PCMCIA)"

pkg_setup() {
	linux-info_pkg_setup
	kernel_is lt 2 6 13 && ewarn "${P} requires at least kernel 2.6.13."
}

use_tf() { use $1 && echo true || echo false ; }
src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^DEBUG\>/s:=.*:= false:' \
		-e '/^UDEV\>/s:=.*:= true:' \
		-e '/CFLAGS/s:-fomit-frame-pointer::' \
		-e '/^STATIC\>/s:=.*:= '$(use_tf static)':' \
		-e '/^STARTUP\>/s:=.*:= '$(use_tf staticsocket)':' \
		Makefile || die
	use debug && append-flags -DDEBUG
}

src_compile() {
	emake \
		OPTIMIZATION="${CFLAGS} ${CPPFLAGS}" \
		V="true" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		STRIP="true" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc doc/*.txt
}

pkg_postinst() {
	ewarn "If you relied on pcmcia-cs to automatically load the appropriate"
	ewarn "PCMCIA-related modules upon boot, you need to add 'pcmcia' and the"
	ewarn "PCMCIA socket driver you need for this system (yenta-socket,"
	ewarn "i82092, i82365, ...) to /etc/modules.autoload.d/kernel-2.6"
}
